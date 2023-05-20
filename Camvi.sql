-- USE master
-- DROP DATABASE Camvi
-- CREATE DATABASE Camvi;
USE Camvi;
GO

CREATE TABLE tbTipoUsuarios
(
    idTipoUsuario INT PRIMARY KEY IDENTITY (1,1),
    tipoUsuario   VARCHAR(20)
);

INSERT INTO tbTipoUsuarios (tipoUsuario)
VALUES ('Administrador'),
       ('Camarógrafo'),
       ('Cliente');


CREATE TABLE tbUsuarios
(
    idUsuario   INT PRIMARY KEY IDENTITY (1,1),
    correo      VARCHAR(255),
    nombre      NVARCHAR(50) NOT NULL,
    contacto    VARCHAR(15),
    imagen      IMAGE,
    dui         VARCHAR(10),
    pass        NVARCHAR(50),
    tipoUsuario INT
);

ALTER TABLE tbUsuarios
    ADD CONSTRAINT UQ_tbUsuarios_correos UNIQUE (correo);

ALTER TABLE tbUsuarios
    ADD CONSTRAINT FK_tbUsuarios_tbTipoUsuario FOREIGN KEY (tipoUsuario)
        REFERENCES tbTipoUsuarios (idTipoUsuario);


INSERT INTO tbUsuarios (correo, nombre, contacto, imagen, dui, pass, tipoUsuario)
VALUES ('20190189@ricaldone.edu.sv', 'Víctor López', '7010-2904', NULL, 'No tengo', '1234', 1);

CREATE TABLE tbCamarografos
(
    idCamarografo     INT PRIMARY KEY IDENTITY (1, 1),
    idUsuario         INT,
    descripcionCorta  VARCHAR(50),
    acercaDe          VARCHAR(255),
    tituloDeFormacion VARCHAR(50),
    imageSinFondo     IMAGE
);

ALTER TABLE tbCamarografos
    ADD CONSTRAINT FK_tbCamarografos_tbUsuarios FOREIGN KEY (idUsuario)
        REFERENCES tbUsuarios (idUsuario);

CREATE TABLE tbClientes
(
    idCliente           INT PRIMARY KEY IDENTITY (1, 1),
    informacionCompleta BIT DEFAULT 0,
);

CREATE TABLE tbFotosGaleria
(
    idFoto INT PRIMARY KEY IDENTITY (1,1),
    foto   IMAGE,
    titulo VARCHAR(25),
);

CREATE TABLE tbSesiones
(
    idSesion         INT PRIMARY KEY IDENTITY (1,1),
    titulo           VARCHAR(25),
    detalles         VARCHAR(255),
    idFotoGaleria    INT,
    direccionEvento  VARCHAR(200),
    fechaEvento      DATE,
    horaInicio       TIME,
    horaFinalizacion TIME,
    lugar            VARCHAR(255),
    confirmada       BIT DEFAULT 0,
    cancelada        BIT DEFAULT 0,
    idFotografo      INT,
    idCliente        INT
);

ALTER TABLE tbSesiones
    ADD CONSTRAINT FK_tbSesiones_tbFotosGaleria FOREIGN KEY (idFotoGaleria)
        REFERENCES tbFotosGaleria (idFoto);

ALTER TABLE tbSesiones
    ADD CONSTRAINT FK_tbSesiones_tbUsuarios FOREIGN KEY (idFotografo)
        REFERENCES tbUsuarios (idUsuario);

ALTER TABLE tbSesiones
    ADD CONSTRAINT FK_tbSesiones_tbUsuarios_1 FOREIGN KEY (idCliente)
        REFERENCES tbUsuarios (idUsuario);

ALTER TABLE tbSesiones
    ADD realizacion AS
        CASE
            WHEN FechaEvento < CONVERT(DATE, GETDATE()) THEN 'Finalizado'
            WHEN FechaEvento = CONVERT(DATE, GETDATE()) AND HoraFinalizacion < CONVERT(TIME, GETDATE())
                THEN 'Finalizado'
            WHEN FechaEvento = CONVERT(DATE, GETDATE()) AND HoraFinalizacion > CONVERT(TIME, GETDATE())
                THEN 'En progreso'
            WHEN FechaEvento > CONVERT(DATE, GETDATE()) THEN 'Pendiente'
            END;
GO

CREATE TABLE tbCalificacionSesion
(
    idCalificacion                INT PRIMARY KEY IDENTITY (1,1),
    puntualidadFotografo          SMALLINT,
    actitudFotografo              SMALLINT,
    desempenoFotografo            SMALLINT,
    profesionalismoFotografo      SMALLINT,
    presentacionPersonalFotografo SMALLINT,
    servicioDeAtencion            SMALLINT,
    esperaDeRespuestas            SMALLINT,
    calidadDelProductoFinal       SMALLINT,
    comentarios                   VARCHAR(255),
    clienteId                     INT,
    sesionId                      INT
);

-- Calificación promedio
ALTER TABLE tbCalificacionSesion
    ADD promedio AS
            ((puntualidadFotografo + actitudFotografo + desempenoFotografo + profesionalismoFotografo +
             presentacionPersonalFotografo + servicioDeAtencion + esperaDeRespuestas + calidadDelProductoFinal) / 8.0) * 100;

ALTER TABLE tbCalificacionSesion
    ADD CONSTRAINT FK_tbCalificacionSesion_tbUsuarios FOREIGN KEY (clienteId)
        REFERENCES tbUsuarios (idUsuario);

ALTER TABLE tbCalificacionSesion
    ADD CONSTRAINT FK_tbCalificacionSesion_tbSesiones FOREIGN KEY (sesionId)
        REFERENCES tbSesiones (idSesion);

CREATE TABLE tbTipoNotificacion
(
    idTipoNotificacion INT PRIMARY KEY IDENTITY (1,1),
    titulo             VARCHAR(50),
    descripcion        VARCHAR(150)
);

INSERT INTO tbTipoNotificacion (titulo, descripcion)
VALUES ('Confirmación de servicio', 'Se confirmó la sesión solicitada'),
       ('Cancelación de servicio', 'Se ha cancelado la sesión de fotografía'),
       ('Finalización de servicio', 'Se ha finalizado la sesión de fotografía'),
       ('Calificación de servicio', 'Por favor califique la sesión recién finalizada'),
       ('Recordatorio de servicio', 'Tiene una sesión en las próximas horas');

CREATE TABLE tbNotificaciones
(
    idNotificacion     INT PRIMARY KEY IDENTITY (1,1),
    tipoNotificacionId INT,
    vista              BIT,
    sesionId           INT,
    usuarioId          INT
);

ALTER TABLE tbNotificaciones
    ADD CONSTRAINT FK_tbNotificaciones_tbTipoNotificacion FOREIGN KEY (tipoNotificacionId)
        REFERENCES tbTipoNotificacion (idTipoNotificacion);

ALTER TABLE tbNotificaciones
    ADD CONSTRAINT FK_tbNotificaciones_tbSesiones FOREIGN KEY (sesionId)
        REFERENCES tbSesiones (idSesion);

ALTER TABLE tbNotificaciones
    ADD CONSTRAINT FK_tbNotificaciones_tbUsuarios FOREIGN KEY (usuarioId)
        REFERENCES tbUsuarios (idUsuario);

CREATE TABLE tbCodigosRecuperacion
(
    idCodigo INT PRIMARY KEY IDENTITY (1,1),
    codigo   VARCHAR(10),
    usuario  INT
);

ALTER TABLE tbCodigosRecuperacion
    ADD CONSTRAINT FK_tbCodigosRecuperacion_tbUsuarios FOREIGN KEY (usuario)
        REFERENCES tbUsuarios (idUsuario);



