CREATE TABLE tbTipoUsuario(
idTipoUsuario INT PRIMARY KEY IDENTITY(1,1),
tipoUsuario VARCHAR(20)
);


CREATE TABLE tbUsuarios(
idUsuario INT PRIMARY KEY IDENTITY(1,1),
usuario VARCHAR(10),
contrasenia VARCHAR(1O),
tipoUsuario INT
);


CREATE TABLE tbFotografos(
idFotografo INT PRIMARY KEY IDENTITY(1,1),
nombreFotografo VARCHAR(50),
contactoFotografo VARCHAR(15),
duiFotografo VARCHAR(10),
correoFotografo VARCHAR(30),
imagenFotografo IMAGE,
idUsuario INT
);


CREATE TABLE tbClientes(
idCliente INT PRIMARY KEY IDENTITY(1,1),
nombreCliente VARCHAR(50),
contactoCliente VARCHAR(15),
duiCliente CARCHAR(10),
correo VARCHAR(30)
idUsuario INT
);


CREATE TABLE tbSesiones(
idSesion INT PRIMARY KEY IDENTITY(1,1),
direccionEvento VARCHAR(200),
fechaEvento DATE,
horaInicio TIME,
horaFinalizacion TIME,
idFotografo INT,
idCliente INT
);


-------------------------------------------

CREATE TABLE tbAdministrador(
idAdministrador INT PRIMARY KEY IDENTITY(1,1),

);