USE Camvi
GO

CREATE VIEW vwSesionesPorConfirmar
AS
SELECT idSesion,
       direccionEvento,
       fechaEvento,
       horaInicio,
       horaFinalizacion,
       lugar,
       confirmada,
       idFotografo,
       idCliente
FROM tbSesiones
WHERE confirmada = 0;
GO

CREATE VIEW vwSesionesSinFotografo
AS
SELECT idSesion,
       direccionEvento,
       fechaEvento,
       horaInicio,
       horaFinalizacion,
       lugar,
       confirmada,
       idFotografo,
       idCliente
FROM tbSesiones
WHERE idFotografo IS NULL;
GO

CREATE VIEW vwSesionesEnCurso
AS
SELECT idSesion,
       direccionEvento,
       fechaEvento,
       horaInicio,
       horaFinalizacion,
       lugar,
       confirmada,
       idFotografo,
       idCliente
FROM tbSesiones
WHERE realizacion = 'En progreso';
GO

CREATE VIEW vwSesionesFinalizadas
AS
SELECT idSesion,
       direccionEvento,
       fechaEvento,
       horaInicio,
       horaFinalizacion,
       lugar,
       confirmada,
       idFotografo,
       idCliente
FROM tbSesiones
WHERE realizacion = 'Finalizado';
GO

CREATE VIEW vwSesionesPendientes
AS
SELECT idSesion,
       direccionEvento,
       fechaEvento,
       horaInicio,
       horaFinalizacion,
       lugar,
       confirmada,
       idFotografo,
       idCliente
FROM tbSesiones
WHERE realizacion = 'Pendiente';
GO

CREATE VIEW vwNumeroDeCamarografosRegistrados
AS
(
SELECT COUNT(idUsuario) AS NumCamarografosRegistrados
FROM tbUsuarios
WHERE tipoUsuario = 2)

CREATE VIEW vwNombresCamarografosDesocupados AS
SELECT nombre
FROM tbUsuarios
WHERE tipoUsuario = 2
  AND idUsuario NOT IN (SELECT idFotografo FROM tbSesiones WHERE realizacion = 'En progreso');

CREATE VIEW vwNumeroCamarografosDesocupados
AS
SELECT COUNT(nombre) AS NombreCamarografoDesocupado
FROM vwNombresCamarografosDesocupados;


CREATE VIEW vwEstadisticaSesionesEnCurso
AS
SELECT (SELECT COUNT(*) FROM vwSesionesEnCurso) AS SesionesEnCurso,
       CASE
           WHEN COUNT(idSesion) = (SELECT COUNT(*) FROM vwNumeroDeCamarografosRegistrados)
               THEN 'Todos los camarógrafos están ocupados'
           WHEN COUNT(idSesion) = 0
               THEN 'No hay camarógrafos ocupados'
           ELSE 'Hay ' + CAST(COUNT(idSesion) AS VARCHAR(2)) +
                IIF(COUNT(idSesion) = 1, ' camarógrafo', ' camarógrafos') + ' ocupados y ' +
                CAST((SELECT COUNT(*) FROM vwNumeroDeCamarografosRegistrados) - COUNT(idSesion) AS VARCHAR(2)) +
                IIF((SELECT COUNT(*) FROM vwNumeroDeCamarografosRegistrados) - COUNT(idSesion) = 1,
                    ' camarógrafo', ' camarógrafos') + ' desocupados'
           END                                  AS Mensaje
FROM vwSesionesEnCurso;
GO

SELECT *
FROM vwEstadisticaSesionesEnCurso;

CREATE VIEW vwCamarografos
AS
	SELECT u.nombre, u.imagen
	FROM tbUsuarios u
	WHERE u.tipoUsuario=2
GO
SELECT * FROM vwCamarografos


CREATE VIEW vwSesionesAgendadasHoy
AS
	SELECT f.foto, s.titulo, u.nombre, s.fechaEvento
	FROM tbSesiones s
	INNER JOIN tbFotosGaleria f ON s.idFotoGaleria=f.idFoto
	INNER JOIN tbUsuarios u ON s.idCliente=u.idUsuario
	INNER JOIN tbTipoUsuarios o ON u.idUsuario=o.idTipoUsuario
	WHERE s.fechaEvento=CONVERT(nvarchar,GETDATE())
GO

CREATE VIEW vwSinCamareografo
AS
	SELECT tbFotosGaleria.foto, tbSesiones.titulo, tbSesiones.fechaEvento, tbSesiones.idFotografo
	FROM tbSesiones 
	INNER JOIN tbFotosGaleria ON tbSesiones.idFotoGaleria=tbFotosGaleria.idFoto
	WHERE tbSesiones.idFotografo IS NULL;
GO
	SELECT * from vwSinCamareografo;
GO
