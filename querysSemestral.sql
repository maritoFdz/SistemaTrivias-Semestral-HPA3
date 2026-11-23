-- bd del sistema de trivias
-- admin: admin@trivias.local / Admin#2026

CREATE DATABASE IF NOT EXISTS bd_trivias
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_trivias;

-- borro todo para poder correr el script varias vecs
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS log_errores, noticias, calificaciones, sets_qr, imagenes_resultado,
                     usuario_premios, respuestas, partidas, premios, opciones, preguntas,
                     niveles, temas, avatares, usuarios;
SET FOREIGN_KEY_CHECKS = 1;

-- usuarios
CREATE TABLE usuarios (
  id                    INT          NOT NULL AUTO_INCREMENT,
  dsCedula              VARCHAR(20)  NOT NULL,                 -- no se edita
  dsNombre              VARCHAR(100) NOT NULL,
  dsCorreo              VARCHAR(100) NOT NULL,                 -- con este entra
  dsPassword            VARCHAR(255) NOT NULL,                 -- hash
  dsRol                 VARCHAR(10)  NOT NULL DEFAULT 'JUGADOR',
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',     -- 1 activo, 0 inactivo
  idAvatar              INT          NULL,
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsUsuarioModificacion VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaModificacion   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_dsCedula (dsCedula),
  UNIQUE KEY uq_usuarios_dsCorreo (dsCorreo),
  CONSTRAINT ck_usuarios_dsRol    CHECK (dsRol IN ('ADMIN','OPERATIVO','JUGADOR')),
  CONSTRAINT ck_usuarios_dsEstado CHECK (dsEstado IN ('0','1'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- avatares, se desactivan no se borran
CREATE TABLE avatares (
  id                    INT          NOT NULL AUTO_INCREMENT,
  idUsuario             INT          NOT NULL,
  dsNombre              VARCHAR(60)  NOT NULL,
  dsRutaImagen          VARCHAR(255) NOT NULL,
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsUsuarioModificacion VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaModificacion   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_avatares_idUsuario (idUsuario),
  CONSTRAINT fk_avatares_usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios (id),
  CONSTRAINT ck_avatares_dsEstado CHECK (dsEstado IN ('0','1'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- esto va con alter porque usuarios y avatares se referencian entre si
ALTER TABLE usuarios
  ADD CONSTRAINT fk_usuarios_avatares FOREIGN KEY (idAvatar) REFERENCES avatares (id) ON DELETE SET NULL;

-- temas
CREATE TABLE temas (
  id                    INT          NOT NULL AUTO_INCREMENT,
  dsNombre              VARCHAR(60)  NOT NULL,
  dsDescripcion         VARCHAR(255) NULL,
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsUsuarioModificacion VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaModificacion   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_temas_dsNombre (dsNombre),
  CONSTRAINT ck_temas_dsEstado CHECK (dsEstado IN ('0','1'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- niveles, nuOrden dice cual es el q va primero
CREATE TABLE niveles (
  id                     INT         NOT NULL AUTO_INCREMENT,
  dsNombre               VARCHAR(30) NOT NULL,
  nuOrden                TINYINT     NOT NULL,
  nuPorcentajeAprobacion TINYINT     NOT NULL DEFAULT 70,   -- % para aprobar
  PRIMARY KEY (id),
  UNIQUE KEY uq_niveles_dsNombre (dsNombre),
  UNIQUE KEY uq_niveles_nuOrden (nuOrden)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- preguntas con tema y nivel
CREATE TABLE preguntas (
  id                    INT          NOT NULL AUTO_INCREMENT,
  idTema                INT          NOT NULL,
  idNivel               INT          NOT NULL,
  dsTipo                VARCHAR(20)  NOT NULL DEFAULT 'OPCION_MULTIPLE',
  dsEnunciado           VARCHAR(500) NOT NULL,
  nuPuntos              INT          NOT NULL DEFAULT 10,
  nuSegundos            INT          NOT NULL DEFAULT 30,    -- tiempo para responder
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsUsuarioModificacion VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaModificacion   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_preguntas_tema_nivel (idTema, idNivel),
  CONSTRAINT fk_preguntas_temas   FOREIGN KEY (idTema)  REFERENCES temas (id),
  CONSTRAINT fk_preguntas_niveles FOREIGN KEY (idNivel) REFERENCES niveles (id),
  CONSTRAINT ck_preguntas_dsTipo  CHECK (dsTipo IN ('OPCION_MULTIPLE','VERDADERO_FALSO')),
  CONSTRAINT ck_preguntas_dsEstado CHECK (dsEstado IN ('0','1'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- opciones de cada pregunta
CREATE TABLE opciones (
  id           INT          NOT NULL AUTO_INCREMENT,
  idPregunta   INT          NOT NULL,
  dsTexto      VARCHAR(255) NOT NULL,
  nuEsCorrecta TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY ix_opciones_idPregunta (idPregunta),
  CONSTRAINT fk_opciones_preguntas FOREIGN KEY (idPregunta) REFERENCES preguntas (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- premios por tema y nivel
CREATE TABLE premios (
  id                    INT          NOT NULL AUTO_INCREMENT,
  idTema                INT          NOT NULL,
  idNivel               INT          NOT NULL,
  dsNombre              VARCHAR(80)  NOT NULL,
  dsDescripcion         VARCHAR(255) NULL,
  dsRutaImagen          VARCHAR(255) NOT NULL,
  nuPuntos              INT          NOT NULL DEFAULT 50,
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsUsuarioModificacion VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaModificacion   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_premios_tema_nivel (idTema, idNivel),
  CONSTRAINT fk_premios_temas   FOREIGN KEY (idTema)  REFERENCES temas (id),
  CONSTRAINT fk_premios_niveles FOREIGN KEY (idNivel) REFERENCES niveles (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- sets para el qr (Jugar.aspx?set=codigo)
CREATE TABLE sets_qr (
  id                    INT          NOT NULL AUTO_INCREMENT,
  dsCodigo              VARCHAR(36)  NOT NULL,
  dsNombre              VARCHAR(100) NOT NULL,
  idTema                INT          NOT NULL,
  idNivel               INT          NOT NULL,
  nuCantidadPreguntas   INT          NOT NULL DEFAULT 5,
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sets_qr_dsCodigo (dsCodigo),
  CONSTRAINT fk_sets_qr_temas   FOREIGN KEY (idTema)  REFERENCES temas (id),
  CONSTRAINT fk_sets_qr_niveles FOREIGN KEY (idNivel) REFERENCES niveles (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- partidas, de aqui salen los puntos, % y reportes
CREATE TABLE partidas (
  id               INT          NOT NULL AUTO_INCREMENT,
  idUsuario        INT          NOT NULL,
  idTema           INT          NOT NULL,
  idNivel          INT          NOT NULL,
  idSetQr          INT          NULL,
  dtInicio         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dtFin            DATETIME     NULL,
  nuTotalPreguntas INT          NOT NULL DEFAULT 0,
  nuAciertos       INT          NOT NULL DEFAULT 0,
  nuPuntos         INT          NOT NULL DEFAULT 0,
  nuPorcentaje     DECIMAL(5,2) NOT NULL DEFAULT 0,
  nuAprobado       TINYINT(1)   NOT NULL DEFAULT 0,
  nuSegundosTotal  INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY ix_partidas_usuario_tema_nivel (idUsuario, idTema, idNivel),
  CONSTRAINT fk_partidas_usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios (id),
  CONSTRAINT fk_partidas_temas    FOREIGN KEY (idTema)    REFERENCES temas (id),
  CONSTRAINT fk_partidas_niveles  FOREIGN KEY (idNivel)   REFERENCES niveles (id),
  CONSTRAINT fk_partidas_sets_qr  FOREIGN KEY (idSetQr)   REFERENCES sets_qr (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- respuestas de cada partida
CREATE TABLE respuestas (
  id            INT        NOT NULL AUTO_INCREMENT,
  idPartida     INT        NOT NULL,
  idPregunta    INT        NOT NULL,
  idOpcion      INT        NULL,                 -- null si se acabo el tiempo
  nuEsCorrecta  TINYINT(1) NOT NULL DEFAULT 0,
  nuSegundos    INT        NOT NULL DEFAULT 0,   -- cuanto tardo
  dtRespuesta   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_respuestas_idPartida (idPartida),
  CONSTRAINT fk_respuestas_partidas  FOREIGN KEY (idPartida)  REFERENCES partidas (id) ON DELETE CASCADE,
  CONSTRAINT fk_respuestas_preguntas FOREIGN KEY (idPregunta) REFERENCES preguntas (id),
  CONSTRAINT fk_respuestas_opciones  FOREIGN KEY (idOpcion)   REFERENCES opciones (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- premios que ya gano cada usuario
CREATE TABLE usuario_premios (
  id           INT      NOT NULL AUTO_INCREMENT,
  idUsuario    INT      NOT NULL,
  idPremio     INT      NOT NULL,
  idPartida    INT      NOT NULL,
  dtObtenido   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_premios (idUsuario, idPremio),
  CONSTRAINT fk_up_usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios (id),
  CONSTRAINT fk_up_premios  FOREIGN KEY (idPremio)  REFERENCES premios (id),
  CONSTRAINT fk_up_partidas FOREIGN KEY (idPartida) REFERENCES partidas (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- imagen segun el % que saque (pueden ser gif)
CREATE TABLE imagenes_resultado (
  id                 INT          NOT NULL AUTO_INCREMENT,
  nuPorcentajeMinimo TINYINT      NOT NULL,
  dsMensaje          VARCHAR(120) NOT NULL,
  dsRutaImagen       VARCHAR(255) NOT NULL,
  dsEstado           CHAR(1)      NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  UNIQUE KEY uq_imagenes_resultado_pct (nuPorcentajeMinimo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- calificaciones del tema y la app
CREATE TABLE calificaciones (
  id             INT          NOT NULL AUTO_INCREMENT,
  idUsuario      INT          NOT NULL,
  idTema         INT          NOT NULL,
  nuCalifTema    TINYINT      NOT NULL,           -- 1 a 4
  nuCalifApp     TINYINT      NOT NULL,           -- 1 a 4
  dsTemaSugerido VARCHAR(200) NULL,
  dsComentario   VARCHAR(500) NULL,
  dtFecha        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_calif_usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios (id),
  CONSTRAINT fk_calif_temas    FOREIGN KEY (idTema)    REFERENCES temas (id),
  CONSTRAINT ck_calif_tema CHECK (nuCalifTema BETWEEN 1 AND 4),
  CONSTRAINT ck_calif_app  CHECK (nuCalifApp  BETWEEN 1 AND 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- noticias de la pagina publica
CREATE TABLE noticias (
  id                    INT          NOT NULL AUTO_INCREMENT,
  dsTitulo              VARCHAR(150) NOT NULL,
  dsResumen             VARCHAR(300) NOT NULL,
  dsContenido           TEXT         NOT NULL,
  dsRutaImagen          VARCHAR(255) NULL,
  dtPublicacion         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsEstado              CHAR(1)      NOT NULL DEFAULT '1',
  dsUsuarioCreacion     VARCHAR(100) NOT NULL DEFAULT 'Sistema',
  dtFechaCreacion       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- log de errores
CREATE TABLE log_errores (
  id         BIGINT       NOT NULL AUTO_INCREMENT,
  dtFecha    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dsOrigen   VARCHAR(100) NOT NULL,
  dsMensaje  VARCHAR(500) NOT NULL,
  dsDetalle  TEXT         NULL,
  dsUsuario  VARCHAR(100) NOT NULL DEFAULT 'anonimo',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- datos iniciales
INSERT INTO niveles (dsNombre, nuOrden, nuPorcentajeAprobacion) VALUES
  ('Novato', 1, 70), ('Principiante', 2, 70), ('Experto', 3, 70);

INSERT INTO temas (dsNombre, dsDescripcion) VALUES
  ('C#',         'Lenguaje de programación de .NET'),
  ('ASP.NET',    'Framework web de Microsoft'),
  ('HTML',       'Lenguaje de marcado para páginas web'),
  ('Bootstrap',  'Framework CSS para diseño responsive'),
  ('PHP',        'Lenguaje de programación para el servidor'),
  ('JavaScript', 'Lenguaje de programación del navegador'),
  ('Laravel',    'Framework de PHP');

-- clave del admin: Admin#2026
INSERT INTO usuarios (dsCedula, dsNombre, dsCorreo, dsPassword, dsRol, dsEstado, dsUsuarioCreacion)
VALUES ('0-000-0000', 'Administrador', 'admin@trivias.local',
        'PBKDF2$100000$4tLRmAljceo3YVuLP8Foeg==$nJDtBlm2N173hd7eC8A77NdXSznx+rZUP3aib8iPmOw=',
        'ADMIN', '1', 'Sistema');

-- procedimientos almacenados
DROP PROCEDURE IF EXISTS sp_login;
DROP PROCEDURE IF EXISTS sp_log_error;

DELIMITER $$

CREATE PROCEDURE sp_login(IN p_correo VARCHAR(100))
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsPassword, dsRol, dsEstado, idAvatar
    FROM usuarios
    WHERE dsCorreo = p_correo
      AND dsEstado = '1';
END$$

CREATE PROCEDURE sp_log_error(
    IN p_origen  VARCHAR(100),
    IN p_mensaje VARCHAR(500),
    IN p_detalle TEXT,
    IN p_usuario VARCHAR(100))
BEGIN
    INSERT INTO log_errores (dsOrigen, dsMensaje, dsDetalle, dsUsuario)
    VALUES (p_origen, p_mensaje, p_detalle, p_usuario);
END$$

DELIMITER ;

-- usuario de la app, solo puede ejecutar procedimientos
CREATE USER IF NOT EXISTS 'app_trivias'@'localhost' IDENTIFIED BY 'ClaveSegura#2026';
GRANT EXECUTE ON bd_trivias.* TO 'app_trivias'@'localhost';
FLUSH PRIVILEGES;

USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_usuario_listar;
DROP PROCEDURE IF EXISTS sp_usuario_obtener;
DROP PROCEDURE IF EXISTS sp_usuario_registrar;
DROP PROCEDURE IF EXISTS sp_usuario_actualizar;
DROP PROCEDURE IF EXISTS sp_usuario_cambiar_estado;

DELIMITER $$

-- lista de usuarios (sin el hash)
CREATE PROCEDURE sp_usuario_listar()
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsRol, dsEstado, idAvatar
    FROM usuarios
    ORDER BY id;
END$$

CREATE PROCEDURE sp_usuario_obtener(IN p_id INT)
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsRol, dsEstado, idAvatar
    FROM usuarios
    WHERE id = p_id;
END$$

CREATE PROCEDURE sp_usuario_registrar(
    IN p_cedula  VARCHAR(20),
    IN p_nombre  VARCHAR(100),
    IN p_correo  VARCHAR(100),
    IN p_hash    VARCHAR(255),
    IN p_rol     VARCHAR(10),
    IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO usuarios (dsCedula, dsNombre, dsCorreo, dsPassword, dsRol, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_cedula, p_nombre, p_correo, p_hash, p_rol, p_creador, p_creador);
END$$

-- este no recibe la cedula, asi que desde aqui tampoco se puede editar
-- si p_hash viene null deja la clave como estaba
CREATE PROCEDURE sp_usuario_actualizar(
    IN p_id          INT,
    IN p_nombre      VARCHAR(100),
    IN p_correo      VARCHAR(100),
    IN p_rol         VARCHAR(10),
    IN p_hash        VARCHAR(255),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE usuarios
    SET dsNombre = p_nombre,
        dsCorreo = p_correo,
        dsRol = p_rol,
        dsPassword = IFNULL(p_hash, dsPassword),
        dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END$$

CREATE PROCEDURE sp_usuario_cambiar_estado(
    IN p_id          INT,
    IN p_estado      CHAR(1),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE usuarios
    SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END$$

DELIMITER ;

USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_avatar_listar;
DROP PROCEDURE IF EXISTS sp_avatar_obtener;
DROP PROCEDURE IF EXISTS sp_avatar_actual;
DROP PROCEDURE IF EXISTS sp_avatar_registrar;
DROP PROCEDURE IF EXISTS sp_avatar_actualizar;
DROP PROCEDURE IF EXISTS sp_avatar_cambiar_estado;
DROP PROCEDURE IF EXISTS sp_avatar_usar;

DELIMITER $$

-- si p_idUsuario es null trae todos los avatares
CREATE PROCEDURE sp_avatar_listar(IN p_idUsuario INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM avatares a
    INNER JOIN usuarios u ON u.id = a.idUsuario
    WHERE p_idUsuario IS NULL OR a.idUsuario = p_idUsuario
    ORDER BY a.dsEstado DESC, a.id DESC;
END$$

CREATE PROCEDURE sp_avatar_obtener(IN p_id INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM avatares a
    INNER JOIN usuarios u ON u.id = a.idUsuario
    WHERE a.id = p_id;
END$$

-- el avatar que el usuario tiene puesto, solo si sigue activo
CREATE PROCEDURE sp_avatar_actual(IN p_idUsuario INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM usuarios u
    INNER JOIN avatares a ON a.id = u.idAvatar
    WHERE u.id = p_idUsuario AND a.dsEstado = '1';
END$$

CREATE PROCEDURE sp_avatar_registrar(
    IN p_idUsuario INT,
    IN p_nombre    VARCHAR(60),
    IN p_ruta      VARCHAR(255),
    IN p_creador   VARCHAR(100))
BEGIN
    INSERT INTO avatares (idUsuario, dsNombre, dsRutaImagen, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_idUsuario, p_nombre, p_ruta, p_creador, p_creador);
END$$

-- si p_ruta viene null deja la imagen como estaba
CREATE PROCEDURE sp_avatar_actualizar(
    IN p_id          INT,
    IN p_nombre      VARCHAR(60),
    IN p_ruta        VARCHAR(255),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE avatares
    SET dsNombre = p_nombre,
        dsRutaImagen = IFNULL(p_ruta, dsRutaImagen),
        dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END$$

-- desactivar no borra nada y si alguien lo tenia puesto se lo quita
CREATE PROCEDURE sp_avatar_cambiar_estado(
    IN p_id          INT,
    IN p_estado      CHAR(1),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE avatares SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
    IF p_estado = '0' THEN
        UPDATE usuarios SET idAvatar = NULL WHERE idAvatar = p_id;
    END IF;
END$$

CREATE PROCEDURE sp_avatar_usar(
    IN p_idUsuario   INT,
    IN p_idAvatar    INT,
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE usuarios SET idAvatar = p_idAvatar, dsUsuarioModificacion = p_modificador WHERE id = p_idUsuario;
END$$

DELIMITER ;

USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_tema_listar;
DROP PROCEDURE IF EXISTS sp_tema_obtener;
DROP PROCEDURE IF EXISTS sp_tema_registrar;
DROP PROCEDURE IF EXISTS sp_tema_actualizar;
DROP PROCEDURE IF EXISTS sp_tema_cambiar_estado;
DROP PROCEDURE IF EXISTS sp_nivel_listar;
DROP PROCEDURE IF EXISTS sp_pregunta_listar;
DROP PROCEDURE IF EXISTS sp_pregunta_obtener;
DROP PROCEDURE IF EXISTS sp_opcion_listar;
DROP PROCEDURE IF EXISTS sp_pregunta_registrar;
DROP PROCEDURE IF EXISTS sp_pregunta_actualizar;
DROP PROCEDURE IF EXISTS sp_pregunta_cambiar_estado;

DELIMITER $$

-- temas
CREATE PROCEDURE sp_tema_listar()
BEGIN
    SELECT id, dsNombre, dsDescripcion, dsEstado FROM temas ORDER BY dsNombre;
END$$

CREATE PROCEDURE sp_tema_obtener(IN p_id INT)
BEGIN
    SELECT id, dsNombre, dsDescripcion, dsEstado FROM temas WHERE id = p_id;
END$$

CREATE PROCEDURE sp_tema_registrar(IN p_nombre VARCHAR(60), IN p_descripcion VARCHAR(255), IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO temas (dsNombre, dsDescripcion, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_nombre, p_descripcion, p_creador, p_creador);
END$$

CREATE PROCEDURE sp_tema_actualizar(IN p_id INT, IN p_nombre VARCHAR(60), IN p_descripcion VARCHAR(255), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE temas SET dsNombre = p_nombre, dsDescripcion = p_descripcion, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END$$

CREATE PROCEDURE sp_tema_cambiar_estado(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE temas SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END$$

-- niveles
CREATE PROCEDURE sp_nivel_listar()
BEGIN
    SELECT id, dsNombre, nuOrden, nuPorcentajeAprobacion FROM niveles ORDER BY nuOrden;
END$$

-- preguntas, si el tema o el nivel vienen null trae todas
CREATE PROCEDURE sp_pregunta_listar(IN p_idTema INT, IN p_idNivel INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsTipo, p.dsEnunciado, p.nuPuntos, p.nuSegundos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM preguntas p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE (p_idTema IS NULL OR p.idTema = p_idTema) AND (p_idNivel IS NULL OR p.idNivel = p_idNivel)
    ORDER BY t.dsNombre, n.nuOrden, p.id;
END$$

CREATE PROCEDURE sp_pregunta_obtener(IN p_id INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsTipo, p.dsEnunciado, p.nuPuntos, p.nuSegundos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM preguntas p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE p.id = p_id;
END$$

CREATE PROCEDURE sp_opcion_listar(IN p_idPregunta INT)
BEGIN
    SELECT id, idPregunta, dsTexto, nuEsCorrecta FROM opciones WHERE idPregunta = p_idPregunta ORDER BY id;
END$$

-- crea la pregunta y sus opciones en una sola llamada
-- verdadero o falso manda solo 2 opciones y p_correcta es la posicion de la buena
CREATE PROCEDURE sp_pregunta_registrar(
    IN p_idTema INT, IN p_idNivel INT, IN p_tipo VARCHAR(20), IN p_enunciado VARCHAR(500),
    IN p_puntos INT, IN p_segundos INT,
    IN p_op1 VARCHAR(255), IN p_op2 VARCHAR(255), IN p_op3 VARCHAR(255), IN p_op4 VARCHAR(255),
    IN p_correcta INT, IN p_creador VARCHAR(100))
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    INSERT INTO preguntas (idTema, idNivel, dsTipo, dsEnunciado, nuPuntos, nuSegundos, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_idTema, p_idNivel, p_tipo, p_enunciado, p_puntos, p_segundos, p_creador, p_creador);
    SET v_id = LAST_INSERT_ID();
    INSERT INTO opciones (idPregunta, dsTexto, nuEsCorrecta) VALUES (v_id, p_op1, p_correcta = 1);
    INSERT INTO opciones (idPregunta, dsTexto, nuEsCorrecta) VALUES (v_id, p_op2, p_correcta = 2);
    IF p_op3 IS NOT NULL THEN INSERT INTO opciones (idPregunta, dsTexto, nuEsCorrecta) VALUES (v_id, p_op3, p_correcta = 3); END IF;
    IF p_op4 IS NOT NULL THEN INSERT INTO opciones (idPregunta, dsTexto, nuEsCorrecta) VALUES (v_id, p_op4, p_correcta = 4); END IF;
    COMMIT;
END$$

-- las opciones se editan en el mismo lugar y no se borran porque las respuestas ya jugadas las usan
-- el tipo no se cambia porque cambiaria la cantidad de opciones
CREATE PROCEDURE sp_pregunta_actualizar(
    IN p_id INT, IN p_idTema INT, IN p_idNivel INT, IN p_enunciado VARCHAR(500),
    IN p_puntos INT, IN p_segundos INT,
    IN p_op1 VARCHAR(255), IN p_op2 VARCHAR(255), IN p_op3 VARCHAR(255), IN p_op4 VARCHAR(255),
    IN p_correcta INT, IN p_modificador VARCHAR(100))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    UPDATE preguntas
    SET idTema = p_idTema, idNivel = p_idNivel, dsEnunciado = p_enunciado, nuPuntos = p_puntos,
        nuSegundos = p_segundos, dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
    UPDATE opciones o
    INNER JOIN (SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS pos FROM opciones WHERE idPregunta = p_id) x ON x.id = o.id
    SET o.dsTexto = ELT(x.pos, p_op1, p_op2, p_op3, p_op4), o.nuEsCorrecta = (x.pos = p_correcta);
    COMMIT;
END$$

CREATE PROCEDURE sp_pregunta_cambiar_estado(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE preguntas SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END$$

DELIMITER ;

USE bd_trivias;

-- preguntas de ejemplo para probar el juego
-- correrlo una sola vez o se duplican
SET @c  = (SELECT id FROM temas WHERE dsNombre = 'C#');
SET @a  = (SELECT id FROM temas WHERE dsNombre = 'ASP.NET');
SET @h  = (SELECT id FROM temas WHERE dsNombre = 'HTML');
SET @b  = (SELECT id FROM temas WHERE dsNombre = 'Bootstrap');
SET @p  = (SELECT id FROM temas WHERE dsNombre = 'PHP');
SET @j  = (SELECT id FROM temas WHERE dsNombre = 'JavaScript');
SET @l  = (SELECT id FROM temas WHERE dsNombre = 'Laravel');
SET @n1 = (SELECT id FROM niveles WHERE nuOrden = 1);
SET @n2 = (SELECT id FROM niveles WHERE nuOrden = 2);
SET @n3 = (SELECT id FROM niveles WHERE nuOrden = 3);

-- c#
CALL sp_pregunta_registrar(@c, @n1, 'OPCION_MULTIPLE', '¿Qué palabra clave se usa para declarar una constante en C#?', 10, 30, 'final', 'const', 'static', 'readonly var', 2, 'seed');
CALL sp_pregunta_registrar(@c, @n1, 'VERDADERO_FALSO', 'C# es un lenguaje de programación orientado a objetos.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@c, @n2, 'OPCION_MULTIPLE', '¿Qué estructura recorre una colección elemento por elemento?', 20, 30, 'while', 'switch', 'foreach', 'goto', 3, 'seed');
CALL sp_pregunta_registrar(@c, @n2, 'VERDADERO_FALSO', 'En C# un string se puede modificar en el mismo objeto sin crear otro.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@c, @n3, 'OPCION_MULTIPLE', '¿Qué palabra clave libera un recurso, como una conexión, al salir de su bloque?', 30, 45, 'lock', 'ref', 'out', 'using', 4, 'seed');
CALL sp_pregunta_registrar(@c, @n3, 'VERDADERO_FALSO', 'Un struct en C# es un tipo por referencia.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');

-- asp.net
CALL sp_pregunta_registrar(@a, @n1, 'OPCION_MULTIPLE', '¿Qué extensión tienen las páginas de Web Forms?', 10, 30, '.cshtml', '.php', '.aspx', '.html', 3, 'seed');
CALL sp_pregunta_registrar(@a, @n1, 'VERDADERO_FALSO', 'ASP.NET es un framework de Microsoft para crear aplicaciones web.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@a, @n2, 'OPCION_MULTIPLE', '¿Qué objeto guarda datos de un usuario entre varias páginas durante su visita?', 20, 30, 'Session', 'Request', 'Response', 'Server', 1, 'seed');
CALL sp_pregunta_registrar(@a, @n2, 'VERDADERO_FALSO', 'Una Master Page permite compartir un diseño común entre varias páginas.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@a, @n3, 'OPCION_MULTIPLE', '¿Cuál de estos eventos de la página ocurre primero?', 30, 45, 'Page_Load', 'Page_Init', 'Page_PreRender', 'Page_Unload', 2, 'seed');
CALL sp_pregunta_registrar(@a, @n3, 'VERDADERO_FALSO', 'El ViewState guarda su información en el servidor por defecto.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');

-- html
CALL sp_pregunta_registrar(@h, @n1, 'OPCION_MULTIPLE', '¿Qué etiqueta se usa para crear un enlace?', 10, 30, '<link>', '<href>', '<url>', '<a>', 4, 'seed');
CALL sp_pregunta_registrar(@h, @n1, 'VERDADERO_FALSO', 'La etiqueta <img> necesita una etiqueta de cierre.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@h, @n2, 'OPCION_MULTIPLE', '¿Qué atributo de <img> describe la imagen para lectores de pantalla?', 20, 30, 'title', 'alt', 'src', 'name', 2, 'seed');
CALL sp_pregunta_registrar(@h, @n2, 'VERDADERO_FALSO', 'La etiqueta <ul> crea una lista ordenada con números.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@h, @n3, 'OPCION_MULTIPLE', '¿Qué etiqueta semántica representa el contenido principal de una página?', 30, 45, '<div>', '<section>', '<main>', '<span>', 3, 'seed');
CALL sp_pregunta_registrar(@h, @n3, 'VERDADERO_FALSO', 'Los atributos data-* permiten guardar datos personalizados en un elemento.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- bootstrap
CALL sp_pregunta_registrar(@b, @n1, 'OPCION_MULTIPLE', '¿Qué clases crean un botón azul principal en Bootstrap?', 10, 30, 'btn btn-primary', 'button blue', 'btn-blue', 'primary-button', 1, 'seed');
CALL sp_pregunta_registrar(@b, @n1, 'VERDADERO_FALSO', 'Bootstrap se puede usar incluyéndolo desde un CDN.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@b, @n2, 'OPCION_MULTIPLE', '¿Cuántas columnas tiene el sistema de rejilla de Bootstrap?', 20, 30, '6', '10', '16', '12', 4, 'seed');
CALL sp_pregunta_registrar(@b, @n2, 'VERDADERO_FALSO', 'La clase d-none oculta un elemento.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@b, @n3, 'OPCION_MULTIPLE', '¿Qué sufijo hace que col-__-6 aplique desde pantallas medianas hacia arriba?', 30, 45, 'xs', 'md', 'mid', 'big', 2, 'seed');
CALL sp_pregunta_registrar(@b, @n3, 'VERDADERO_FALSO', 'Bootstrap 5 necesita jQuery para funcionar.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');

-- php
CALL sp_pregunta_registrar(@p, @n1, 'OPCION_MULTIPLE', '¿Con qué símbolo empieza el nombre de una variable en PHP?', 10, 30, '@', '#', '$', '&', 3, 'seed');
CALL sp_pregunta_registrar(@p, @n1, 'VERDADERO_FALSO', 'PHP es un lenguaje que se ejecuta en el servidor.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@p, @n2, 'OPCION_MULTIPLE', '¿Qué operador concatena dos cadenas en PHP?', 20, 30, 'El punto (.)', 'El signo más (+)', 'El ampersand (&)', 'La coma (,)', 1, 'seed');
CALL sp_pregunta_registrar(@p, @n2, 'VERDADERO_FALSO', 'En PHP los arreglos asociativos usan pares clave => valor.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@p, @n3, 'OPCION_MULTIPLE', '¿Qué superglobal contiene los datos enviados por un formulario con método POST?', 30, 45, '$_GET', '$_SESSION', '$_COOKIE', '$_POST', 4, 'seed');
CALL sp_pregunta_registrar(@p, @n3, 'VERDADERO_FALSO', 'La función password_hash() sirve para guardar contraseñas de forma segura en PHP.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- javascript
CALL sp_pregunta_registrar(@j, @n1, 'OPCION_MULTIPLE', '¿Qué palabra clave declara una constante en JavaScript?', 10, 30, 'let', 'const', 'var', 'def', 2, 'seed');
CALL sp_pregunta_registrar(@j, @n1, 'VERDADERO_FALSO', 'JavaScript y Java son el mismo lenguaje.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@j, @n2, 'OPCION_MULTIPLE', '¿Qué método agrega un elemento al final de un arreglo?', 20, 30, 'pop', 'shift', 'push', 'unshift', 3, 'seed');
CALL sp_pregunta_registrar(@j, @n2, 'VERDADERO_FALSO', 'El operador === compara el valor y también el tipo.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@j, @n3, 'OPCION_MULTIPLE', '¿Qué devuelve una función declarada como async?', 30, 45, 'Un string', 'Un array', 'undefined siempre', 'Una Promise', 4, 'seed');
CALL sp_pregunta_registrar(@j, @n3, 'VERDADERO_FALSO', 'typeof null devuelve la cadena "null".', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');

-- laravel
CALL sp_pregunta_registrar(@l, @n1, 'OPCION_MULTIPLE', '¿En qué lenguaje está hecho Laravel?', 10, 30, 'C#', 'PHP', 'Java', 'Python', 2, 'seed');
CALL sp_pregunta_registrar(@l, @n1, 'VERDADERO_FALSO', 'Laravel es un framework.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@l, @n2, 'OPCION_MULTIPLE', '¿Qué comando de la consola de Laravel crea un controlador?', 20, 30, 'php laravel new-controller', 'composer make:controller', 'php artisan make:controller', 'php make controller', 3, 'seed');
CALL sp_pregunta_registrar(@l, @n2, 'VERDADERO_FALSO', 'Blade es el motor de plantillas de Laravel.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@l, @n3, 'OPCION_MULTIPLE', '¿Cómo se llama el ORM que incluye Laravel?', 30, 45, 'Doctrine', 'Hibernate', 'Entity', 'Eloquent', 4, 'seed');
CALL sp_pregunta_registrar(@l, @n3, 'VERDADERO_FALSO', 'Las migraciones de Laravel sirven para versionar los cambios en la estructura de la base de datos.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_premio_listar;
DROP PROCEDURE IF EXISTS sp_premio_obtener;
DROP PROCEDURE IF EXISTS sp_premio_registrar;
DROP PROCEDURE IF EXISTS sp_premio_actualizar;
DROP PROCEDURE IF EXISTS sp_premio_cambiar_estado;
DROP PROCEDURE IF EXISTS sp_imgres_listar;
DROP PROCEDURE IF EXISTS sp_imgres_obtener;
DROP PROCEDURE IF EXISTS sp_imgres_registrar;
DROP PROCEDURE IF EXISTS sp_imgres_actualizar;
DROP PROCEDURE IF EXISTS sp_imgres_cambiar_estado;

DELIMITER $$

-- premios, uno por tema y nivel
CREATE PROCEDURE sp_premio_listar()
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsNombre, p.dsDescripcion, p.dsRutaImagen, p.nuPuntos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM premios p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    ORDER BY t.dsNombre, n.nuOrden;
END$$

CREATE PROCEDURE sp_premio_obtener(IN p_id INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsNombre, p.dsDescripcion, p.dsRutaImagen, p.nuPuntos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM premios p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE p.id = p_id;
END$$

CREATE PROCEDURE sp_premio_registrar(
    IN p_idTema INT, IN p_idNivel INT, IN p_nombre VARCHAR(80), IN p_descripcion VARCHAR(255),
    IN p_ruta VARCHAR(255), IN p_puntos INT, IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO premios (idTema, idNivel, dsNombre, dsDescripcion, dsRutaImagen, nuPuntos, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_idTema, p_idNivel, p_nombre, p_descripcion, p_ruta, p_puntos, p_creador, p_creador);
END$$

-- si p_ruta viene null deja la imagen como estaba
CREATE PROCEDURE sp_premio_actualizar(
    IN p_id INT, IN p_idTema INT, IN p_idNivel INT, IN p_nombre VARCHAR(80), IN p_descripcion VARCHAR(255),
    IN p_ruta VARCHAR(255), IN p_puntos INT, IN p_modificador VARCHAR(100))
BEGIN
    UPDATE premios
    SET idTema = p_idTema, idNivel = p_idNivel, dsNombre = p_nombre, dsDescripcion = p_descripcion,
        dsRutaImagen = IFNULL(p_ruta, dsRutaImagen), nuPuntos = p_puntos, dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END$$

CREATE PROCEDURE sp_premio_cambiar_estado(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE premios SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END$$

-- imagenes de resultado, se usa la de mayor porcentaje minimo que el jugador alcance
CREATE PROCEDURE sp_imgres_listar()
BEGIN
    SELECT id, nuPorcentajeMinimo, dsMensaje, dsRutaImagen, dsEstado FROM imagenes_resultado ORDER BY nuPorcentajeMinimo;
END$$

CREATE PROCEDURE sp_imgres_obtener(IN p_id INT)
BEGIN
    SELECT id, nuPorcentajeMinimo, dsMensaje, dsRutaImagen, dsEstado FROM imagenes_resultado WHERE id = p_id;
END$$

CREATE PROCEDURE sp_imgres_registrar(IN p_minimo INT, IN p_mensaje VARCHAR(120), IN p_ruta VARCHAR(255))
BEGIN
    INSERT INTO imagenes_resultado (nuPorcentajeMinimo, dsMensaje, dsRutaImagen) VALUES (p_minimo, p_mensaje, p_ruta);
END$$

CREATE PROCEDURE sp_imgres_actualizar(IN p_id INT, IN p_minimo INT, IN p_mensaje VARCHAR(120), IN p_ruta VARCHAR(255))
BEGIN
    UPDATE imagenes_resultado
    SET nuPorcentajeMinimo = p_minimo, dsMensaje = p_mensaje, dsRutaImagen = IFNULL(p_ruta, dsRutaImagen)
    WHERE id = p_id;
END$$

CREATE PROCEDURE sp_imgres_cambiar_estado(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE imagenes_resultado SET dsEstado = p_estado WHERE id = p_id;
END$$

DELIMITER ;

USE bd_trivias;

-- 3 preguntas mas por tema y nivel para que cada partida sea de 5
-- correrlo una sola vez o se duplican
SET @c = (SELECT id FROM temas WHERE dsNombre = 'C#');
SET @a = (SELECT id FROM temas WHERE dsNombre = 'ASP.NET');
SET @h = (SELECT id FROM temas WHERE dsNombre = 'HTML');
SET @b = (SELECT id FROM temas WHERE dsNombre = 'Bootstrap');
SET @p = (SELECT id FROM temas WHERE dsNombre = 'PHP');
SET @j = (SELECT id FROM temas WHERE dsNombre = 'JavaScript');
SET @l = (SELECT id FROM temas WHERE dsNombre = 'Laravel');
SET @n1 = (SELECT id FROM niveles WHERE nuOrden = 1);
SET @n2 = (SELECT id FROM niveles WHERE nuOrden = 2);
SET @n3 = (SELECT id FROM niveles WHERE nuOrden = 3);

-- c#
CALL sp_pregunta_registrar(@c, @n1, 'OPCION_MULTIPLE', '¿Qué tipo de dato se usa en C# para números enteros?', 10, 30, 'string', 'bool', 'int', 'char', 3, 'seed');
CALL sp_pregunta_registrar(@c, @n1, 'OPCION_MULTIPLE', '¿Qué instrucción muestra texto en una aplicación de consola?', 10, 30, 'Print.Line', 'Echo.Write', 'Console.WriteLine', 'Output.Text', 3, 'seed');
CALL sp_pregunta_registrar(@c, @n1, 'VERDADERO_FALSO', 'Una variable bool solo puede valer true o false.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@c, @n2, 'OPCION_MULTIPLE', '¿Qué colección guarda elementos asociados a una clave única?', 20, 30, 'List', 'Dictionary', 'Array', 'Queue', 2, 'seed');
CALL sp_pregunta_registrar(@c, @n2, 'OPCION_MULTIPLE', '¿Qué símbolo se usa en C# para heredar de una clase?', 20, 30, 'extends', 'Los dos puntos (:)', 'inherits', 'from', 2, 'seed');
CALL sp_pregunta_registrar(@c, @n2, 'VERDADERO_FALSO', 'Un método declarado como void devuelve un valor entero.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@c, @n3, 'OPCION_MULTIPLE', '¿Qué interfaz debe implementar una clase para poder recorrerse con foreach?', 30, 45, 'IComparable', 'IDisposable', 'IEnumerable', 'ICloneable', 3, 'seed');
CALL sp_pregunta_registrar(@c, @n3, 'OPCION_MULTIPLE', '¿Para qué sirve la palabra clave await?', 30, 45, 'Para esperar el resultado de una tarea asíncrona sin bloquear el hilo', 'Para detener el programa', 'Para crear un hilo nuevo siempre', 'Para declarar una constante', 1, 'seed');
CALL sp_pregunta_registrar(@c, @n3, 'VERDADERO_FALSO', 'LINQ permite consultar colecciones con una sintaxis integrada en C#.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- asp.net
CALL sp_pregunta_registrar(@a, @n1, 'OPCION_MULTIPLE', '¿Qué archivo guarda la configuración de una aplicación ASP.NET?', 10, 30, 'Web.config', 'Global.json', 'App.ini', 'Config.xml', 1, 'seed');
CALL sp_pregunta_registrar(@a, @n1, 'OPCION_MULTIPLE', '¿Qué control de Web Forms muestra una tabla de datos?', 10, 30, 'Label', 'Button', 'GridView', 'Literal', 3, 'seed');
CALL sp_pregunta_registrar(@a, @n1, 'VERDADERO_FALSO', 'Los controles de servidor de Web Forms llevan el atributo runat="server".', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@a, @n2, 'OPCION_MULTIPLE', '¿Qué propiedad indica si la página se está enviando de nuevo al servidor?', 20, 30, 'IsValid', 'IsPostBack', 'IsCallback', 'IsAsync', 2, 'seed');
CALL sp_pregunta_registrar(@a, @n2, 'OPCION_MULTIPLE', '¿Cómo se lee un parámetro de la URL, como ?id=5?', 20, 30, 'Response.Write', 'Session.Add', 'Request.QueryString', 'Server.MapPath', 3, 'seed');
CALL sp_pregunta_registrar(@a, @n2, 'VERDADERO_FALSO', 'Response.Redirect envía al usuario a otra página.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@a, @n3, 'OPCION_MULTIPLE', '¿Qué evento de Global.asax se usa para capturar errores no controlados de toda la aplicación?', 30, 45, 'Session_Start', 'Application_Error', 'Application_End', 'Page_Load', 2, 'seed');
CALL sp_pregunta_registrar(@a, @n3, 'OPCION_MULTIPLE', '¿Qué método sirve para codificar texto y evitar ataques XSS al mostrarlo?', 30, 45, 'Server.HtmlEncode', 'Response.Clear', 'Request.Form', 'Session.Abandon', 1, 'seed');
CALL sp_pregunta_registrar(@a, @n3, 'VERDADERO_FALSO', 'Una Master Page puede contener controles ContentPlaceHolder.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- html
CALL sp_pregunta_registrar(@h, @n1, 'OPCION_MULTIPLE', '¿Qué etiqueta crea un párrafo?', 10, 30, '<para>', '<p>', '<text>', '<pg>', 2, 'seed');
CALL sp_pregunta_registrar(@h, @n1, 'OPCION_MULTIPLE', '¿Qué etiqueta define el título que aparece en la pestaña del navegador?', 10, 30, '<h1>', '<head>', '<title>', '<header>', 3, 'seed');
CALL sp_pregunta_registrar(@h, @n1, 'VERDADERO_FALSO', 'La etiqueta <h1> representa el encabezado de mayor importancia.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@h, @n2, 'OPCION_MULTIPLE', '¿Qué etiqueta crea un campo de entrada en un formulario?', 20, 30, '<input>', '<field>', '<entry>', '<textbox>', 1, 'seed');
CALL sp_pregunta_registrar(@h, @n2, 'OPCION_MULTIPLE', '¿Qué atributo indica a dónde apunta un enlace?', 20, 30, 'src', 'link', 'href', 'target', 3, 'seed');
CALL sp_pregunta_registrar(@h, @n2, 'VERDADERO_FALSO', 'Un <div> es un elemento en línea por defecto.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@h, @n3, 'OPCION_MULTIPLE', '¿Qué atributo hace obligatorio un campo de formulario?', 30, 45, 'mandatory', 'required', 'needed', 'must', 2, 'seed');
CALL sp_pregunta_registrar(@h, @n3, 'OPCION_MULTIPLE', '¿Qué etiqueta de HTML5 incrusta un video?', 30, 45, '<media>', '<movie>', '<clip>', '<video>', 4, 'seed');
CALL sp_pregunta_registrar(@h, @n3, 'VERDADERO_FALSO', 'El atributo lang de <html> ayuda a los lectores de pantalla a elegir el idioma.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- bootstrap
CALL sp_pregunta_registrar(@b, @n1, 'OPCION_MULTIPLE', '¿Qué clase de Bootstrap crea un contenedor centrado con ancho máximo?', 10, 30, 'container', 'box', 'wrapper', 'centered', 1, 'seed');
CALL sp_pregunta_registrar(@b, @n1, 'OPCION_MULTIPLE', '¿Qué clase muestra un mensaje de alerta en Bootstrap?', 10, 30, 'message', 'notice', 'alert', 'warning-box', 3, 'seed');
CALL sp_pregunta_registrar(@b, @n1, 'VERDADERO_FALSO', 'Bootstrap incluye componentes listos como botones y tarjetas.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@b, @n2, 'OPCION_MULTIPLE', '¿Qué clase pone un margen inferior de tamaño 3?', 20, 30, 'mb-3', 'margin-bottom-3', 'm-bottom-3', 'mbt-3', 1, 'seed');
CALL sp_pregunta_registrar(@b, @n2, 'OPCION_MULTIPLE', '¿Qué clase crea una fila en el sistema de rejilla?', 20, 30, 'line', 'row', 'grid-row', 'tr', 2, 'seed');
CALL sp_pregunta_registrar(@b, @n2, 'VERDADERO_FALSO', 'La clase text-center alinea el texto a la derecha.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@b, @n3, 'OPCION_MULTIPLE', '¿Qué atributo data de Bootstrap 5 abre un modal desde un botón?', 30, 45, 'data-toggle="modal"', 'data-open="modal"', 'data-bs-toggle="modal"', 'data-modal="open"', 3, 'seed');
CALL sp_pregunta_registrar(@b, @n3, 'OPCION_MULTIPLE', '¿Qué clase de utilidad convierte un elemento en contenedor flexible?', 30, 45, 'flex-box', 'd-flex', 'display-flex', 'flexible', 2, 'seed');
CALL sp_pregunta_registrar(@b, @n3, 'VERDADERO_FALSO', 'La clase col-12 ocupa las 12 columnas de la rejilla.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- php
CALL sp_pregunta_registrar(@p, @n1, 'OPCION_MULTIPLE', '¿Con qué etiqueta empieza un bloque de código PHP?', 10, 30, '<?php', '<php>', '<%', '<script php>', 1, 'seed');
CALL sp_pregunta_registrar(@p, @n1, 'OPCION_MULTIPLE', '¿Qué extensión suelen tener los archivos PHP?', 10, 30, '.pph', '.ph', '.php', '.pp', 3, 'seed');
CALL sp_pregunta_registrar(@p, @n1, 'VERDADERO_FALSO', 'En PHP cada instrucción termina con punto y coma.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@p, @n2, 'OPCION_MULTIPLE', '¿Qué función devuelve la cantidad de elementos de un arreglo?', 20, 30, 'size()', 'count()', 'length()', 'total()', 2, 'seed');
CALL sp_pregunta_registrar(@p, @n2, 'OPCION_MULTIPLE', '¿Qué instrucción incluye otro archivo y detiene el script si no existe?', 20, 30, 'import', 'using', 'require', 'load', 3, 'seed');
CALL sp_pregunta_registrar(@p, @n2, 'VERDADERO_FALSO', 'En PHP los nombres de variable distinguen entre mayúsculas y minúsculas.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@p, @n3, 'OPCION_MULTIPLE', '¿Qué extensión de PHP permite consultas preparadas con varios motores de base de datos?', 30, 45, 'PDO', 'CURL', 'GD', 'SPL', 1, 'seed');
CALL sp_pregunta_registrar(@p, @n3, 'OPCION_MULTIPLE', '¿Qué función convierte caracteres especiales a entidades HTML?', 30, 45, 'strip_tags', 'htmlspecialchars', 'addslashes', 'trim', 2, 'seed');
CALL sp_pregunta_registrar(@p, @n3, 'VERDADERO_FALSO', 'Para usar $_SESSION hay que llamar antes a session_start().', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

-- javascript
CALL sp_pregunta_registrar(@j, @n1, 'OPCION_MULTIPLE', '¿Qué etiqueta HTML se usa para incluir JavaScript?', 10, 30, '<js>', '<code>', '<script>', '<javascript>', 3, 'seed');
CALL sp_pregunta_registrar(@j, @n1, 'OPCION_MULTIPLE', '¿Qué instrucción muestra un mensaje en la consola del navegador?', 10, 30, 'console.log()', 'print()', 'echo()', 'System.out.println()', 1, 'seed');
CALL sp_pregunta_registrar(@j, @n1, 'VERDADERO_FALSO', 'JavaScript se puede ejecutar dentro del navegador.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@j, @n2, 'OPCION_MULTIPLE', '¿Qué método crea un arreglo nuevo aplicando una función a cada elemento?', 20, 30, 'filter', 'map', 'push', 'join', 2, 'seed');
CALL sp_pregunta_registrar(@j, @n2, 'OPCION_MULTIPLE', '¿Qué método busca un elemento del documento por su id?', 20, 30, 'getElementById', 'findId', 'queryId', 'selectById', 1, 'seed');
CALL sp_pregunta_registrar(@j, @n2, 'VERDADERO_FALSO', 'Un arreglo de JavaScript tiene un tamaño fijo que no se puede cambiar.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');
CALL sp_pregunta_registrar(@j, @n3, 'OPCION_MULTIPLE', '¿Qué hace JSON.parse()?', 30, 45, 'Convierte un objeto en texto', 'Convierte texto JSON en un objeto', 'Borra un objeto', 'Ordena un arreglo', 2, 'seed');
CALL sp_pregunta_registrar(@j, @n3, 'OPCION_MULTIPLE', '¿Qué método de una Promise captura un error?', 30, 45, 'then', 'finally', 'catch', 'error', 3, 'seed');
CALL sp_pregunta_registrar(@j, @n3, 'VERDADERO_FALSO', 'Las funciones flecha tienen su propio this.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 2, 'seed');

-- laravel
CALL sp_pregunta_registrar(@l, @n1, 'OPCION_MULTIPLE', '¿Qué herramienta se usa para instalar Laravel y sus dependencias?', 10, 30, 'Composer', 'npm', 'Maven', 'pip', 1, 'seed');
CALL sp_pregunta_registrar(@l, @n1, 'OPCION_MULTIPLE', '¿Qué archivo guarda la configuración del entorno, como los datos de la base de datos?', 10, 30, 'config.txt', '.env', 'settings.ini', 'app.json', 2, 'seed');
CALL sp_pregunta_registrar(@l, @n1, 'VERDADERO_FALSO', 'Laravel sigue el patrón MVC.', 10, 20, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@l, @n2, 'OPCION_MULTIPLE', '¿En qué carpeta se guardan las vistas Blade?', 20, 30, 'resources/views', 'app/pages', 'public/views', 'storage/blade', 1, 'seed');
CALL sp_pregunta_registrar(@l, @n2, 'OPCION_MULTIPLE', '¿Qué archivo define las rutas web de la aplicación?', 20, 30, 'routes/web.php', 'app/routes.php', 'config/web.php', 'public/routes.php', 1, 'seed');
CALL sp_pregunta_registrar(@l, @n2, 'VERDADERO_FALSO', 'Un middleware puede revisar la petición antes de que llegue al controlador.', 20, 25, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');
CALL sp_pregunta_registrar(@l, @n3, 'OPCION_MULTIPLE', '¿Qué comando ejecuta las migraciones pendientes?', 30, 45, 'php artisan run', 'php artisan db:go', 'php artisan migrate', 'composer migrate', 3, 'seed');
CALL sp_pregunta_registrar(@l, @n3, 'OPCION_MULTIPLE', '¿Qué directiva de Blade protege un formulario contra ataques CSRF?', 30, 45, '@secure', '@token', '@csrf', '@guard', 3, 'seed');
CALL sp_pregunta_registrar(@l, @n3, 'VERDADERO_FALSO', 'Las policies de Laravel sirven para definir permisos sobre modelos.', 30, 30, 'Verdadero', 'Falso', NULL, NULL, 1, 'seed');

USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_noticia_listar;
DROP PROCEDURE IF EXISTS sp_noticia_publicas;
DROP PROCEDURE IF EXISTS sp_noticia_obtener;
DROP PROCEDURE IF EXISTS sp_noticia_registrar;
DROP PROCEDURE IF EXISTS sp_noticia_actualizar;
DROP PROCEDURE IF EXISTS sp_noticia_cambiar_estado;
DROP PROCEDURE IF EXISTS sp_calif_guardar;
DROP PROCEDURE IF EXISTS sp_calif_obtener;
DROP PROCEDURE IF EXISTS sp_calif_resumen;
DROP PROCEDURE IF EXISTS sp_calif_listar;

DELIMITER $$

-- noticias, el admin ve todas y la pagina publica solo las activas
CREATE PROCEDURE sp_noticia_listar()
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado
    FROM noticias ORDER BY dtPublicacion DESC, id DESC;
END$$

CREATE PROCEDURE sp_noticia_publicas(IN p_cantidad INT)
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado
    FROM noticias WHERE dsEstado = '1'
    ORDER BY dtPublicacion DESC, id DESC
    LIMIT p_cantidad;
END$$

CREATE PROCEDURE sp_noticia_obtener(IN p_id INT)
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado FROM noticias WHERE id = p_id;
END$$

CREATE PROCEDURE sp_noticia_registrar(
    IN p_titulo VARCHAR(150), IN p_resumen VARCHAR(300), IN p_contenido TEXT, IN p_ruta VARCHAR(255), IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO noticias (dsTitulo, dsResumen, dsContenido, dsRutaImagen, dsUsuarioCreacion)
    VALUES (p_titulo, p_resumen, p_contenido, p_ruta, p_creador);
END$$

-- si p_ruta viene null deja la imagen como estaba
CREATE PROCEDURE sp_noticia_actualizar(
    IN p_id INT, IN p_titulo VARCHAR(150), IN p_resumen VARCHAR(300), IN p_contenido TEXT, IN p_ruta VARCHAR(255))
BEGIN
    UPDATE noticias
    SET dsTitulo = p_titulo, dsResumen = p_resumen, dsContenido = p_contenido, dsRutaImagen = IFNULL(p_ruta, dsRutaImagen)
    WHERE id = p_id;
END$$

CREATE PROCEDURE sp_noticia_cambiar_estado(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE noticias SET dsEstado = p_estado WHERE id = p_id;
END$$

-- una calificacion por usuario y tema, si ya existe se actualiza
-- solo califica quien ya jugo ese tema
CREATE PROCEDURE sp_calif_guardar(
    IN p_idUsuario INT, IN p_idTema INT, IN p_califTema INT, IN p_califApp INT,
    IN p_sugerido VARCHAR(200), IN p_comentario VARCHAR(500))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM temas WHERE id = p_idTema AND dsEstado = '1') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tema no valido';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM partidas WHERE idUsuario = p_idUsuario AND idTema = p_idTema AND dtFin IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debes jugar el tema antes de calificarlo';
    END IF;

    IF EXISTS (SELECT 1 FROM calificaciones WHERE idUsuario = p_idUsuario AND idTema = p_idTema) THEN
        UPDATE calificaciones
        SET nuCalifTema = p_califTema, nuCalifApp = p_califApp, dsTemaSugerido = p_sugerido, dsComentario = p_comentario, dtFecha = NOW()
        WHERE idUsuario = p_idUsuario AND idTema = p_idTema;
    ELSE
        INSERT INTO calificaciones (idUsuario, idTema, nuCalifTema, nuCalifApp, dsTemaSugerido, dsComentario)
        VALUES (p_idUsuario, p_idTema, p_califTema, p_califApp, p_sugerido, p_comentario);
    END IF;
END$$

-- para rellenar el formulario si ya habia calificado
CREATE PROCEDURE sp_calif_obtener(IN p_idUsuario INT, IN p_idTema INT)
BEGIN
    SELECT c.id, c.idUsuario, c.idTema, t.dsNombre AS dsNombreTema, c.nuCalifTema, c.nuCalifApp, c.dsTemaSugerido, c.dsComentario, c.dtFecha
    FROM calificaciones c INNER JOIN temas t ON t.id = c.idTema
    WHERE c.idUsuario = p_idUsuario AND c.idTema = p_idTema;
END$$

-- promedios por tema para el administrador
CREATE PROCEDURE sp_calif_resumen()
BEGIN
    SELECT t.id AS idTema, t.dsNombre AS dsNombreTema, COUNT(c.id) AS nuCalificaciones,
           IFNULL(ROUND(AVG(c.nuCalifTema), 2), 0) AS nuPromedioTema,
           IFNULL(ROUND(AVG(c.nuCalifApp), 2), 0) AS nuPromedioApp
    FROM temas t LEFT JOIN calificaciones c ON c.idTema = t.id
    GROUP BY t.id, t.dsNombre
    ORDER BY t.dsNombre;
END$$

CREATE PROCEDURE sp_calif_listar()
BEGIN
    SELECT c.id, c.idUsuario, u.dsNombre AS dsNombreUsuario, c.idTema, t.dsNombre AS dsNombreTema,
           c.nuCalifTema, c.nuCalifApp, c.dsTemaSugerido, c.dsComentario, c.dtFecha
    FROM calificaciones c
    INNER JOIN usuarios u ON u.id = c.idUsuario
    INNER JOIN temas t ON t.id = c.idTema
    ORDER BY c.dtFecha DESC
    LIMIT 300;
END$$

DELIMITER ;

-- noticias de ejemplo para la pagina publica, correr una sola vez
INSERT INTO noticias (dsTitulo, dsResumen, dsContenido, dtPublicacion, dsUsuarioCreacion) VALUES
('Las trivias como herramienta de capacitación',
 'Aprender jugando mejora la retención del conocimiento y mantiene motivados a los equipos.',
 'Las trivias convierten el repaso en un juego con metas claras. Cada nivel superado da una recompensa inmediata y eso motiva a seguir practicando. Para las capacitaciones internas permiten medir qué temas ya se dominan y cuáles necesitan refuerzo, sin la presión de un examen formal.',
 NOW() - INTERVAL 1 DAY, 'Sistema'),
('Niveles y premios: cómo funciona el progreso',
 'Cada tema tiene tres niveles y el siguiente solo se abre cuando apruebas el anterior.',
 'Empiezas en Novato, pasas a Principiante y llegas a Experto. Para avanzar necesitas alcanzar el porcentaje de aprobación del nivel. Al aprobar por primera vez ganas un premio con puntos extra que se suman a tu posición en el ranking.',
 NOW() - INTERVAL 3 DAY, 'Sistema'),
('Siete temas de programación para practicar',
 'C#, ASP.NET, HTML, Bootstrap, PHP, JavaScript y Laravel ya están disponibles.',
 'El banco de preguntas cubre desde lo básico hasta conceptos avanzados de cada tecnología. Tu opinión cuenta: después de jugar puedes calificar cada tema y sugerir los que te gustaría ver en la próxima versión.',
 NOW() - INTERVAL 5 DAY, 'Sistema'),
('Compite con tus compañeros en el ranking',
 'Mira tu posición por tema o en total y compara tu avance con el de otros jugadores.',
 'El ranking suma los puntos de tu mejor partida en cada nivel más los premios ganados. Puedes filtrarlo por tema para ver quién domina cada tecnología.',
 NOW() - INTERVAL 7 DAY, 'Sistema');
 
 USE bd_trivias;

DROP PROCEDURE IF EXISTS sp_setqr_listar;
DROP PROCEDURE IF EXISTS sp_setqr_obtener;
DROP PROCEDURE IF EXISTS sp_setqr_por_codigo;
DROP PROCEDURE IF EXISTS sp_setqr_registrar;
DROP PROCEDURE IF EXISTS sp_setqr_actualizar;
DROP PROCEDURE IF EXISTS sp_setqr_cambiar_estado;
DROP PROCEDURE IF EXISTS sp_setqr_asignar_partida;
DROP PROCEDURE IF EXISTS sp_reporte_resumen;
DROP PROCEDURE IF EXISTS sp_reporte_distribucion;
DROP PROCEDURE IF EXISTS sp_reporte_avance;

DELIMITER $$

-- sets de preguntas que se abren con un qr
CREATE PROCEDURE sp_setqr_listar()
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    ORDER BY s.dtFechaCreacion DESC, s.id DESC;
END$$

CREATE PROCEDURE sp_setqr_obtener(IN p_id INT)
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    WHERE s.id = p_id;
END$$

CREATE PROCEDURE sp_setqr_por_codigo(IN p_codigo VARCHAR(36))
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    WHERE s.dsCodigo = p_codigo;
END$$

CREATE PROCEDURE sp_setqr_registrar(
    IN p_codigo VARCHAR(36), IN p_nombre VARCHAR(100), IN p_idTema INT, IN p_idNivel INT, IN p_cantidad INT, IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO sets_qr (dsCodigo, dsNombre, idTema, idNivel, nuCantidadPreguntas, dsUsuarioCreacion)
    VALUES (p_codigo, p_nombre, p_idTema, p_idNivel, p_cantidad, p_creador);
END$$

-- el codigo no se cambia para que el qr ya impreso siga sirviendo
CREATE PROCEDURE sp_setqr_actualizar(
    IN p_id INT, IN p_nombre VARCHAR(100), IN p_idTema INT, IN p_idNivel INT, IN p_cantidad INT)
BEGIN
    UPDATE sets_qr SET dsNombre = p_nombre, idTema = p_idTema, idNivel = p_idNivel, nuCantidadPreguntas = p_cantidad WHERE id = p_id;
END$$

CREATE PROCEDURE sp_setqr_cambiar_estado(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE sets_qr SET dsEstado = p_estado WHERE id = p_id;
END$$

-- marca la partida como jugada por qr, solo si es del usuario y todavia esta abierta
CREATE PROCEDURE sp_setqr_asignar_partida(IN p_idPartida INT, IN p_idUsuario INT, IN p_idSetQr INT)
BEGIN
    UPDATE partidas SET idSetQr = p_idSetQr
    WHERE id = p_idPartida AND idUsuario = p_idUsuario AND idSetQr IS NULL AND dtFin IS NULL;
END$$

-- cifras generales del reporte
CREATE PROCEDURE sp_reporte_resumen()
BEGIN
    DECLARE v_tema VARCHAR(100) DEFAULT NULL;
    DECLARE v_cant INT DEFAULT 0;
    SELECT t.dsNombre, COUNT(*) INTO v_tema, v_cant
    FROM partidas p INNER JOIN temas t ON t.id = p.idTema
    WHERE p.dtFin IS NOT NULL
    GROUP BY t.id, t.dsNombre
    ORDER BY COUNT(*) DESC, t.dsNombre
    LIMIT 1;

    SELECT (SELECT COUNT(*) FROM usuarios WHERE dsRol = 'JUGADOR' AND dsEstado = '1') AS nuJugadoresRegistrados,
           (SELECT COUNT(DISTINCT idUsuario) FROM partidas WHERE dtFin IS NOT NULL) AS nuJugadoresActivos,
           (SELECT COUNT(*) FROM usuarios u WHERE u.dsRol = 'JUGADOR' AND u.dsEstado = '1'
              AND NOT EXISTS (SELECT 1 FROM partidas p WHERE p.idUsuario = u.id AND p.dtFin IS NOT NULL)) AS nuJugadoresSinJugar,
           (SELECT COUNT(*) FROM partidas WHERE dtFin IS NOT NULL) AS nuPartidas,
           (SELECT COUNT(*) FROM partidas WHERE dtFin IS NOT NULL AND idSetQr IS NOT NULL) AS nuPartidasQr,
           IFNULL((SELECT ROUND(AVG(nuPuntos), 2) FROM partidas WHERE dtFin IS NOT NULL), 0) AS nuPromedioPuntos,
           v_tema AS dsTemaPopular,
           v_cant AS nuPartidasTemaPopular,
           IFNULL((SELECT ROUND(AVG(r.nuSegundos), 2) FROM respuestas r INNER JOIN partidas p ON p.id = r.idPartida WHERE p.dtFin IS NOT NULL), 0) AS nuSegPromRespuesta;
END$$

-- cuantos jugadores hay en cada nivel, el nivel de cada uno es el mas alto en el que ha jugado
CREATE PROCEDURE sp_reporte_distribucion()
BEGIN
    SELECT n.id AS idNivel, n.dsNombre, n.nuOrden, COUNT(m.idUsuario) AS nuJugadores
    FROM niveles n
    LEFT JOIN (SELECT p.idUsuario, MAX(nv.nuOrden) AS ord
               FROM partidas p INNER JOIN niveles nv ON nv.id = p.idNivel
               WHERE p.dtFin IS NOT NULL
               GROUP BY p.idUsuario) m ON m.ord = n.nuOrden
    GROUP BY n.id, n.dsNombre, n.nuOrden
    ORDER BY n.nuOrden;
END$$

-- una fila por jugador y tema con su avance y sus tiempos
CREATE PROCEDURE sp_reporte_avance()
BEGIN
    SELECT u.id AS idUsuario, u.dsNombre, u.dsCorreo, t.id AS idTema, t.dsNombre AS dsNombreTema,
           pt.nuPartidas,
           (SELECT COUNT(DISTINCT pa.idNivel) FROM partidas pa WHERE pa.idUsuario = u.id AND pa.idTema = t.id AND pa.nuAprobado = 1) AS nuNivelesAprobados,
           (SELECT COUNT(*) FROM niveles) AS nuTotalNiveles,
           (SELECT nv.dsNombre FROM partidas pb INNER JOIN niveles nv ON nv.id = pb.idNivel
             WHERE pb.idUsuario = u.id AND pb.idTema = t.id AND pb.dtFin IS NOT NULL
             ORDER BY nv.nuOrden DESC LIMIT 1) AS dsNivelMaximo,
           IFNULL(pp.puntos, 0) + IFNULL(pr.puntos, 0) AS nuPuntos,
           IFNULL(ROUND(rs.seg, 2), 0) AS nuSegPromRespuesta,
           pt.segundos AS nuSegTotal,
           ROUND(g.gap, 0) AS nuSegEntreNiveles
    FROM (SELECT DISTINCT idUsuario, idTema FROM partidas WHERE dtFin IS NOT NULL) x
    INNER JOIN usuarios u ON u.id = x.idUsuario
    INNER JOIN temas t ON t.id = x.idTema
    INNER JOIN (SELECT idUsuario, idTema, COUNT(*) AS nuPartidas, SUM(nuSegundosTotal) AS segundos
                FROM partidas WHERE dtFin IS NOT NULL GROUP BY idUsuario, idTema) pt ON pt.idUsuario = u.id AND pt.idTema = t.id
    LEFT JOIN (SELECT idUsuario, idTema, SUM(mejor) AS puntos
               FROM (SELECT idUsuario, idTema, idNivel, MAX(nuPuntos) AS mejor FROM partidas WHERE dtFin IS NOT NULL GROUP BY idUsuario, idTema, idNivel) m
               GROUP BY idUsuario, idTema) pp ON pp.idUsuario = u.id AND pp.idTema = t.id
    LEFT JOIN (SELECT up.idUsuario, p.idTema, SUM(p.nuPuntos) AS puntos
               FROM usuario_premios up INNER JOIN premios p ON p.id = up.idPremio
               GROUP BY up.idUsuario, p.idTema) pr ON pr.idUsuario = u.id AND pr.idTema = t.id
    LEFT JOIN (SELECT pa.idUsuario, pa.idTema, AVG(r.nuSegundos) AS seg
               FROM respuestas r INNER JOIN partidas pa ON pa.id = r.idPartida
               WHERE pa.dtFin IS NOT NULL GROUP BY pa.idUsuario, pa.idTema) rs ON rs.idUsuario = u.id AND rs.idTema = t.id
    LEFT JOIN (SELECT a.idUsuario, a.idTema, AVG(TIMESTAMPDIFF(SECOND, a.fin, b.inicio)) AS gap
               FROM (SELECT p.idUsuario, p.idTema, n.nuOrden, MIN(p.dtFin) AS fin
                     FROM partidas p INNER JOIN niveles n ON n.id = p.idNivel
                     WHERE p.nuAprobado = 1 GROUP BY p.idUsuario, p.idTema, n.nuOrden) a
               INNER JOIN (SELECT p.idUsuario, p.idTema, n.nuOrden, MIN(p.dtInicio) AS inicio
                           FROM partidas p INNER JOIN niveles n ON n.id = p.idNivel
                           GROUP BY p.idUsuario, p.idTema, n.nuOrden) b
                       ON b.idUsuario = a.idUsuario AND b.idTema = a.idTema AND b.nuOrden = a.nuOrden + 1
               WHERE b.inicio >= a.fin
               GROUP BY a.idUsuario, a.idTema) g ON g.idUsuario = u.id AND g.idTema = t.id
    ORDER BY u.dsNombre, t.dsNombre;
END$$

DELIMITER ;

USE bd_trivias;

-- borra lo que se genero jugando y probando, no toca temas preguntas premios niveles ni noticias
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE respuestas;
TRUNCATE TABLE usuario_premios;
TRUNCATE TABLE calificaciones;
TRUNCATE TABLE partidas;
TRUNCATE TABLE log_errores;
SET FOREIGN_KEY_CHECKS = 1;

SELECT (SELECT COUNT(*) FROM partidas) AS partidas, (SELECT COUNT(*) FROM respuestas) AS respuestas,
       (SELECT COUNT(*) FROM usuarios) AS usuarios, (SELECT COUNT(*) FROM preguntas) AS preguntas, (SELECT COUNT(*) FROM temas) AS temas;