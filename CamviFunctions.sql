USE Camvi


CREATE FUNCTION fnIniciarSesion(@correo VARCHAR(255), @pass VARCHAR(25))
    RETURNS INT
AS
BEGIN
    DECLARE @tipoUsuario INT

    SELECT @tipoUsuario = tipoUsuario
    FROM tbUsuarios
    WHERE correo = @correo
      AND pass = @pass

    RETURN @tipoUsuario

END
GO

SELECT dbo.fnIniciarSesion('20190189@ricaldone.edu.sv', '1234') AS TipoUsuario

CREATE FUNCTION dbo.fnVerMasCamarografo(@idCamarografo int)
RETURNS TABLE
AS
RETURN
	SELECT u.nombre, u.correo, s.acercaDe,s.descripcionCorta, s.tituloDeFormacion, u.imagen
	FROM tbCamarografos s
	INNER JOIN tbUsuarios u ON s.idUsuario=u.idUsuario
	WHERE idCamarografo=@idCamarografo
GO

CREATE FUNCTION fnListaNotificaciones(@idUsuario int)
RETURNS TABLE
AS
RETURN
	SELECT o.titulo, o.descripcion
	FROM tbNotificaciones n
	INNER JOIN tbTipoNotificacion o ON n.tipoNotificacionId=o.idTipoNotificacion
	INNER JOIN tbUsuarios U ON n.usuarioId=U.idUsuario
	WHERE n.usuarioId=@idUsuario AND n.vista=0;
GO


CREATE FUNCTION fnVerMasSesion(@idSesion int)
RETURNS TABLE
AS
RETURN
		SELECT s.titulo, s.detalles, s.lugar, s.fechaEvento, s.horaInicio, s.horaFinalizacion, u.nombre, u.contacto, u.dui
	FROM tbSesiones s
	INNER JOIN tbUsuarios u ON s.idCliente= u.idUsuario
	WHERE s.idSesion = @idSesion;
GO

SELECT * FROM fnVerMasSesion(2)
go


CREATE FUNCTION fnCitasCliente(@idCliente INT)
RETURNS TABLE
AS
RETURN
	SELECT o.idSesion,o.titulo, u.nombre, o.fechaEvento 
	FROM tbSesiones o
	INNER JOIN tbUsuarios u ON o.idFotografo = u.idUsuario
	WHERE idCliente = @idCliente
GO
