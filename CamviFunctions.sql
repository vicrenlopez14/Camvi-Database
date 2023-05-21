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

-- La funcion devuelve el numero de sesiones pendientes
CREATE FUNCTION fnNumSesionesPendientesAdmin(@rangoDeFecha VARCHAR(20))
RETURNS @nuevaTabla
TABLE(numSesionesPendientes INT)
AS 
BEGIN
	DECLARE @fechaInicio DATE
	DECLARE @fechaFin DATE
	DECLARE @numSesionesPendientes INT

	IF @rangoDeFecha = 'Hoy' 
	BEGIN 
		SET @fechaInicio = CAST(GETDATE() AS DATE)
		SET @fechaFin = CAST(GETDATE() AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Semana actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 6) AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Mes actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1) AS DATE)
	END

	SELECT @numSesionesPendientes = COUNT(*) FROM tbSesiones
									WHERE fechaEvento BETWEEN @fechaInicio AND @fechaFin AND realizacion = 'Pendiente'

    INSERT INTO @nuevaTabla (numSesionesPendientes)
    VALUES (@numSesionesPendientes);
    RETURN
END
GO

-- La funcion devuelve el nombre de los camarografos disponibles
CREATE FUNCTION fnCamarografosDisponibles(@rangoDeFecha VARCHAR(20))
RETURNS @TablaCamarografosLibres TABLE (camarografosLibres VARCHAR(100))
AS
BEGIN

	DECLARE @fechaInicio DATE
	DECLARE @fechaFin DATE
	
	IF @rangoDeFecha = 'Hoy' 
	BEGIN 
		SET @fechaInicio= CAST(GETDATE() AS DATE)
		SET @fechaFin = CAST(GETDATE() AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Semana actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 6) AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Mes actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1) AS DATE)
	END
	
		INSERT INTO @TablaCamarografosLibres (camarografosLibres)
		(SELECT TOP 3 SUBSTRING(U.nombre, 1, CHARINDEX(' ', U.nombre)-1)
        FROM tbUsuarios AS U
        LEFT JOIN tbSesiones AS S
        ON U.idUsuario = S.idFotografo
        AND S.fechaEvento BETWEEN @fechaInicio AND @fechaFin
        WHERE S.idFotografo IS NULL
        AND U.tipoUsuario = 2)
    RETURN
END

GO
SELECT * FROM fnCamarografosDisponibles('Mes actual');
GO

-- La funcion devuelve el numero de sesiones completadas/finalizadas
CREATE FUNCTION fnSesionesCompletadasAdmin(@rangoDeFecha VARCHAR(20))
RETURNS @nuevaTabla
TABLE(numSesionesCompletadas INT, mensaje VARCHAR(50))
AS 
BEGIN
	DECLARE @fechaInicio DATE
	DECLARE @fechaFin DATE
	DECLARE @numSesionesCompletadas INT
	DECLARE @mensaje VARCHAR(50)

	IF @rangoDeFecha = 'Hoy'
	BEGIN 
		SET @fechaInicio = CAST(GETDATE() AS DATE)
		SET @fechaFin = CAST(GETDATE() AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Semana actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 6) AS DATE)
	END

	ELSE IF @rangoDeFecha = 'Mes actual'
	BEGIN
		SET @fechaInicio = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AS DATE)
		SET @fechaFin = CAST(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1) AS DATE)
	END

	SELECT @numSesionesCompletadas = COUNT(*) FROM tbSesiones
									WHERE fechaEvento BETWEEN @fechaInicio AND @fechaFin AND realizacion = 'Finalizado'

	IF @numSesionesCompletadas = 0
	SET @mensaje = ' '
	ELSE
	SET @mensaje = 'Bien hecho'

	INSERT INTO @nuevaTabla (numSesionesCompletadas, mensaje)
    VALUES (@numSesionesCompletadas, @mensaje);
    RETURN;
END

GO
SELECT * FROM fnSesionesCompletadasAdmin('Hoy');
GO


