--INSERCIONES
DECLARE @IdUbigeo1 INT, @IdUbigeo2 INT, @IdUbigeo3 INT;
DECLARE @IdBibliotecario1 BIGINT;
DECLARE @IdUsuario1 BIGINT, @IdUsuario2 BIGINT;
DECLARE @IdLibro1 BIGINT, @IdLibro2 BIGINT, @IdLibro3 BIGINT, @IdLibro4 BIGINT;
DECLARE @IdCopiaLibro1 BIGINT, @IdCopiaLibro2 BIGINT, @IdCopiaLibro3 BIGINT, @IdCopiaLibro4 BIGINT, @IdCopiaLibro5 BIGINT;
DECLARE @IdSolicitud1 BIGINT, @IdSolicitud2 BIGINT;
DECLARE @IdPrestamo1 BIGINT;

-- Datos de ejemplo para UBIGEO
INSERT INTO dbo.UBIGEO (Departamento, Provincia, Distrito) VALUES
('Lima', 'Lima', 'San Isidro'); SET @IdUbigeo1 = SCOPE_IDENTITY();
INSERT INTO dbo.UBIGEO (Departamento, Provincia, Distrito) VALUES
('Lima', 'Lima', 'Miraflores'); SET @IdUbigeo2 = SCOPE_IDENTITY();
INSERT INTO dbo.UBIGEO (Departamento, Provincia, Distrito) VALUES
('Lima', 'Lima', 'Surco'); SET @IdUbigeo3 = SCOPE_IDENTITY();
INSERT INTO dbo.UBIGEO (Departamento, Provincia, Distrito) VALUES
('Arequipa', 'Arequipa', 'Arequipa');
-- No es necesario capturar el último ID de UBIGEO si no se usa después.

-- Datos de ejemplo para USUARIO (con contraseñas hasheadas y roles)
INSERT INTO dbo.USUARIO (Email, Password, Nombre, Apellido, NumeroDocumentoIdentidad, Telefono, Direccion, IdUbigeo, Nivel, Activo) VALUES
('bibliotecario1@biblioteca.com', 'hash_bibliotecario_1', 'Ana', 'García', '12345678', '987654321', 'Calle Falsa 123', @IdUbigeo1, 1, 1); -- Usamos @IdUbigeo1
SET @IdBibliotecario1 = SCOPE_IDENTITY();

INSERT INTO dbo.USUARIO (Email, Password, Nombre, Apellido, NumeroDocumentoIdentidad, Telefono, Direccion, IdUbigeo, Nivel, Activo) VALUES
('usuario1@email.com', 'hash_usuario_1', 'Juan', 'Pérez', '87654321', '912345678', 'Avenida Siempre Viva 742', @IdUbigeo2, 2, 1); -- Usamos @IdUbigeo2
SET @IdUsuario1 = SCOPE_IDENTITY();

INSERT INTO dbo.USUARIO (Email, Password, Nombre, Apellido, NumeroDocumentoIdentidad, Telefono, Direccion, IdUbigeo, Nivel, Activo) VALUES
('usuario2@email.com', 'hash_usuario_2', 'María', 'López', '11223344', '956789012', 'Jr. Unión 500', @IdUbigeo3, 2, 1); -- Usamos @IdUbigeo3
SET @IdUsuario2 = SCOPE_IDENTITY();

-- Datos de ejemplo para LIBRO
INSERT INTO dbo.LIBRO (Titulo, Autor, ISBN, Categoria, AnioPublicacion, Descripcion) VALUES
('Cien años de soledad', 'Gabriel García Márquez', '978-0307474278', 'Novela', 1967, 'Una obra maestra de la literatura latinoamericana.');
SET @IdLibro1 = SCOPE_IDENTITY();

INSERT INTO dbo.LIBRO (Titulo, Autor, ISBN, Categoria, AnioPublicacion, Descripcion) VALUES
('Don Quijote de la Mancha', 'Miguel de Cervantes', '978-8420464673', 'Novela', 1605, 'Clásico de la literatura española.');
SET @IdLibro2 = SCOPE_IDENTITY();

INSERT INTO dbo.LIBRO (Titulo, Autor, ISBN, Categoria, AnioPublicacion, Descripcion) VALUES
('El Principito', 'Antoine de Saint-Exupéry', '978-6070732386', 'Fábula', 1943, 'Un cuento poético sobre un pequeño príncipe.');
SET @IdLibro3 = SCOPE_IDENTITY();

INSERT INTO dbo.LIBRO (Titulo, Autor, ISBN, Categoria, AnioPublicacion, Descripcion) VALUES
('Introducción a C#', 'Varios Autores', '978-1234567890', 'Programación', 2023, 'Guía completa para aprender C#');
SET @IdLibro4 = SCOPE_IDENTITY();

-- Datos de ejemplo para COPIA_LIBRO
INSERT INTO dbo.COPIA_LIBRO (IdLibro, CodigoQRBarra, Estado, Estante) VALUES
(@IdLibro1, 'CML-001-A', 'Disponible', 'A1'); SET @IdCopiaLibro1 = SCOPE_IDENTITY();
INSERT INTO dbo.COPIA_LIBRO (IdLibro, CodigoQRBarra, Estado, Estante) VALUES
(@IdLibro1, 'CML-001-B', 'Disponible', 'A1'); SET @IdCopiaLibro2 = SCOPE_IDENTITY();
INSERT INTO dbo.COPIA_LIBRO (IdLibro, CodigoQRBarra, Estado, Estante) VALUES
(@IdLibro2, 'DQM-001-A', 'Disponible', 'B2'); SET @IdCopiaLibro3 = SCOPE_IDENTITY();
INSERT INTO dbo.COPIA_LIBRO (IdLibro, CodigoQRBarra, Estado, Estante) VALUES
(@IdLibro3, 'PRN-001-A', 'Prestado', 'C3'); SET @IdCopiaLibro4 = SCOPE_IDENTITY();
INSERT INTO dbo.COPIA_LIBRO (IdLibro, CodigoQRBarra, Estado, Estante) VALUES
(@IdLibro4, 'ICS-001-A', 'Disponible', 'D4'); SET @IdCopiaLibro5 = SCOPE_IDENTITY();

-- Datos de ejemplo para SOLICITUD_PRESTAMO
INSERT INTO dbo.SOLICITUD_PRESTAMO (IdUsuario, IdLibro, FechaSolicitud, Estado, IdBibliotecarioAprobador) VALUES
(@IdUsuario1, @IdLibro1, GETDATE(), 'Pendiente', NULL); -- Juan solicita Cien años
SET @IdSolicitud1 = SCOPE_IDENTITY();

INSERT INTO dbo.SOLICITUD_PRESTAMO (IdUsuario, IdLibro, FechaSolicitud, Estado, IdBibliotecarioAprobador) VALUES
(@IdUsuario2, @IdLibro2, GETDATE(), 'Aprobado', @IdBibliotecario1); -- María solicita Don Quijote, aprobado por bibliotecario 1
SET @IdSolicitud2 = SCOPE_IDENTITY();

-- Datos de ejemplo para PRESTAMO
INSERT INTO dbo.PRESTAMO (IdUsuario, IdCopiaLibro, IdBibliotecarioFK, FechaPrestamo, FechaDevolucionPrevista, Estado) VALUES
(@IdUsuario2, @IdCopiaLibro4, @IdBibliotecario1, GETDATE(), DATEADD(day, 14, GETDATE()), 'Activo'); -- María tiene El Principito
SET @IdPrestamo1 = SCOPE_IDENTITY();

-- Datos de ejemplo para LISTA_NEGRA (ejemplo: usuario que no devolvió libro)
-- Descomentar si deseas insertar datos de ejemplo en esta tabla
-- INSERT INTO dbo.LISTA_NEGRA (IdUsuario, Motivo, IdBibliotecarioFK) VALUES
-- (@IdUsuario2, 'No devolvió El Principito a tiempo', @IdBibliotecario1);

-- Datos de ejemplo para AUDITORIA
-- Descomentar si deseas insertar datos de ejemplo en esta tabla
-- INSERT INTO dbo.AUDITORIA (IdUsuarioFK, TipoAccion, Descripcion, DireccionIP) VALUES
-- (@IdBibliotecario1, 'LibroAgregado', 'Se agregó el libro "Cien años de soledad"', '192.168.1.100');

-- Final GO para el lote de inserción de datos
GO