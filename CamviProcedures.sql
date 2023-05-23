USE Camvi
GO

CREATE PROCEDURE spCrearAdministrador @nombre NVARCHAR(50),
                                      @correo VARCHAR(255),
                                      @pass VARCHAR(25),
                                      @contacto VARCHAR(15),
                                      @dui VARCHAR(10)
AS
BEGIN
    DECLARE @result TABLE
                    (
                        Result INT
                    );

    BEGIN TRY
        INSERT INTO tbUsuarios(nombre, correo, pass, contacto, dui, tipoUsuario)
        VALUES (@nombre, @correo, @pass, @contacto, @dui, 1);
        INSERT INTO @result (Result) VALUES (1);
    END TRY
    BEGIN CATCH
        INSERT INTO @result (Result) VALUES (0);
    END CATCH

    SELECT Result FROM @result;
END
GO

CREATE PROCEDURE spCrearCamarografo @nombre NVARCHAR(50),
                                    @correo VARCHAR(255),
                                    @pass VARCHAR(25),
                                    @contacto VARCHAR(15),
                                    @dui VARCHAR(10)
AS
BEGIN
    DECLARE @result TABLE
                    (
                        Result INT
                    );

    BEGIN TRY
        INSERT INTO tbUsuarios(nombre, correo, pass, contacto, dui, tipoUsuario)
        VALUES (@nombre, @correo, @pass, @contacto, @dui, 2);
        INSERT INTO @result (Result) VALUES (1);
    END TRY
    BEGIN CATCH
        INSERT INTO @result (Result) VALUES (0);
    END CATCH

    SELECT Result FROM @result;
END
GO

-- EXEC spCrearAdministrador 'Camarografo', 'camarografo@camvi.com', '123', '123', '123'


CREATE PROCEDURE spRegistrarCliente @nombre NVARCHAR(50),
                                    @correo VARCHAR(255),
                                    @pass VARCHAR(25),
                                    @contacto VARCHAR(15),
                                    @dui VARCHAR(10)
AS
BEGIN
    DECLARE @result TABLE
                    (
                        Result INT
                    );

    BEGIN TRY
        INSERT INTO tbUsuarios(nombre, correo, pass, contacto, dui, tipoUsuario)
        VALUES (@nombre, @correo, @pass, @contacto, @dui, 3);
        INSERT INTO @result (Result) VALUES (1);
    END TRY
    BEGIN CATCH
        INSERT INTO @result (Result) VALUES (0);
    END CATCH

    SELECT Result FROM @result;
END
GO

-- EXEC spRegistrarCliente '?', '?a', '123', '123', '123'

CREATE PROCEDURE spCodigoRecuperacion @idUsuario INT
AS
BEGIN
    DECLARE @codigo INT;
    SET @codigo = (SELECT ROUND(((9999 - 1000) * RAND() + 1), 0))
    INSERT INTO tbCodigosRecuperacion VALUES (@codigo, @idUsuario)
END
GO
EXEC spCodigoRecuperacion 2
GO



-- Actualizar informaci�n propia
CREATE PROCEDURE spActualizarCamarografo
	@correo VARCHAR(255),
	@nombre NVARCHAR(50),
	@telefono varchar(15),
	@imagen IMAGE,
	@dui VARCHAR(10),
	@contra NVARCHAR(50),
	@idUsuario INT
AS 
BEGIN
	UPDATE tbUsuarios
	SET correo = @correo,
		nombre = @nombre,
		contacto = @telefono,
		imagen = @imagen,
		dui = @dui,
		pass = @contra
	WHERE idUsuario = @idUsuario
END
GO

-- Calificar sesión
CREATE PROCEDURE spCalificarSesion
	@puntualidad SMALLINT,
	@actitud SMALLINT,
	@desempenio SMALLINT,
	@profesionalismo SMALLINT,
	@presentacion SMALLINT,
	@servicioAtencion SMALLINT,
	@espera SMALLINT,
	@calidadProducto SMALLINT,
	@comentarios VARCHAR(255),
	@idCliente INT,
	@idSesion INT
AS
BEGIN 
	INSERT INTO tbCalificacionSesion (puntualidadFotografo, actitudFotografo, 
	desempenoFotografo, profesionalismoFotografo, presentacionPersonalFotografo, 
	servicioDeAtencion, esperaDeRespuestas, calidadDelProductoFinal, comentarios, clienteId, sesionId)
	VALUES (@puntualidad, @actitud, @desempenio, @profesionalismo, @presentacion, @servicioAtencion, @espera, @calidadProducto, 
	@comentarios, @idCliente, @idSesion)
END
GO

-- Agendar cita
CREATE PROCEDURE spAgendarCita
	@titulo VARCHAR(25),
	@detalles VARCHAR(255),
	@idFotoGaleria INT,
	@direccion VARCHAR(200),
	@fechaEvento DATE,
	@horaInicio TIME,
	@horaFin TIME,
	@lugar VARCHAR,
	@confirmada BIT,
	@cancela BIT,
	@idFotografo INT,
	@idCliente INT
AS
BEGIN 
	INSERT INTO tbSesiones(titulo, detalles, idFotoGaleria, direccionEvento, 
	fechaEvento, horaInicio, horaFinalizacion, lugar, confirmada, cancelada, idFotografo, idCliente)
	VALUES(@titulo, @detalles, @idFotoGaleria, @direccion, @fechaEvento, @horaInicio, @horaFin, @lugar, 
	@confirmada, @cancela, @idFotografo, @idCliente)
END
GO

-- Cambiar foto de perfil
CREATE PROCEDURE spCambiarFotoPerfil
	@imagen IMAGE,
	@idCliente INT
AS
BEGIN
	UPDATE tbUsuarios
	SET imagen = @imagen
	WHERE idUsuario = @idCliente
END
GO

---Cambiar contraseña
CREATE PROCEDURE spCambiarContrasenia @correo VARCHAR(255),
									  @codigoRecuperacion VARCHAR(10),
									  @NuevaContra VARCHAR(50)
AS
BEGIN
	 IF NOT EXISTS (
        SELECT 1
        FROM tbCodigosRecuperacion C
        INNER JOIN tbUsuarios U ON C.usuario = U.idUsuario
        WHERE U.correo = @correo AND C.codigo = @codigoRecuperacion
    )
    BEGIN
        RAISERROR('Vuelve a revisar tu correo o codigo de recuperacion', 16, 1);
        RETURN;
    END;

	UPDATE tbUsuarios
    SET pass = @NuevaContra
    WHERE correo = @correo;

	DELETE FROM tbCodigosRecuperacion
    WHERE codigo = @codigoRecuperacion;

END
GO
EXEC spCambiarContrasenia '20190189@ricaldone.edu.sv', '126', '3145' 
GO
