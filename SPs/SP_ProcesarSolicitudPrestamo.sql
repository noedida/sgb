USE [SGBiblioteca]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************************
 Descripción          : Procesa una solicitud de préstamo (aprueba o rechaza).
                        Si es aprobada, crea un nuevo registro de préstamo y actualiza
                        el estado de la copia del libro.
 Input                : @p_IdSolicitud           : ID de la solicitud a procesar.
                        @p_IdBibliotecarioAprobador : ID del bibliotecario que realiza la acción.
                        @p_Aprobado               : 1 para aprobar, 0 para rechazar.
                        @p_Observaciones          : Observaciones opcionales del bibliotecario.
                        @p_IdCopiaLibro           : ID de la copia del libro (requerido si se aprueba).
                        @p_FechaDevolucionPrevista: Fecha prevista de devolución (requerido si se aprueba).
 Resultado            : Mensaje de 'OK' o 'ERROR' con detalles.
 Elaborado por        : Noe DIAZ
 Fecha                : 26/05/2025
 Ejecución            :

     Ejemplo: Aprobar una solicitud
     DECLARE @SolicitudPendienteId BIGINT = (SELECT Id FROM dbo.SOLICITUD_PRESTAMO WHERE Estado = 'Pendiente' AND IdUsuario = @IdUsuarioTest);
     DECLARE @BibliotecarioId BIGINT = (SELECT Id FROM dbo.USUARIO WHERE Nivel = 1);
     DECLARE @CopiaLibroId BIGINT = (SELECT Id FROM dbo.COPIA_LIBRO WHERE Estado = 'Disponible');
     EXEC dbo.SP_ProcesarSolicitudPrestamo
        @p_IdSolicitud = 1,
        @p_IdBibliotecarioAprobador = 1,
        @p_Aprobado = 1,
        @p_Observaciones = 'Aprobado y listo para retiro.',
        @p_IdCopiaLibro = 1,
        @p_FechaDevolucionPrevista = '2025-07-26';

     Ejemplo: Rechazar una solicitud
     DECLARE @SolicitudARechazarId BIGINT = (SELECT Id FROM dbo.SOLICITUD_PRESTAMO WHERE Estado = 'Pendiente' AND IdUsuario = @IdUsuarioTest2);
     EXEC dbo.SP_ProcesarSolicitudPrestamo
        @p_IdSolicitud = 4,
        @p_IdBibliotecarioAprobador = 1,
        @p_Aprobado = 0,
        @p_Observaciones = 'Libro no disponible.';
*********************************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[SP_ProcesarSolicitudPrestamo]
    @p_IdSolicitud BIGINT,
    @p_IdBibliotecarioAprobador BIGINT,
    @p_Aprobado BIT, -- 1 para aprobar, 0 para rechazar
    @p_Observaciones TEXT = NULL,
    @p_IdCopiaLibro BIGINT = NULL, -- Solo necesario si @p_Aprobado = 1
    @p_FechaDevolucionPrevista DATETIME = NULL -- Solo necesario si @p_Aprobado = 1
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables de validación
    DECLARE @EstadoActualSolicitud VARCHAR(20);
    DECLARE @SolicitudExiste BIT = 0;
    DECLARE @BibliotecarioExiste BIT = 0;
    DECLARE @NivelBibliotecario INT;
    DECLARE @CopiaLibroExiste BIT = 0;
    DECLARE @EstadoCopiaLibro VARCHAR(20);
    DECLARE @IdLibroSolicitud BIGINT; -- Para verificar que la copia corresponda al libro solicitado
    DECLARE @IdUsuarioSolicitud BIGINT; -- Necesario para insertar en PRESTAMO

    -- 1. Validar que la solicitud exista y esté en estado 'Pendiente'
    SELECT @SolicitudExiste = 1, @EstadoActualSolicitud = Estado, @IdLibroSolicitud = IdLibro, @IdUsuarioSolicitud = IdUsuario
    FROM dbo.SOLICITUD_PRESTAMO
    WHERE Id = @p_IdSolicitud;

    IF @SolicitudExiste = 0
    BEGIN
        SELECT 'ERROR: La solicitud de préstamo no existe.' AS Mensaje;
        RETURN;
    END

    IF @EstadoActualSolicitud <> 'Pendiente'
    BEGIN
        SELECT 'ERROR: La solicitud ya ha sido ' + @EstadoActualSolicitud + ' y no puede ser procesada nuevamente.' AS Mensaje;
        RETURN;
    END

    -- 2. Validar que el bibliotecario exista y tenga el nivel correcto (ej. Nivel 1 para Bibliotecario)
    SELECT @BibliotecarioExiste = 1, @NivelBibliotecario = Nivel
    FROM dbo.USUARIO
    WHERE Id = @p_IdBibliotecarioAprobador AND Activo = 1;

    IF @BibliotecarioExiste = 0 OR @NivelBibliotecario <> 1 -- Asumiendo Nivel 1 es para bibliotecarios
    BEGIN
        SELECT 'ERROR: El ID de bibliotecario es inválido o el usuario no es un bibliotecario activo.' AS Mensaje;
        RETURN;
    END

    -- Lógica para APROBAR la solicitud
    IF @p_Aprobado = 1
    BEGIN
        -- Validar campos obligatorios para aprobación
        IF @p_IdCopiaLibro IS NULL OR @p_FechaDevolucionPrevista IS NULL
        BEGIN
            SELECT 'ERROR: Para aprobar la solicitud, debe proporcionar un IdCopiaLibro y una FechaDevolucionPrevista.' AS Mensaje;
            RETURN;
        END

        -- 3. Validar la copia del libro: existencia, estado y que corresponda al libro de la solicitud
        SELECT @CopiaLibroExiste = 1, @EstadoCopiaLibro = Estado
        FROM dbo.COPIA_LIBRO
        WHERE Id = @p_IdCopiaLibro AND IdLibro = @IdLibroSolicitud;

        IF @CopiaLibroExiste = 0
        BEGIN
            SELECT 'ERROR: La copia del libro especificada no existe o no corresponde al libro solicitado.' AS Mensaje;
            RETURN;
        END

        IF @EstadoCopiaLibro <> 'Disponible'
        BEGIN
            SELECT 'ERROR: La copia del libro no está disponible para préstamo. Estado actual: ' + @EstadoCopiaLibro + '.' AS Mensaje;
            RETURN;
        END

        -- Iniciar Transacción para asegurar la consistencia
        BEGIN TRANSACTION;
        BEGIN TRY
            -- Insertar registro en PRESTAMO
            INSERT INTO dbo.PRESTAMO (
                IdUsuario,
                IdCopiaLibro,
                IdBibliotecarioFK,
                FechaPrestamo,
                FechaDevolucionPrevista,
                Estado
            )
            VALUES (
                @IdUsuarioSolicitud,
                @p_IdCopiaLibro,
                @p_IdBibliotecarioAprobador,
                GETDATE(),
                @p_FechaDevolucionPrevista,
                'Activo' -- Estado inicial del préstamo
            );

            -- Actualizar estado de la COPIA_LIBRO
            UPDATE dbo.COPIA_LIBRO
            SET Estado = 'Prestado'
            WHERE Id = @p_IdCopiaLibro;

            -- Actualizar estado de la SOLICITUD_PRESTAMO
            UPDATE dbo.SOLICITUD_PRESTAMO
            SET
                Estado = 'Aprobado',
                FechaAprobacionRechazo = GETDATE(),
                IdBibliotecarioAprobador = @p_IdBibliotecarioAprobador,
                Observaciones = @p_Observaciones
            WHERE Id = @p_IdSolicitud;

            COMMIT TRANSACTION;
            SELECT 'OK: Solicitud de préstamo aprobada y préstamo registrado exitosamente.' AS Mensaje;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SELECT 'ERROR: ' + ERROR_MESSAGE() AS Mensaje;
        END CATCH
    END
    -- Lógica para RECHAZAR la solicitud
    ELSE
    BEGIN
        BEGIN TRY
            -- Actualizar estado de la SOLICITUD_PRESTAMO a 'Rechazado'
            UPDATE dbo.SOLICITUD_PRESTAMO
            SET
                Estado = 'Rechazado',
                FechaAprobacionRechazo = GETDATE(),
                IdBibliotecarioAprobador = @p_IdBibliotecarioAprobador,
                Observaciones = @p_Observaciones
            WHERE Id = @p_IdSolicitud;

            SELECT 'OK: Solicitud de préstamo rechazada exitosamente.' AS Mensaje;
        END TRY
        BEGIN CATCH
            SELECT 'ERROR: ' + ERROR_MESSAGE() AS Mensaje;
        END CATCH
    END
END;
GO

/*
select top 100 * from 	 SOLICITUD_PRESTAMO
*/