USE Camvi
GO

CREATE TRIGGER tgr_eliminar_codigos_recuperacion
ON tbCodigosRecuperacion
AFTER INSERT
AS
BEGIN
	DECLARE @idReciente INT
	SET @idReciente = (SELECT TOP 1 idCodigo FROM tbCodigosRecuperacion ORDER BY idCodigo DESC)

	DELETE FROM tbCodigosRecuperacion WHERE idCodigo <> @idReciente
END
GO

CREATE TRIGGER tgr_nuevo_camarografo
ON tbUsuarios
AFTER INSERT
AS
BEGIN
	DECLARE @idUsuario INT
	DECLARE @tipoUsuario INT
	DECLARE @descripcionCorta VARCHAR
	DECLARE @acercaDe VARCHAR
	DECLARE @titulo VARCHAR
	DECLARE @imagen BINARY 

	SET @idUsuario = (SELECT TOP 1 idUsuario FROM tbUsuarios ORDER BY idUsuario DESC)
	SET @tipoUsuario = (SELECT TOP 1 tipoUsuario FROM tbUsuarios ORDER BY idUsuario DESC)
	SET @descripcionCorta = (SELECT TOP 1 descripcionCorta FROM tbCamarografos ORDER BY idUsuario DESC)
	SET @acercaDe = (SELECT TOP 1 acercaDe FROM tbCamarografos ORDER BY idUsuario DESC)
	SET @titulo = (SELECT TOP 1 tituloDeFormacion FROM tbCamarografos ORDER BY idUsuario DESC)
	SET @imagen = (SELECT TOP 1 imageSinFondo FROM tbCamarografos ORDER BY idUsuario DESC)
	
	IF(@tipoUsuario = '2')
		
		INSERT INTO tbCamarografos VALUES (@idUsuario, @descripcionCorta, @acercaDe, @titulo, @imagen)
	
	ELSE
		RAISERROR('El tipo de usuario ingresado no es un camarografo' ,10,1)
END
GO

CREATE TRIGGER tgr_nuevo_cliente
ON tbUsuarios
AFTER INSERT
AS
BEGIN
	DECLARE @tipoUsuario INT

	SET @tipoUsuario = (SELECT TOP 1 tipoUsuario FROM tbUsuarios ORDER BY idUsuario DESC)

	IF(@tipoUsuario = '3')
		
		INSERT INTO tbClientes VALUES (NULL)
	
	ELSE
		RAISERROR('El tipo de usuario ingresado no es un cliente' ,10,1)
END
