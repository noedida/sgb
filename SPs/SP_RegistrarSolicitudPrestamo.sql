USE [SGBiblioteca]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************************
 Descripción          : Registra una nueva solicitud de préstamo, validando la existencia de usuario y libro,
                        y que el usuario no esté en lista negra.
 Input                : @p_IdUsuario : ID del usuario que solicita el préstamo.
                        @p_IdLibro   : ID del libro que el usuario desea solicitar.
 Resultado            : Mensaje de 'OK' o 'ERROR' con detalles.
 Elaborado por        : Noe DIAZ
 Fecha                : 26/05/2025
 Ejecución            :
    -- Ejemplo: Registrar una solicitud de préstamo para un usuario y libro existentes
    DECLARE @TestIdUsuario BIGINT = (SELECT Id FROM dbo.USUARIO WHERE Email = 'usuario.prueba@example.com');
    DECLARE @TestIdLibro BIGINT = (SELECT Id FROM dbo.LIBRO WHERE ISBN = '978-0321765723');
    EXEC dbo.SP_RegistrarSolicitudPrestamo @p_IdUsuario = 1, @p_IdLibro = 1;

    -- Ejemplo: Usuario no existente
    EXEC dbo.SP_RegistrarSolicitudPrestamo @p_IdUsuario = 99999, @p_IdLibro = 1;

    -- Ejemplo: Libro no existente
    EXEC dbo.SP_RegistrarSolicitudPrestamo @p_IdUsuario = 1, @p_IdLibro = 99999;
*********************************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[SP_RegistrarSolicitudPrestamo]
    @p_IdUsuario BIGINT,
    @p_IdLibro BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables para validaciones
    DECLARE @UsuarioExiste BIT = 0;
    DECLARE @LibroExiste BIT = 0;
    DECLARE @EnListaNegra BIT = 0;
    DECLARE @UsuarioActivo BIT = 0;

    -- 1. Validar que el usuario exista y esté activo
    SELECT @UsuarioExiste = 1, @UsuarioActivo = Activo
    FROM dbo.USUARIO
    WHERE Id = @p_IdUsuario;

    IF @UsuarioExiste = 0
    BEGIN
        SELECT 'ERROR: El usuario especificado no existe.' AS Mensaje;
        RETURN;
    END

    IF @UsuarioActivo = 0
    BEGIN
        SELECT 'ERROR: El usuario se encuentra inactivo.' AS Mensaje;
        RETURN;
    END

    -- 2. Validar que el libro exista
    SELECT @LibroExiste = 1
    FROM dbo.LIBRO
    WHERE Id = @p_IdLibro;

    IF @LibroExiste = 0
    BEGIN
        SELECT 'ERROR: El libro especificado no existe.' AS Mensaje;
        RETURN;
    END

    -- 3. Validar si el usuario está en la LISTA_NEGRA
    SELECT @EnListaNegra = 1
    FROM dbo.LISTA_NEGRA
    WHERE IdUsuario = @p_IdUsuario AND FechaSalida IS NULL; -- Solo si está activo en la lista negra

    IF @EnListaNegra = 1
    BEGIN
        SELECT 'ERROR: El usuario se encuentra en la lista negra y no puede solicitar préstamos.' AS Mensaje;
        RETURN;
    END

    -- 4. Insertar la solicitud de préstamo si todas las validaciones son exitosas
    BEGIN TRY
        INSERT INTO dbo.SOLICITUD_PRESTAMO (
            IdUsuario,
            IdLibro,
            FechaSolicitud,
            Estado
        )
        VALUES (
            @p_IdUsuario,
            @p_IdLibro,
            GETDATE(),
            'Pendiente' -- Estado inicial de la solicitud
        );

        SELECT 'OK: Solicitud de préstamo registrada exitosamente como Pendiente.' AS Mensaje;

    END TRY
    BEGIN CATCH
        SELECT 'ERROR: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
GO

/*
select top 100 * from  SOLICITUD_PRESTAMO
*/
