USE Camvi

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

EXEC spCrearAdministrador 'Camarografo', 'camarografo@camvi.com', '123', '123', '123'


CREATE PROCEDURE spRegistrarCliente @nombre NVARCHAR(50),
									@contacto VARCHAR(15),
                                    @dui VARCHAR(10),
                                    @correo VARCHAR(255),
                                    @pass VARCHAR(25)
                                    
AS
BEGIN
    DECLARE @result TABLE
                    (
                        Result INT
                    );

    BEGIN TRY
        INSERT INTO tbUsuarios(nombre, contacto, dui, correo, pass,tipoUsuario)
        VALUES (@nombre, @contacto, @dui, @correo, @pass, 3);
        INSERT INTO @result (Result) VALUES (1);
    END TRY
    BEGIN CATCH
        INSERT INTO @result (Result) VALUES (0);
    END CATCH

    SELECT Result FROM @result;
END
GO

EXEC spRegistrarCliente '?', '?a', '123', '123', '123'
GO
---crear camarografo
CREATE PROCEDURE spRegistrarCamarografo
	@nombre VARCHAR(100),
	@contacto VARCHAR(15),
	@dui VARCHAR(10),
	@correo VARCHAR(255),
	@pass VARCHAR(25)
AS
BEGIN
	DECLARE @result TABLE
			(
				Result INT
			);
	BEGIN TRY
	INSERT INTO tbUsuarios(nombre,contacto,dui, correo,pass, tipoUsuario)
	VALUES (@nombre, @contacto, @dui, @correo, @pass, 2);
	INSERT INTO @result (Result) VALUES (1);
	END TRY
	BEGIN CATCH
		INSERT INTO @result (Result) VALUES(0);
	END CATCH

	SELECT Result FROM @result
END
GO
EXEC spRegistrarCamarografo '?', '?a', 'ee', 'ee', 'ee'
select * from tbUsuarios



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


CREATE PROCEDURE spInsertarCalificacion
	@puntualidadFotografo          SMALLINT,
    @actitudFotografo              SMALLINT,
    @desempenoFotografo            SMALLINT,
    @profesionalismoFotografo      SMALLINT,
    @presentacionPersonalFotografo SMALLINT,
    @servicioDeAtencion            SMALLINT,
    @esperaDeRespuestas            SMALLINT,
    @calidadDelProductoFinal       SMALLINT,
    @comentarios                   VARCHAR(255)
    --@clienteId                     INT,
    --@sesionId                      INT
AS
BEGIN
	DECLARE @result TABLE
                    (
                        Result INT
                    );
	BEGIN TRY
	INSERT INTO tbCalificacionSesion (puntualidadFotografo, actitudFotografo,desempenoFotografo, profesionalismoFotografo,presentacionPersonalFotografo,servicioDeAtencion, 
	esperaDeRespuestas,calidadDelProductoFinal,comentarios) 
	VALUES(@puntualidadFotografo,@actitudFotografo,@desempenoFotografo,@profesionalismoFotografo,@presentacionPersonalFotografo,
	@servicioDeAtencion,@esperaDeRespuestas,@calidadDelProductoFinal,@comentarios)
	INSERT INTO @result (Result) VALUES (1);
	END TRY
	BEGIN CATCH
		INSERT INTO @result (Result) VALUES (0);
	END CATCH

	SELECT Result FROM @result;
	
END
GO

DROP PROCEDURE spInsertarCalificacion



