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

	SET @idUsuario = (SELECT TOP 1 idUsuario FROM tbUsuarios ORDER BY idUsuario DESC)
	SET @tipoUsuario = (SELECT TOP 1 tipoUsuario FROM tbUsuarios ORDER BY idUsuario DESC)

	IF(@tipoUsuario = '2')
		
		INSERT INTO tbCamarografos VALUES (@idUsuario, 'Descripcion Corta', 'Acerca de', 'Titulo de formacion', NULL)
	
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
