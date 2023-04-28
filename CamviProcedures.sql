USE Camvi

ALTER PROCEDURE spRegistrarCliente @nombre NVARCHAR(50),
                                    @correo VARCHAR(255),
                                    @pass VARCHAR(25),
                                    @contacto VARCHAR(15),
                                    @dui VARCHAR(10)
AS
BEGIN
    DECLARE @result TABLE (Result INT);

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

EXEC spRegistrarCliente '?', '?a', '123', '123', '123'




