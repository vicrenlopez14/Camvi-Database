USE Camvi

DROP PROCEDURE IF EXISTS spRegistrarCliente
CREATE PROCEDURE spRegistrarCliente @nombre NVARCHAR(50),
                                    @correo VARCHAR(255),
                                    @pass VARCHAR(25),
                                    @contacto VARCHAR(15),
                                   @dui VARCHAR(10)
AS
BEGIN
    DECLARE @result INT = 0;
    BEGIN TRY
        INSERT INTO tbUsuarios(nombre, correo, pass, contacto, dui, tipoUsuario)
        VALUES (@nombre, @correo, @pass, @contacto, @dui, 1)
        SET @result = 1;
    END TRY
    BEGIN CATCH
        SET @result = 0;
    END CATCH

    RETURN @result
END
GO

SELECT *
FROM tbUsuarios

SELECT (EXEC spRegistrarCliente 'Juan Pérez', 'ejemplo@example.com', 'micontrasena', '12345678', '77777777') AS Resultado

DECLARE @result INT;
EXEC @result = spRegistrarCliente 'Juan Pérez', 'ejempalo@examñple.com', 'micontrasena', '12345678', '77777777';

SELECT @result AS Result;

