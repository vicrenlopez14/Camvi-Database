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

SELECT *
FROM tbUsuarios

SELECT *
FROM tbUsuarios
WHERE correo = 'correo@example.com'
  AND pass = 'micontraseña';

SELECT dbo.fnIniciarSesion('ejemplo@example.com', 'micontrasena')

