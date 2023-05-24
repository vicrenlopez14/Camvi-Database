USE Camvi
GO

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
        SELECT u.nombre, u.correo, s.acercaDe, s.descripcionCorta, s.tituloDeFormacion, u.imagen
        FROM tbCamarografos s
                 INNER JOIN tbUsuarios u ON s.idUsuario = u.idUsuario
        WHERE idCamarografo = @idCamarografo
GO

SELECT * from fnVerMasCamarografo(4)

CREATE FUNCTION fnListaNotificaciones(@idUsuario int)
    RETURNS TABLE
        AS
        RETURN
        SELECT o.titulo, o.descripcion
        FROM tbNotificaciones n
                 INNER JOIN tbTipoNotificacion o ON n.tipoNotificacionId = o.idTipoNotificacion
                 INNER JOIN tbUsuarios U ON n.usuarioId = U.idUsuario
        WHERE n.usuarioId = @idUsuario
          AND n.vista = 0;
GO

CREATE FUNCTION dbo.GetClientSatisfactionPercentage(@periodo VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @startDate DATE
    DECLARE @endDate DATE
    DECLARE @totalCalificaciones INT
    DECLARE @satisfactorias INT

    IF @periodo = 'Hoy'
    BEGIN
        SET @startDate = GETDATE()
        SET @endDate = @startDate
    END
    ELSE IF @periodo = 'Semana'
    BEGIN
        SET @startDate = DATEADD(DAY, -7, GETDATE())
        SET @endDate = GETDATE()
    END
    ELSE IF @periodo = 'Mes'
    BEGIN
        SET @startDate = DATEADD(MONTH, -1, GETDATE())
        SET @endDate = GETDATE()
    END
    ELSE
    BEGIN
        RETURN NULL;
    END

    SET @totalCalificaciones = (
        SELECT COUNT(*) FROM tbCalificacionSesion
        WHERE fechaCalificacion >= @startDate AND fechaCalificacion <= @endDate
    )

    SET @satisfactorias = (
        SELECT COUNT(*) FROM tbCalificacionSesion
        WHERE fechaCalificacion >= @startDate AND fechaCalificacion <= @endDate
            AND promedio >= 80 -- Assuming 80 is the threshold for satisfaction
    )

    IF @totalCalificaciones > 0
    BEGIN
        RETURN (@satisfactorias * 100) / @totalCalificaciones
    END
    ELSE
    BEGIN
        RETURN 0
    END

    RETURN NULL;
END

CREATE FUNCTION dbo.GetInsertedSessionsCount(@periodo VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @startDate DATE
    DECLARE @endDate DATE
    DECLARE @count INT

    IF @periodo = 'Hoy'
    BEGIN
        SET @startDate = GETDATE()
        SET @endDate = @startDate
    END
    ELSE IF @periodo = 'Semana'
    BEGIN
        SET @startDate = DATEADD(DAY, -7, GETDATE())
        SET @endDate = GETDATE()
    END
    ELSE IF @periodo = 'Mes'
    BEGIN
        SET @startDate = DATEADD(MONTH, -1, GETDATE())
        SET @endDate = GETDATE()
    END
    ELSE
    BEGIN
        RETURN NULL; -- Invalid periodo value
    END

    SELECT @count = COUNT(*) FROM tbSesiones
    WHERE fechaDeCreacion >= @startDate AND fechaDeCreacion <= @endDate

    RETURN @count
END


CREATE FUNCTION dbo.GetUnassignedSessionCount()
RETURNS INT
AS
BEGIN
    DECLARE @count INT

    SELECT @count = COUNT(*) FROM tbSesiones
    WHERE idFotografo IS NULL

    RETURN @count
END

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

-- La funcion devuelve el nombre de camarografos disponibles
CREATE FUNCTION fnCamarografosDisponibles(@rangoDeFecha VARCHAR(20))
RETURNS @TablaCamarografosLibres 
TABLE (camarografosLibres VARCHAR(100))
AS
BEGIN
	DECLARE @fechaInicio DATE
	DECLARE @fechaFin DATE
	DECLARE @camarografosLibres VARCHAR(100)

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
SELECT * FROM fnCamarografosDisponibles('Hoy');
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

SELECT * FROM fnSesionesCompletadasAdmin('Hoy');

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

CREATE FUNCTION fnCitasCliente(@idUsuario INT)
RETURNS TABLE
AS
RETURN
	SELECT s.idSesion, s.titulo,u.nombre, s.fechaEvento
	FROM tbSesiones s
	INNER JOIN tbUsuarios u ON s.idFotografo = u.idUsuario
	WHERE u.idUsuario = @idUsuario
GO