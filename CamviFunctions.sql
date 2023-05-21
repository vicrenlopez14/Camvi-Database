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
