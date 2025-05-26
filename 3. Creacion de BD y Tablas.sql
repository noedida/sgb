IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SGBiblioteca')
BEGIN
    CREATE DATABASE [SGBiblioteca];
END;
GO

USE [SGBiblioteca];
GO

IF OBJECT_ID('dbo.AUDITORIA', 'U') IS NOT NULL DROP TABLE dbo.AUDITORIA;
IF OBJECT_ID('dbo.LISTA_NEGRA', 'U') IS NOT NULL DROP TABLE dbo.LISTA_NEGRA;
IF OBJECT_ID('dbo.PRESTAMO', 'U') IS NOT NULL DROP TABLE dbo.PRESTAMO;
IF OBJECT_ID('dbo.SOLICITUD_PRESTAMO', 'U') IS NOT NULL DROP TABLE dbo.SOLICITUD_PRESTAMO;
IF OBJECT_ID('dbo.COPIA_LIBRO', 'U') IS NOT NULL DROP TABLE dbo.COPIA_LIBRO;
IF OBJECT_ID('dbo.LIBRO', 'U') IS NOT NULL DROP TABLE dbo.LIBRO;
IF OBJECT_ID('dbo.USUARIO', 'U') IS NOT NULL DROP TABLE dbo.USUARIO;
IF OBJECT_ID('dbo.UBIGEO', 'U') IS NOT NULL DROP TABLE dbo.UBIGEO;
GO


CREATE TABLE dbo.UBIGEO (
    IdUbigeo INT PRIMARY KEY IDENTITY(1,1),
    Departamento VARCHAR(100) NOT NULL,
    Provincia VARCHAR(100) NOT NULL,
    Distrito VARCHAR(100) NOT NULL
);
GO


CREATE TABLE dbo.USUARIO (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(256) NOT NULL, 
    Nombre VARCHAR(60) NOT NULL,
    Apellido VARCHAR(60) NOT NULL,
    NumeroDocumentoIdentidad VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(15) NOT NULL,
    Direccion VARCHAR(255) NULL,
    IdUbigeo INT NULL,
    Nivel INT NOT NULL, -- 1: Bibliotecario, 2: Usuario
    Activo BIT NOT NULL DEFAULT 1,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimoLogin DATETIME NULL,
    GoogleId VARCHAR(255) NULL, 
    CONSTRAINT FK_Usuario_Ubigeo FOREIGN KEY (IdUbigeo) REFERENCES dbo.UBIGEO(IdUbigeo)
);
GO

-- GoogleId 
CREATE UNIQUE NONCLUSTERED INDEX UQ_USUARIO_GoogleId
ON dbo.USUARIO (GoogleId)
WHERE GoogleId IS NOT NULL;
GO


CREATE TABLE dbo.LIBRO (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(255) NOT NULL,
    Autor VARCHAR(255) NOT NULL,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Categoria VARCHAR(100) NOT NULL,
    AnioPublicacion INT NULL,
    Descripcion TEXT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);
GO


CREATE TABLE dbo.COPIA_LIBRO (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    IdLibro BIGINT NOT NULL,
    CodigoQRBarra VARCHAR(50) NOT NULL UNIQUE, 
    Estado VARCHAR(20) NOT NULL, -- 'Disponible', 'Prestado', 'Perdido', 'Deteriorado'
    Estante VARCHAR(100) NULL, -- Ubicación física del libro
    FechaAdquisicion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CopiaLibro_Libro FOREIGN KEY (IdLibro) REFERENCES dbo.LIBRO(Id)
);
GO


CREATE TABLE dbo.SOLICITUD_PRESTAMO (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    IdUsuario BIGINT NOT NULL, 
    IdLibro BIGINT NOT NULL, 
    FechaSolicitud DATETIME NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(20) NOT NULL, -- 'Pendiente', 'Aprobado', 'Rechazado'
    FechaAprobacionRechazo DATETIME NULL,
    IdBibliotecarioAprobador BIGINT NULL, -- Aprobado/rechazado
    Observaciones TEXT NULL,
    CONSTRAINT FK_SolicitudPrestamo_Usuario FOREIGN KEY (IdUsuario) REFERENCES dbo.USUARIO(Id),
    CONSTRAINT FK_SolicitudPrestamo_Libro FOREIGN KEY (IdLibro) REFERENCES dbo.LIBRO(Id),
    CONSTRAINT FK_SolicitudPrestamo_Bibliotecario FOREIGN KEY (IdBibliotecarioAprobador) REFERENCES dbo.USUARIO(Id)
);
GO

CREATE TABLE dbo.PRESTAMO (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    IdUsuario BIGINT NOT NULL, 
    IdCopiaLibro BIGINT NOT NULL, 
    IdBibliotecarioFK BIGINT NOT NULL, -- Bibliotecario que realizó el préstamo
    FechaPrestamo DATETIME NOT NULL DEFAULT GETDATE(),
    FechaDevolucionPrevista DATETIME NOT NULL,
    FechaDevolucionReal DATETIME NULL,
    ValorCobroPerdida DECIMAL(10,2) NULL, -- Costo libro perdido
    Estado VARCHAR(20) NOT NULL, -- 'Activo', 'Devuelto', 'Perdido'
    CONSTRAINT FK_Prestamo_Usuario FOREIGN KEY (IdUsuario) REFERENCES dbo.USUARIO(Id),
    CONSTRAINT FK_Prestamo_CopiaLibro FOREIGN KEY (IdCopiaLibro) REFERENCES dbo.COPIA_LIBRO(Id),
    CONSTRAINT FK_Prestamo_Bibliotecario FOREIGN KEY (IdBibliotecarioFK) REFERENCES dbo.USUARIO(Id)
);
GO

CREATE TABLE dbo.LISTA_NEGRA (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    IdUsuario BIGINT NOT NULL UNIQUE, -- Usuario en lista negra 
    FechaIngreso DATETIME NOT NULL DEFAULT GETDATE(),
    FechaSalida DATETIME NULL,
    Motivo TEXT NOT NULL,
    IdBibliotecarioFK BIGINT NOT NULL, -- Bibliotecario que agregó a lista negra
    CONSTRAINT FK_ListaNegra_Usuario FOREIGN KEY (IdUsuario) REFERENCES dbo.USUARIO(Id),
    CONSTRAINT FK_ListaNegra_Bibliotecario FOREIGN KEY (IdBibliotecarioFK) REFERENCES dbo.USUARIO(Id)
);
GO


CREATE TABLE dbo.AUDITORIA (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    IdUsuarioFK BIGINT NULL, -- Usuario (Bibliotecario o Sistema)
    TipoAccion VARCHAR(100) NOT NULL, -- 'LibroAgregado', 'PrestamoRegistrado', 'UsuarioEliminado'
    Descripcion TEXT NOT NULL, 
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    DireccionIP VARCHAR(45) NULL, -- IP Host
    CONSTRAINT FK_Auditoria_Usuario FOREIGN KEY (IdUsuarioFK) REFERENCES dbo.USUARIO(Id)
);
GO

CREATE INDEX IX_USUARIO_Email ON dbo.USUARIO (Email);

CREATE INDEX IX_LIBRO_ISBN ON dbo.LIBRO (ISBN);

CREATE INDEX IX_COPIA_LIBRO_IdLibro ON dbo.COPIA_LIBRO (IdLibro);
CREATE INDEX IX_SOLICITUD_PRESTAMO_IdUsuario ON dbo.SOLICITUD_PRESTAMO (IdUsuario);
CREATE INDEX IX_SOLICITUD_PRESTAMO_IdLibro ON dbo.SOLICITUD_PRESTAMO (IdLibro);
CREATE INDEX IX_PRESTAMO_IdUsuario ON dbo.PRESTAMO (IdUsuario);
CREATE INDEX IX_PRESTAMO_IdCopiaLibro ON dbo.PRESTAMO (IdCopiaLibro);
CREATE INDEX IX_LISTA_NEGRA_IdUsuario ON dbo.LISTA_NEGRA (IdUsuario);

