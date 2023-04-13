CREATE DATABASE Camvi;
USE Camvi;

CREATE TABLE tbTipoUsuario
(
    idTipoUsuario INT PRIMARY KEY IDENTITY (1,1),
    tipoUsuario   VARCHAR(20)
);

INSERT INTO tbTipoUsuario (tipoUsuario)
VALUES ('Administrador'),
       ('Fotografo'),
       ('Cliente');


CREATE TABLE tbUsuarios
(
    idUsuario   INT PRIMARY KEY IDENTITY (1,1),
    correo      VARCHAR(255),
    nombre      VARCHAR(50) NOT NULL,
    contacto    VARCHAR(15),7
    imagen      IMAGE,
    dui         VARCHAR(10),
    pass        VARCHAR(25),
    tipoUsuario INT
);

INSERT INTO tbUsuarios (correo, nombre, contacto, imagen, dui, pass, tipoUsuario)
VALUES ('20190189@gmail.com', 'Víctor', '7010-2904', NULL, 'No tengo', '1234', 1);


CREATE TABLE tbSesiones
(
    idSesion         INT PRIMARY KEY IDENTITY (1,1),
    direccionEvento  VARCHAR(200),
    fechaEvento      DATE,
    horaInicio       TIME,
    horaFinalizacion TIME,
    idFotografo      INT,
    idCliente        INT
);
