USE [SGBiblioteca]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************************
 Descripción          : Registra la devolución de un libro, actualizando el estado del préstamo
                        y la copia del libro. Calcula multas por retraso o pérdida.
 Input                : @p_IdPrestamo        : ID del préstamo que se está devolviendo.
                        @p_FechaDevolucionReal : Fecha real en que el libro fue devuelto.
                        @p_EstadoLibroDevuelto : Estado del libro ('Bueno', 'Dañado', 'Perdido').
                        @p_Observaciones     : Observaciones opcionales sobre la devolución.
 Resultado            : Mensaje de 'OK' o 'ERROR' con detalles y el monto de la multa si aplica.
 Elaborado por        : Noe DIAZ
 Fecha                : 26/05/2025
 Ejecución            :

     Ejemplo: Devolución a tiempo y en buen estado
     DECLARE @IdPrestamoTest BIGINT = (SELECT TOP 1 Id FROM dbo.PRESTAMO WHERE Estado = 'Activo' AND FechaDevolucionPrevista >= GETDATE());
	 Select Top 100 * From 
     EXEC dbo.SP_RegistrarDevolucionLibro  
        @p_IdPrestamo = 1,
        @p_FechaDevolucionReal = '2025-07-26',
        @p_EstadoLibroDevuelto = 'Bueno',
        @p_Observaciones = 'Devuelto en perfecto estado.';

     Ejemplo: Devolución con retraso y multa
     DECLARE @IdPrestamoRetraso BIGINT = (SELECT TOP 1 Id FROM dbo.PRESTAMO WHERE Estado = 'Activo' AND FechaDevolucionPrevista < GETDATE());
     EXEC dbo.SP_RegistrarDevolucionLibro
        @p_IdPrestamo = 1,
        @p_FechaDevolucionReal = '2025-07-26',
        @p_EstadoLibroDevuelto = 'Bueno',
        @p_Observaciones = 'Devuelto con 3 días de retraso.';

     Ejemplo: Libro perdido
     DECLARE @IdPrestamoPerdido BIGINT = (SELECT TOP 1 Id FROM dbo.PRESTAMO WHERE Estado = 'Activo');
     EXEC dbo.SP_RegistrarDevolucionLibro
        @p_IdPrestamo = 1,
        @p_FechaDevolucionReal = '2025-07-26',
        @p_EstadoLibroDevuelto = 'Perdido',
        @p_Observaciones = 'El usuario reportó que el libro se le perdió.';
*********************************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[SP_RegistrarDevolucionLibro]
    @p_IdPrestamo BIGINT,
    @p_FechaDevolucionReal DATETIME,
    @p_EstadoLibroDevuelto VARCHAR(20), -- 'Bueno', 'Dañado', 'Perdido'
    @p_Observaciones TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables para el préstamo y la copia del libro
    DECLARE @PrestamoExiste BIT = 0;
    DECLARE @EstadoActualPrestamo VARCHAR(20);
    DECLARE @FechaDevolucionPrevista DATETIME;
    DECLARE @IdCopiaLibro BIGINT;
    DECLARE @CostoLibroPerdido DECIMAL(10,2) = 50.00; -- Costo fijo de ejemplo para libro perdido

    -- 1. Validar que el préstamo exista y esté en estado 'Activo'
    SELECT
        @PrestamoExiste = 1,
        @EstadoActualPrestamo = Estado,
        @FechaDevolucionPrevista = FechaDevolucionPrevista,
        @IdCopiaLibro = IdCopiaLibro
    FROM dbo.PRESTAMO		--select * from PRESTAMO
    WHERE Id = @p_IdPrestamo;

    IF @PrestamoExiste = 0
    BEGIN
        SELECT 'ERROR: El préstamo especificado no existe.' AS Mensaje;
        RETURN;
    END

    IF @EstadoActualPrestamo <> 'Activo'
    BEGIN
        SELECT 'ERROR: El préstamo ya ha sido ' + @EstadoActualPrestamo + ' y no puede ser devuelto.' AS Mensaje;
        RETURN;
    END

    -- Iniciar Transacción para asegurar la consistencia
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @MultaAplicada DECIMAL(10,2) = 0;
        DECLARE @NuevoEstadoPrestamo VARCHAR(20);
        DECLARE @NuevoEstadoCopia VARCHAR(20);
        DECLARE @ValorCobroPerdida DECIMAL(10,2) = NULL; -- Valor a registrar en PRESTAMO

        -- 2. Lógica de estado y cálculo de multa
        IF @p_EstadoLibroDevuelto = 'Perdido'
        BEGIN
            SET @NuevoEstadoPrestamo = 'Perdido';
            SET @NuevoEstadoCopia = 'Perdido';
            SET @ValorCobroPerdida = @CostoLibroPerdido;
            SET @MultaAplicada = @CostoLibroPerdido; -- La "multa" por pérdida es el costo de reposición
        END
        ELSE IF @p_EstadoLibroDevuelto = 'Dañado'
        BEGIN
            SET @NuevoEstadoPrestamo = 'Devuelto';
            SET @NuevoEstadoCopia = 'Deteriorado';
            -- Podrías añadir lógica para multa por daño aquí si fuera necesario
        END
        ELSE -- 'Bueno'
        BEGIN
            SET @NuevoEstadoPrestamo = 'Devuelto';
            SET @NuevoEstadoCopia = 'Disponible';

            -- Calcular multa por retraso solo si el libro no está perdido
            IF @p_FechaDevolucionReal > @FechaDevolucionPrevista
            BEGIN
                DECLARE @DiasRetraso INT = DATEDIFF(DAY, @FechaDevolucionPrevista, @p_FechaDevolucionReal);
                SET @MultaAplicada = @DiasRetraso * 1.00; -- Asume $1 por día
            END
        END

        -- 3. Actualizar el estado del préstamo
        UPDATE dbo.PRESTAMO
        SET
            FechaDevolucionReal = @p_FechaDevolucionReal,
            Estado = @NuevoEstadoPrestamo,
            ValorCobroPerdida = @ValorCobroPerdida -- Actualiza solo si se establece un valor de cobro por pérdida
        WHERE Id = @p_IdPrestamo;

        -- 4. Actualizar el estado de la COPIA_LIBRO
        UPDATE dbo.COPIA_LIBRO
        SET Estado = @NuevoEstadoCopia
        WHERE Id = @IdCopiaLibro;

        COMMIT TRANSACTION;
        -- Línea corregida
        SELECT 'OK: Devolución de libro registrada exitosamente. Multa Aplicada: ' + CAST(@MultaAplicada AS VARCHAR(20)) AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
GO

/*
  select top 100 * from PRESTAMO
  select top 100 * from COPIA_LIBRO
*/
