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


CREATE FUNCTION fnSesionesClientesDetalle(@idSesion INT)
RETURNS TABLE
AS
RETURN
	SELECT s.titulo, s.detalles, s.lugar,s.fechaEvento, s.horaInicio, s.horaFinalizacion, u.nombre, u.contacto, u.dui, eu.nombre AS 'Nombre del fotografo'
	FROM tbSesiones s
	INNER JOIN tbUsuarios u ON s.idCliente= u.idUsuario
	INNER JOIN tbUsuarios eu ON s.idFotografo = eu.idUsuario
	WHERE eu.tipoUsuario=2 AND s.idSesion = @idSesion
GO

select * from fnSesionesClientesDetalle(4) 