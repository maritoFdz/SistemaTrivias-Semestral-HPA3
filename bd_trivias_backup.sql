CREATE DATABASE  IF NOT EXISTS `bd_trivias` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bd_trivias`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: bd_trivias
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE USER IF NOT EXISTS 'app_trivias'@'localhost' IDENTIFIED BY 'ClaveSegura#2026';
GRANT EXECUTE ON bd_trivias.* TO 'app_trivias'@'localhost';

--
-- Table structure for table `avatares`
--

DROP TABLE IF EXISTS `avatares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avatares` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `dsNombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsRutaImagen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsUsuarioModificacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaModificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_avatares_idUsuario` (`idUsuario`),
  CONSTRAINT `fk_avatares_usuarios` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `ck_avatares_dsEstado` CHECK ((`dsEstado` in (_utf8mb4'0',_utf8mb4'1')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avatares`
--

LOCK TABLES `avatares` WRITE;
/*!40000 ALTER TABLE `avatares` DISABLE KEYS */;
INSERT INTO `avatares` VALUES (1,1,'PunPun','~/Uploads/avatares/51ef366036454969a80cc00acf2c315c.jpg','1','admin@trivias.local','2026-11-22 18:50:44','admin@trivias.local','2026-11-22 18:54:45'),(2,2,'Gato','~/Uploads/avatares/781da3e6fae0459296b5b6330d1abe26.jpg','1','irinafong@gmail.com','2026-11-22 18:54:21','admin@trivias.local','2026-11-22 18:55:21'),(3,5,'Ranaoruga','~/Uploads/avatares/44409b0036614358b6bb67d0ae10adbc.jpg','1','mario.fernandez@utp.ac.pa','2026-11-22 23:49:53','mario.fernandez@utp.ac.pa','2026-11-22 23:49:53');
/*!40000 ALTER TABLE `avatares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idTema` int NOT NULL,
  `nuCalifTema` tinyint NOT NULL,
  `nuCalifApp` tinyint NOT NULL,
  `dsTemaSugerido` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsComentario` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dtFecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_calif_usuarios` (`idUsuario`),
  KEY `fk_calif_temas` (`idTema`),
  CONSTRAINT `fk_calif_temas` FOREIGN KEY (`idTema`) REFERENCES `temas` (`id`),
  CONSTRAINT `fk_calif_usuarios` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `ck_calif_app` CHECK ((`nuCalifApp` between 1 and 4)),
  CONSTRAINT `ck_calif_tema` CHECK ((`nuCalifTema` between 1 and 4))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificaciones`
--

LOCK TABLES `calificaciones` WRITE;
/*!40000 ALTER TABLE `calificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `calificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagenes_resultado`
--

DROP TABLE IF EXISTS `imagenes_resultado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagenes_resultado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nuPorcentajeMinimo` tinyint NOT NULL,
  `dsMensaje` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsRutaImagen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_imagenes_resultado_pct` (`nuPorcentajeMinimo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagenes_resultado`
--

LOCK TABLES `imagenes_resultado` WRITE;
/*!40000 ALTER TABLE `imagenes_resultado` DISABLE KEYS */;
INSERT INTO `imagenes_resultado` VALUES (1,0,'¡No te desanimes!','~/Uploads/resultados/1f0b8ffd29d446d0bef5cbab5114d9d2.gif','1'),(2,100,'¡Todo un experto!','~/Uploads/resultados/b799914279b34dd88fb312c9fe2e895c.gif','1'),(4,40,'¡Debes estudiar más!','~/Uploads/resultados/78d627c995ab44ad8d0776f959ea3575.gif','1'),(5,60,'¡Casi lo logras!','~/Uploads/resultados/7279c6f2e5774186883092ff621dc93d.gif','1'),(6,80,'¡Genial!','~/Uploads/resultados/e21151d99ffd45a8862b80a69b6b1d93.gif','1');
/*!40000 ALTER TABLE `imagenes_resultado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_errores`
--

DROP TABLE IF EXISTS `log_errores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_errores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dtFecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsOrigen` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsMensaje` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsDetalle` text COLLATE utf8mb4_unicode_ci,
  `dsUsuario` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'anonimo',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_errores`
--

LOCK TABLES `log_errores` WRITE;
/*!40000 ALTER TABLE `log_errores` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_errores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `niveles`
--

DROP TABLE IF EXISTS `niveles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `niveles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dsNombre` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nuOrden` tinyint NOT NULL,
  `nuPorcentajeAprobacion` tinyint NOT NULL DEFAULT '70',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_niveles_dsNombre` (`dsNombre`),
  UNIQUE KEY `uq_niveles_nuOrden` (`nuOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles`
--

LOCK TABLES `niveles` WRITE;
/*!40000 ALTER TABLE `niveles` DISABLE KEYS */;
INSERT INTO `niveles` VALUES (1,'Novato',1,70),(2,'Principiante',2,70),(3,'Experto',3,70);
/*!40000 ALTER TABLE `niveles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `noticias`
--

DROP TABLE IF EXISTS `noticias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `noticias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dsTitulo` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsResumen` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsContenido` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsRutaImagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dtPublicacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `noticias`
--

LOCK TABLES `noticias` WRITE;
/*!40000 ALTER TABLE `noticias` DISABLE KEYS */;
INSERT INTO `noticias` VALUES (1,'Las trivias como herramienta de capacitación','Aprender jugando mejora la retención del conocimiento y mantiene motivados a los equipos.','Las trivias convierten el repaso en un juego con metas claras. Cada nivel superado da una recompensa inmediata y eso motiva a seguir practicando. Para las capacitaciones internas permiten medir qué temas ya se dominan y cuáles necesitan refuerzo, sin la presión de un examen formal.',NULL,'2026-11-21 22:53:29','1','Sistema','2026-11-22 22:53:29'),(2,'Niveles y premios: cómo funciona el progreso','Cada tema tiene tres niveles y el siguiente solo se abre cuando apruebas el anterior.','Empiezas en Novato, pasas a Principiante y llegas a Experto. Para avanzar necesitas alcanzar el porcentaje de aprobación del nivel. Al aprobar por primera vez ganas un premio con puntos extra que se suman a tu posición en el ranking.',NULL,'2026-11-19 22:53:29','1','Sistema','2026-11-22 22:53:29'),(3,'Siete temas de programación para practicar','C#, ASP.NET, HTML, Bootstrap, PHP, JavaScript y Laravel ya están disponibles.','El banco de preguntas cubre desde lo básico hasta conceptos avanzados de cada tecnología. Tu opinión cuenta: después de jugar puedes calificar cada tema y sugerir los que te gustaría ver en la próxima versión.',NULL,'2026-11-17 22:53:29','1','Sistema','2026-11-22 22:53:29'),(4,'Compite con tus compañeros en el ranking','Mira tu posición por tema o en total y compara tu avance con el de otros jugadores.','El ranking suma los puntos de tu mejor partida en cada nivel más los premios ganados. Puedes filtrarlo por tema para ver quién domina cada tecnología.',NULL,'2026-11-15 22:53:29','1','Sistema','2026-11-22 22:53:29'),(5,'Las trivias te vuelven mejor en las discusiones con tu pareja','Como lo oyes','No hay pruebas pero bueno','~/Uploads/noticias/3edefa89de884f4b83fc8d745d53e682.jpg','2026-11-22 23:19:44','0','admin@trivias.local','2026-11-22 23:19:44');
/*!40000 ALTER TABLE `noticias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opciones`
--

DROP TABLE IF EXISTS `opciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idPregunta` int NOT NULL,
  `dsTexto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nuEsCorrecta` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_opciones_idPregunta` (`idPregunta`),
  CONSTRAINT `fk_opciones_preguntas` FOREIGN KEY (`idPregunta`) REFERENCES `preguntas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=343 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opciones`
--

LOCK TABLES `opciones` WRITE;
/*!40000 ALTER TABLE `opciones` DISABLE KEYS */;
INSERT INTO `opciones` VALUES (1,1,'No',0),(2,1,'Si',0),(3,1,'Depende',0),(4,1,'Claro',1),(5,2,'Verdadero',1),(6,2,'Falso',0),(7,3,'final',0),(8,3,'const',1),(9,3,'static',0),(10,3,'readonly var',0),(11,4,'Verdadero',1),(12,4,'Falso',0),(13,5,'while',0),(14,5,'switch',0),(15,5,'foreach',1),(16,5,'goto',0),(17,6,'Verdadero',0),(18,6,'Falso',1),(19,7,'lock',0),(20,7,'ref',0),(21,7,'out',0),(22,7,'using',1),(23,8,'Verdadero',0),(24,8,'Falso',1),(25,9,'.cshtml',0),(26,9,'.php',0),(27,9,'.aspx',1),(28,9,'.html',0),(29,10,'Verdadero',1),(30,10,'Falso',0),(31,11,'Session',1),(32,11,'Request',0),(33,11,'Response',0),(34,11,'Server',0),(35,12,'Verdadero',1),(36,12,'Falso',0),(37,13,'Page_Load',0),(38,13,'Page_Init',1),(39,13,'Page_PreRender',0),(40,13,'Page_Unload',0),(41,14,'Verdadero',0),(42,14,'Falso',1),(43,15,'<link>',0),(44,15,'<href>',0),(45,15,'<url>',0),(46,15,'<a>',1),(47,16,'Verdadero',0),(48,16,'Falso',1),(49,17,'title',0),(50,17,'alt',1),(51,17,'src',0),(52,17,'name',0),(53,18,'Verdadero',0),(54,18,'Falso',1),(55,19,'<div>',0),(56,19,'<section>',0),(57,19,'<main>',1),(58,19,'<span>',0),(59,20,'Verdadero',1),(60,20,'Falso',0),(61,21,'btn btn-primary',1),(62,21,'button blue',0),(63,21,'btn-blue',0),(64,21,'primary-button',0),(65,22,'Verdadero',1),(66,22,'Falso',0),(67,23,'6',0),(68,23,'10',0),(69,23,'16',0),(70,23,'12',1),(71,24,'Verdadero',1),(72,24,'Falso',0),(73,25,'xs',0),(74,25,'md',1),(75,25,'mid',0),(76,25,'big',0),(77,26,'Verdadero',0),(78,26,'Falso',1),(79,27,'@',0),(80,27,'#',0),(81,27,'$',1),(82,27,'&',0),(83,28,'Verdadero',1),(84,28,'Falso',0),(85,29,'El punto (.)',1),(86,29,'El signo más (+)',0),(87,29,'El ampersand (&)',0),(88,29,'La coma (,)',0),(89,30,'Verdadero',1),(90,30,'Falso',0),(91,31,'$_GET',0),(92,31,'$_SESSION',0),(93,31,'$_COOKIE',0),(94,31,'$_POST',1),(95,32,'Verdadero',1),(96,32,'Falso',0),(97,33,'let',0),(98,33,'const',1),(99,33,'var',0),(100,33,'def',0),(101,34,'Verdadero',0),(102,34,'Falso',1),(103,35,'pop',0),(104,35,'shift',0),(105,35,'push',1),(106,35,'unshift',0),(107,36,'Verdadero',1),(108,36,'Falso',0),(109,37,'Un string',0),(110,37,'Un array',0),(111,37,'undefined siempre',0),(112,37,'Una Promise',1),(113,38,'Verdadero',0),(114,38,'Falso',1),(115,39,'C#',0),(116,39,'PHP',1),(117,39,'Java',0),(118,39,'Python',0),(119,40,'Verdadero',1),(120,40,'Falso',0),(121,41,'php laravel new-controller',0),(122,41,'composer make:controller',0),(123,41,'php artisan make:controller',1),(124,41,'php make controller',0),(125,42,'Verdadero',1),(126,42,'Falso',0),(127,43,'Doctrine',0),(128,43,'Hibernate',0),(129,43,'Entity',0),(130,43,'Eloquent',1),(131,44,'Verdadero',1),(132,44,'Falso',0),(133,45,'string',0),(134,45,'bool',0),(135,45,'int',1),(136,45,'char',0),(137,46,'Print.Line',0),(138,46,'Echo.Write',0),(139,46,'Console.WriteLine',1),(140,46,'Output.Text',0),(141,47,'Verdadero',1),(142,47,'Falso',0),(143,48,'List',0),(144,48,'Dictionary',1),(145,48,'Array',0),(146,48,'Queue',0),(147,49,'extends',0),(148,49,'Los dos puntos (:)',1),(149,49,'inherits',0),(150,49,'from',0),(151,50,'Verdadero',0),(152,50,'Falso',1),(153,51,'IComparable',0),(154,51,'IDisposable',0),(155,51,'IEnumerable',1),(156,51,'ICloneable',0),(157,52,'Para esperar el resultado de una tarea asíncrona sin bloquear el hilo',1),(158,52,'Para detener el programa',0),(159,52,'Para crear un hilo nuevo siempre',0),(160,52,'Para declarar una constante',0),(161,53,'Verdadero',1),(162,53,'Falso',0),(163,54,'Web.config',1),(164,54,'Global.json',0),(165,54,'App.ini',0),(166,54,'Config.xml',0),(167,55,'Label',0),(168,55,'Button',0),(169,55,'GridView',1),(170,55,'Literal',0),(171,56,'Verdadero',1),(172,56,'Falso',0),(173,57,'IsValid',0),(174,57,'IsPostBack',1),(175,57,'IsCallback',0),(176,57,'IsAsync',0),(177,58,'Response.Write',0),(178,58,'Session.Add',0),(179,58,'Request.QueryString',1),(180,58,'Server.MapPath',0),(181,59,'Verdadero',1),(182,59,'Falso',0),(183,60,'Session_Start',0),(184,60,'Application_Error',1),(185,60,'Application_End',0),(186,60,'Page_Load',0),(187,61,'Server.HtmlEncode',1),(188,61,'Response.Clear',0),(189,61,'Request.Form',0),(190,61,'Session.Abandon',0),(191,62,'Verdadero',1),(192,62,'Falso',0),(193,63,'<para>',0),(194,63,'<p>',1),(195,63,'<text>',0),(196,63,'<pg>',0),(197,64,'<h1>',0),(198,64,'<head>',0),(199,64,'<title>',1),(200,64,'<header>',0),(201,65,'Verdadero',1),(202,65,'Falso',0),(203,66,'<input>',1),(204,66,'<field>',0),(205,66,'<entry>',0),(206,66,'<textbox>',0),(207,67,'src',0),(208,67,'link',0),(209,67,'href',1),(210,67,'target',0),(211,68,'Verdadero',0),(212,68,'Falso',1),(213,69,'mandatory',0),(214,69,'required',1),(215,69,'needed',0),(216,69,'must',0),(217,70,'<media>',0),(218,70,'<movie>',0),(219,70,'<clip>',0),(220,70,'<video>',1),(221,71,'Verdadero',1),(222,71,'Falso',0),(223,72,'container',1),(224,72,'box',0),(225,72,'wrapper',0),(226,72,'centered',0),(227,73,'message',0),(228,73,'notice',0),(229,73,'alert',1),(230,73,'warning-box',0),(231,74,'Verdadero',1),(232,74,'Falso',0),(233,75,'mb-3',1),(234,75,'margin-bottom-3',0),(235,75,'m-bottom-3',0),(236,75,'mbt-3',0),(237,76,'line',0),(238,76,'row',1),(239,76,'grid-row',0),(240,76,'tr',0),(241,77,'Verdadero',0),(242,77,'Falso',1),(243,78,'data-toggle=\"modal\"',0),(244,78,'data-open=\"modal\"',0),(245,78,'data-bs-toggle=\"modal\"',1),(246,78,'data-modal=\"open\"',0),(247,79,'flex-box',0),(248,79,'d-flex',1),(249,79,'display-flex',0),(250,79,'flexible',0),(251,80,'Verdadero',1),(252,80,'Falso',0),(253,81,'<?php',1),(254,81,'<php>',0),(255,81,'<%',0),(256,81,'<script php>',0),(257,82,'.pph',0),(258,82,'.ph',0),(259,82,'.php',1),(260,82,'.pp',0),(261,83,'Verdadero',1),(262,83,'Falso',0),(263,84,'size()',0),(264,84,'count()',1),(265,84,'length()',0),(266,84,'total()',0),(267,85,'import',0),(268,85,'using',0),(269,85,'require',1),(270,85,'load',0),(271,86,'Verdadero',1),(272,86,'Falso',0),(273,87,'PDO',1),(274,87,'CURL',0),(275,87,'GD',0),(276,87,'SPL',0),(277,88,'strip_tags',0),(278,88,'htmlspecialchars',1),(279,88,'addslashes',0),(280,88,'trim',0),(281,89,'Verdadero',1),(282,89,'Falso',0),(283,90,'<js>',0),(284,90,'<code>',0),(285,90,'<script>',1),(286,90,'<javascript>',0),(287,91,'console.log()',1),(288,91,'print()',0),(289,91,'echo()',0),(290,91,'System.out.println()',0),(291,92,'Verdadero',1),(292,92,'Falso',0),(293,93,'filter',0),(294,93,'map',1),(295,93,'push',0),(296,93,'join',0),(297,94,'getElementById',1),(298,94,'findId',0),(299,94,'queryId',0),(300,94,'selectById',0),(301,95,'Verdadero',0),(302,95,'Falso',1),(303,96,'Convierte un objeto en texto',0),(304,96,'Convierte texto JSON en un objeto',1),(305,96,'Borra un objeto',0),(306,96,'Ordena un arreglo',0),(307,97,'then',0),(308,97,'finally',0),(309,97,'catch',1),(310,97,'error',0),(311,98,'Verdadero',0),(312,98,'Falso',1),(313,99,'Composer',1),(314,99,'npm',0),(315,99,'Maven',0),(316,99,'pip',0),(317,100,'config.txt',0),(318,100,'.env',1),(319,100,'settings.ini',0),(320,100,'app.json',0),(321,101,'Verdadero',1),(322,101,'Falso',0),(323,102,'resources/views',1),(324,102,'app/pages',0),(325,102,'public/views',0),(326,102,'storage/blade',0),(327,103,'routes/web.php',1),(328,103,'app/routes.php',0),(329,103,'config/web.php',0),(330,103,'public/routes.php',0),(331,104,'Verdadero',1),(332,104,'Falso',0),(333,105,'php artisan run',0),(334,105,'php artisan db:go',0),(335,105,'php artisan migrate',1),(336,105,'composer migrate',0),(337,106,'@secure',0),(338,106,'@token',0),(339,106,'@csrf',1),(340,106,'@guard',0),(341,107,'Verdadero',1),(342,107,'Falso',0);
/*!40000 ALTER TABLE `opciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partidas`
--

DROP TABLE IF EXISTS `partidas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partidas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idTema` int NOT NULL,
  `idNivel` int NOT NULL,
  `idSetQr` int DEFAULT NULL,
  `dtInicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dtFin` datetime DEFAULT NULL,
  `nuTotalPreguntas` int NOT NULL DEFAULT '0',
  `nuAciertos` int NOT NULL DEFAULT '0',
  `nuPuntos` int NOT NULL DEFAULT '0',
  `nuPorcentaje` decimal(5,2) NOT NULL DEFAULT '0.00',
  `nuAprobado` tinyint(1) NOT NULL DEFAULT '0',
  `nuSegundosTotal` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_partidas_usuario_tema_nivel` (`idUsuario`,`idTema`,`idNivel`),
  KEY `fk_partidas_temas` (`idTema`),
  KEY `fk_partidas_niveles` (`idNivel`),
  KEY `fk_partidas_sets_qr` (`idSetQr`),
  CONSTRAINT `fk_partidas_niveles` FOREIGN KEY (`idNivel`) REFERENCES `niveles` (`id`),
  CONSTRAINT `fk_partidas_sets_qr` FOREIGN KEY (`idSetQr`) REFERENCES `sets_qr` (`id`),
  CONSTRAINT `fk_partidas_temas` FOREIGN KEY (`idTema`) REFERENCES `temas` (`id`),
  CONSTRAINT `fk_partidas_usuarios` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partidas`
--

LOCK TABLES `partidas` WRITE;
/*!40000 ALTER TABLE `partidas` DISABLE KEYS */;
/*!40000 ALTER TABLE `partidas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idTema` int NOT NULL,
  `idNivel` int NOT NULL,
  `dsTipo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPCION_MULTIPLE',
  `dsEnunciado` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nuPuntos` int NOT NULL DEFAULT '10',
  `nuSegundos` int NOT NULL DEFAULT '30',
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsUsuarioModificacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaModificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_preguntas_tema_nivel` (`idTema`,`idNivel`),
  KEY `fk_preguntas_niveles` (`idNivel`),
  CONSTRAINT `fk_preguntas_niveles` FOREIGN KEY (`idNivel`) REFERENCES `niveles` (`id`),
  CONSTRAINT `fk_preguntas_temas` FOREIGN KEY (`idTema`) REFERENCES `temas` (`id`),
  CONSTRAINT `ck_preguntas_dsEstado` CHECK ((`dsEstado` in (_utf8mb4'0',_utf8mb4'1'))),
  CONSTRAINT `ck_preguntas_dsTipo` CHECK ((`dsTipo` in (_utf8mb4'OPCION_MULTIPLE',_utf8mb4'VERDADERO_FALSO')))
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,1,'OPCION_MULTIPLE','Tu mama te mima?',15,30,'0','admin@trivias.local','2026-11-22 19:20:45','admin@trivias.local','2026-11-22 19:24:23'),(2,2,1,'VERDADERO_FALSO','Soy o no soy',10,30,'0','admin@trivias.local','2026-11-22 19:22:48','admin@trivias.local','2026-11-22 19:24:21'),(3,1,1,'OPCION_MULTIPLE','¿Qué palabra clave se usa para declarar una constante en C#?',10,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(4,1,1,'VERDADERO_FALSO','C# es un lenguaje de programación orientado a objetos.',10,20,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(5,1,2,'OPCION_MULTIPLE','¿Qué estructura recorre una colección elemento por elemento?',20,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(6,1,2,'VERDADERO_FALSO','En C# un string se puede modificar en el mismo objeto sin crear otro.',20,25,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(7,1,3,'OPCION_MULTIPLE','¿Qué palabra clave libera un recurso, como una conexión, al salir de su bloque?',30,45,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(8,1,3,'VERDADERO_FALSO','Un struct en C# es un tipo por referencia.',30,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(9,2,1,'OPCION_MULTIPLE','¿Qué extensión tienen las páginas de Web Forms?',10,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(10,2,1,'VERDADERO_FALSO','ASP.NET es un framework de Microsoft para crear aplicaciones web.',10,20,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(11,2,2,'OPCION_MULTIPLE','¿Qué objeto guarda datos de un usuario entre varias páginas durante su visita?',20,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(12,2,2,'VERDADERO_FALSO','Una Master Page permite compartir un diseño común entre varias páginas.',20,25,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(13,2,3,'OPCION_MULTIPLE','¿Cuál de estos eventos de la página ocurre primero?',30,45,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(14,2,3,'VERDADERO_FALSO','El ViewState guarda su información en el servidor por defecto.',30,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(15,3,1,'OPCION_MULTIPLE','¿Qué etiqueta se usa para crear un enlace?',10,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(16,3,1,'VERDADERO_FALSO','La etiqueta <img> necesita una etiqueta de cierre.',10,20,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(17,3,2,'OPCION_MULTIPLE','¿Qué atributo de <img> describe la imagen para lectores de pantalla?',20,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(18,3,2,'VERDADERO_FALSO','La etiqueta <ul> crea una lista ordenada con números.',20,25,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(19,3,3,'OPCION_MULTIPLE','¿Qué etiqueta semántica representa el contenido principal de una página?',30,45,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(20,3,3,'VERDADERO_FALSO','Los atributos data-* permiten guardar datos personalizados en un elemento.',30,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(21,4,1,'OPCION_MULTIPLE','¿Qué clases crean un botón azul principal en Bootstrap?',10,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(22,4,1,'VERDADERO_FALSO','Bootstrap se puede usar incluyéndolo desde un CDN.',10,20,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(23,4,2,'OPCION_MULTIPLE','¿Cuántas columnas tiene el sistema de rejilla de Bootstrap?',20,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(24,4,2,'VERDADERO_FALSO','La clase d-none oculta un elemento.',20,25,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(25,4,3,'OPCION_MULTIPLE','¿Qué sufijo hace que col-__-6 aplique desde pantallas medianas hacia arriba?',30,45,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(26,4,3,'VERDADERO_FALSO','Bootstrap 5 necesita jQuery para funcionar.',30,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(27,5,1,'OPCION_MULTIPLE','¿Con qué símbolo empieza el nombre de una variable en PHP?',10,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(28,5,1,'VERDADERO_FALSO','PHP es un lenguaje que se ejecuta en el servidor.',10,20,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(29,5,2,'OPCION_MULTIPLE','¿Qué operador concatena dos cadenas en PHP?',20,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(30,5,2,'VERDADERO_FALSO','En PHP los arreglos asociativos usan pares clave => valor.',20,25,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(31,5,3,'OPCION_MULTIPLE','¿Qué superglobal contiene los datos enviados por un formulario con método POST?',30,45,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(32,5,3,'VERDADERO_FALSO','La función password_hash() sirve para guardar contraseñas de forma segura en PHP.',30,30,'1','seed','2026-11-22 19:32:42','seed','2026-11-22 19:32:42'),(33,6,1,'OPCION_MULTIPLE','¿Qué palabra clave declara una constante en JavaScript?',10,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(34,6,1,'VERDADERO_FALSO','JavaScript y Java son el mismo lenguaje.',10,20,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(35,6,2,'OPCION_MULTIPLE','¿Qué método agrega un elemento al final de un arreglo?',20,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(36,6,2,'VERDADERO_FALSO','El operador === compara el valor y también el tipo.',20,25,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(37,6,3,'OPCION_MULTIPLE','¿Qué devuelve una función declarada como async?',30,45,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(38,6,3,'VERDADERO_FALSO','typeof null devuelve la cadena \"null\".',30,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(39,7,1,'OPCION_MULTIPLE','¿En qué lenguaje está hecho Laravel?',10,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(40,7,1,'VERDADERO_FALSO','Laravel es un framework.',10,20,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(41,7,2,'OPCION_MULTIPLE','¿Qué comando de la consola de Laravel crea un controlador?',20,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(42,7,2,'VERDADERO_FALSO','Blade es el motor de plantillas de Laravel.',20,25,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(43,7,3,'OPCION_MULTIPLE','¿Cómo se llama el ORM que incluye Laravel?',30,45,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(44,7,3,'VERDADERO_FALSO','Las migraciones de Laravel sirven para versionar los cambios en la estructura de la base de datos.',30,30,'1','seed','2026-11-22 19:32:43','seed','2026-11-22 19:32:43'),(45,1,1,'OPCION_MULTIPLE','¿Qué tipo de dato se usa en C# para números enteros?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(46,1,1,'OPCION_MULTIPLE','¿Qué instrucción muestra texto en una aplicación de consola?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(47,1,1,'VERDADERO_FALSO','Una variable bool solo puede valer true o false.',10,20,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(48,1,2,'OPCION_MULTIPLE','¿Qué colección guarda elementos asociados a una clave única?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(49,1,2,'OPCION_MULTIPLE','¿Qué símbolo se usa en C# para heredar de una clase?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(50,1,2,'VERDADERO_FALSO','Un método declarado como void devuelve un valor entero.',20,25,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(51,1,3,'OPCION_MULTIPLE','¿Qué interfaz debe implementar una clase para poder recorrerse con foreach?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(52,1,3,'OPCION_MULTIPLE','¿Para qué sirve la palabra clave await?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(53,1,3,'VERDADERO_FALSO','LINQ permite consultar colecciones con una sintaxis integrada en C#.',30,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(54,2,1,'OPCION_MULTIPLE','¿Qué archivo guarda la configuración de una aplicación ASP.NET?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(55,2,1,'OPCION_MULTIPLE','¿Qué control de Web Forms muestra una tabla de datos?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(56,2,1,'VERDADERO_FALSO','Los controles de servidor de Web Forms llevan el atributo runat=\"server\".',10,20,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(57,2,2,'OPCION_MULTIPLE','¿Qué propiedad indica si la página se está enviando de nuevo al servidor?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(58,2,2,'OPCION_MULTIPLE','¿Cómo se lee un parámetro de la URL, como ?id=5?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(59,2,2,'VERDADERO_FALSO','Response.Redirect envía al usuario a otra página.',20,25,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(60,2,3,'OPCION_MULTIPLE','¿Qué evento de Global.asax se usa para capturar errores no controlados de toda la aplicación?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(61,2,3,'OPCION_MULTIPLE','¿Qué método sirve para codificar texto y evitar ataques XSS al mostrarlo?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(62,2,3,'VERDADERO_FALSO','Una Master Page puede contener controles ContentPlaceHolder.',30,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(63,3,1,'OPCION_MULTIPLE','¿Qué etiqueta crea un párrafo?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(64,3,1,'OPCION_MULTIPLE','¿Qué etiqueta define el título que aparece en la pestaña del navegador?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(65,3,1,'VERDADERO_FALSO','La etiqueta <h1> representa el encabezado de mayor importancia.',10,20,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(66,3,2,'OPCION_MULTIPLE','¿Qué etiqueta crea un campo de entrada en un formulario?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(67,3,2,'OPCION_MULTIPLE','¿Qué atributo indica a dónde apunta un enlace?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(68,3,2,'VERDADERO_FALSO','Un <div> es un elemento en línea por defecto.',20,25,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(69,3,3,'OPCION_MULTIPLE','¿Qué atributo hace obligatorio un campo de formulario?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(70,3,3,'OPCION_MULTIPLE','¿Qué etiqueta de HTML5 incrusta un video?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(71,3,3,'VERDADERO_FALSO','El atributo lang de <html> ayuda a los lectores de pantalla a elegir el idioma.',30,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(72,4,1,'OPCION_MULTIPLE','¿Qué clase de Bootstrap crea un contenedor centrado con ancho máximo?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(73,4,1,'OPCION_MULTIPLE','¿Qué clase muestra un mensaje de alerta en Bootstrap?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(74,4,1,'VERDADERO_FALSO','Bootstrap incluye componentes listos como botones y tarjetas.',10,20,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(75,4,2,'OPCION_MULTIPLE','¿Qué clase pone un margen inferior de tamaño 3?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(76,4,2,'OPCION_MULTIPLE','¿Qué clase crea una fila en el sistema de rejilla?',20,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(77,4,2,'VERDADERO_FALSO','La clase text-center alinea el texto a la derecha.',20,25,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(78,4,3,'OPCION_MULTIPLE','¿Qué atributo data de Bootstrap 5 abre un modal desde un botón?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(79,4,3,'OPCION_MULTIPLE','¿Qué clase de utilidad convierte un elemento en contenedor flexible?',30,45,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(80,4,3,'VERDADERO_FALSO','La clase col-12 ocupa las 12 columnas de la rejilla.',30,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(81,5,1,'OPCION_MULTIPLE','¿Con qué etiqueta empieza un bloque de código PHP?',10,30,'1','seed','2026-11-22 20:49:20','seed','2026-11-22 20:49:20'),(82,5,1,'OPCION_MULTIPLE','¿Qué extensión suelen tener los archivos PHP?',10,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(83,5,1,'VERDADERO_FALSO','En PHP cada instrucción termina con punto y coma.',10,20,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(84,5,2,'OPCION_MULTIPLE','¿Qué función devuelve la cantidad de elementos de un arreglo?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(85,5,2,'OPCION_MULTIPLE','¿Qué instrucción incluye otro archivo y detiene el script si no existe?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(86,5,2,'VERDADERO_FALSO','En PHP los nombres de variable distinguen entre mayúsculas y minúsculas.',20,25,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(87,5,3,'OPCION_MULTIPLE','¿Qué extensión de PHP permite consultas preparadas con varios motores de base de datos?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(88,5,3,'OPCION_MULTIPLE','¿Qué función convierte caracteres especiales a entidades HTML?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(89,5,3,'VERDADERO_FALSO','Para usar $_SESSION hay que llamar antes a session_start().',30,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(90,6,1,'OPCION_MULTIPLE','¿Qué etiqueta HTML se usa para incluir JavaScript?',10,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(91,6,1,'OPCION_MULTIPLE','¿Qué instrucción muestra un mensaje en la consola del navegador?',10,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(92,6,1,'VERDADERO_FALSO','JavaScript se puede ejecutar dentro del navegador.',10,20,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(93,6,2,'OPCION_MULTIPLE','¿Qué método crea un arreglo nuevo aplicando una función a cada elemento?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(94,6,2,'OPCION_MULTIPLE','¿Qué método busca un elemento del documento por su id?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(95,6,2,'VERDADERO_FALSO','Un arreglo de JavaScript tiene un tamaño fijo que no se puede cambiar.',20,25,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(96,6,3,'OPCION_MULTIPLE','¿Qué hace JSON.parse()?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(97,6,3,'OPCION_MULTIPLE','¿Qué método de una Promise captura un error?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(98,6,3,'VERDADERO_FALSO','Las funciones flecha tienen su propio this.',30,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(99,7,1,'OPCION_MULTIPLE','¿Qué herramienta se usa para instalar Laravel y sus dependencias?',10,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(100,7,1,'OPCION_MULTIPLE','¿Qué archivo guarda la configuración del entorno, como los datos de la base de datos?',10,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(101,7,1,'VERDADERO_FALSO','Laravel sigue el patrón MVC.',10,20,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(102,7,2,'OPCION_MULTIPLE','¿En qué carpeta se guardan las vistas Blade?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(103,7,2,'OPCION_MULTIPLE','¿Qué archivo define las rutas web de la aplicación?',20,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(104,7,2,'VERDADERO_FALSO','Un middleware puede revisar la petición antes de que llegue al controlador.',20,25,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(105,7,3,'OPCION_MULTIPLE','¿Qué comando ejecuta las migraciones pendientes?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(106,7,3,'OPCION_MULTIPLE','¿Qué directiva de Blade protege un formulario contra ataques CSRF?',30,45,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21'),(107,7,3,'VERDADERO_FALSO','Las policies de Laravel sirven para definir permisos sobre modelos.',30,30,'1','seed','2026-11-22 20:49:21','seed','2026-11-22 20:49:21');
/*!40000 ALTER TABLE `preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `premios`
--

DROP TABLE IF EXISTS `premios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `premios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idTema` int NOT NULL,
  `idNivel` int NOT NULL,
  `dsNombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsDescripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsRutaImagen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nuPuntos` int NOT NULL DEFAULT '50',
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsUsuarioModificacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaModificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_premios_tema_nivel` (`idTema`,`idNivel`),
  KEY `fk_premios_niveles` (`idNivel`),
  CONSTRAINT `fk_premios_niveles` FOREIGN KEY (`idNivel`) REFERENCES `niveles` (`id`),
  CONSTRAINT `fk_premios_temas` FOREIGN KEY (`idTema`) REFERENCES `temas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `premios`
--

LOCK TABLES `premios` WRITE;
/*!40000 ALTER TABLE `premios` DISABLE KEYS */;
INSERT INTO `premios` VALUES (1,1,1,'Aprendiz de C#',NULL,'~/Uploads/premios/5b8280a6c6fc4a32a50be0b96cb0defc.png',50,'1','admin@trivias.local','2026-11-22 20:04:10','admin@trivias.local','2026-11-22 20:04:10'),(3,1,2,'Entusiasta de C#',NULL,'~/Uploads/premios/aa167931fb2a498284d594457b8c2104.png',75,'1','admin@trivias.local','2026-11-22 20:06:01','admin@trivias.local','2026-11-22 20:06:55'),(4,1,3,'Maestro de C#',NULL,'~/Uploads/premios/3891be70da8240059e99d2c380b3d243.png',100,'1','admin@trivias.local','2026-11-22 20:06:44','admin@trivias.local','2026-11-22 20:06:44');
/*!40000 ALTER TABLE `premios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas`
--

DROP TABLE IF EXISTS `respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idPartida` int NOT NULL,
  `idPregunta` int NOT NULL,
  `idOpcion` int DEFAULT NULL,
  `nuEsCorrecta` tinyint(1) NOT NULL DEFAULT '0',
  `nuSegundos` int NOT NULL DEFAULT '0',
  `dtRespuesta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_respuestas_idPartida` (`idPartida`),
  KEY `fk_respuestas_preguntas` (`idPregunta`),
  KEY `fk_respuestas_opciones` (`idOpcion`),
  CONSTRAINT `fk_respuestas_opciones` FOREIGN KEY (`idOpcion`) REFERENCES `opciones` (`id`),
  CONSTRAINT `fk_respuestas_partidas` FOREIGN KEY (`idPartida`) REFERENCES `partidas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_respuestas_preguntas` FOREIGN KEY (`idPregunta`) REFERENCES `preguntas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
/*!40000 ALTER TABLE `respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sets_qr`
--

DROP TABLE IF EXISTS `sets_qr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets_qr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dsCodigo` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsNombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idTema` int NOT NULL,
  `idNivel` int NOT NULL,
  `nuCantidadPreguntas` int NOT NULL DEFAULT '5',
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sets_qr_dsCodigo` (`dsCodigo`),
  KEY `fk_sets_qr_temas` (`idTema`),
  KEY `fk_sets_qr_niveles` (`idNivel`),
  CONSTRAINT `fk_sets_qr_niveles` FOREIGN KEY (`idNivel`) REFERENCES `niveles` (`id`),
  CONSTRAINT `fk_sets_qr_temas` FOREIGN KEY (`idTema`) REFERENCES `temas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sets_qr`
--

LOCK TABLES `sets_qr` WRITE;
/*!40000 ALTER TABLE `sets_qr` DISABLE KEYS */;
INSERT INTO `sets_qr` VALUES (1,'67493c43-b680-49c4-945e-8552062cfcfd','Demo C#',1,1,5,'1','admin@trivias.local','2026-11-23 00:28:17');
/*!40000 ALTER TABLE `sets_qr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temas`
--

DROP TABLE IF EXISTS `temas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dsNombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsDescripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsUsuarioModificacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaModificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_temas_dsNombre` (`dsNombre`),
  CONSTRAINT `ck_temas_dsEstado` CHECK ((`dsEstado` in (_utf8mb4'0',_utf8mb4'1')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temas`
--

LOCK TABLES `temas` WRITE;
/*!40000 ALTER TABLE `temas` DISABLE KEYS */;
INSERT INTO `temas` VALUES (1,'C#','Lenguaje de programación de .NET','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(2,'ASP.NET','Framework web de Microsoft','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(3,'HTML','Lenguaje de marcado para páginas web','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(4,'Bootstrap','Framework CSS para diseño responsive','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(5,'PHP','Lenguaje de programación para el servidor','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(6,'JavaScript','Lenguaje de programación del navegador','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(7,'Laravel','Framework de PHP','1','Sistema','2026-11-22 15:31:22','Sistema','2026-11-22 15:31:22'),(8,'Python','Preguntas sobre el lenguaje de programación Python','1','admin@trivias.local','2026-11-22 19:18:32','admin@trivias.local','2026-11-22 19:19:31');
/*!40000 ALTER TABLE `temas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_premios`
--

DROP TABLE IF EXISTS `usuario_premios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_premios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idPremio` int NOT NULL,
  `idPartida` int NOT NULL,
  `dtObtenido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_usuario_premios` (`idUsuario`,`idPremio`),
  KEY `fk_up_premios` (`idPremio`),
  KEY `fk_up_partidas` (`idPartida`),
  CONSTRAINT `fk_up_partidas` FOREIGN KEY (`idPartida`) REFERENCES `partidas` (`id`),
  CONSTRAINT `fk_up_premios` FOREIGN KEY (`idPremio`) REFERENCES `premios` (`id`),
  CONSTRAINT `fk_up_usuarios` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_premios`
--

LOCK TABLES `usuario_premios` WRITE;
/*!40000 ALTER TABLE `usuario_premios` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_premios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dsCedula` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsNombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsCorreo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsPassword` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dsRol` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'JUGADOR',
  `dsEstado` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `idAvatar` int DEFAULT NULL,
  `dsUsuarioCreacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dsUsuarioModificacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sistema',
  `dtFechaModificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_usuarios_dsCedula` (`dsCedula`),
  UNIQUE KEY `uq_usuarios_dsCorreo` (`dsCorreo`),
  KEY `fk_usuarios_avatares` (`idAvatar`),
  CONSTRAINT `fk_usuarios_avatares` FOREIGN KEY (`idAvatar`) REFERENCES `avatares` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ck_usuarios_dsEstado` CHECK ((`dsEstado` in (_utf8mb4'0',_utf8mb4'1'))),
  CONSTRAINT `ck_usuarios_dsRol` CHECK ((`dsRol` in (_utf8mb4'ADMIN',_utf8mb4'OPERATIVO',_utf8mb4'JUGADOR')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'0-000-0000','Administrador','admin@trivias.local','PBKDF2$100000$4tLRmAljceo3YVuLP8Foeg==$nJDtBlm2N173hd7eC8A77NdXSznx+rZUP3aib8iPmOw=','ADMIN','1',1,'Sistema','2026-11-22 15:31:22','admin@trivias.local','2026-11-22 18:54:47'),(2,'8-123-456','Irina Fong','irinafong@gmail.com','PBKDF2$100000$vWbMXH30nH12fJI9TLVt3Q==$nP5FeQ479mu+vnu2SX3xoTi5L9HQIffBnUzJLnR0HNg=','JUGADOR','1',2,'admin@trivias.local','2026-11-22 18:26:56','irinafong@gmail.com','2026-11-22 18:54:24'),(5,'20-16-8273','Marito','mario.fernandez@utp.ac.pa','PBKDF2$100000$YdeT5ICcGfdZInNEd2uwXw==$8zKJisUvD6lKBVzJo8lusG6X97b30wtUa2ME9ehg3is=','JUGADOR','1',3,'registro_publico','2026-11-22 23:48:55','mario.fernandez@utp.ac.pa','2026-11-22 23:49:58');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'bd_trivias'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_actual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_actual`(IN p_idUsuario INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM usuarios u
    INNER JOIN avatares a ON a.id = u.idAvatar
    WHERE u.id = p_idUsuario AND a.dsEstado = '1';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_actualizar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_cambiar_estado`(
    IN p_id          INT,
    IN p_estado      CHAR(1),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE avatares SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
    IF p_estado = '0' THEN
        UPDATE usuarios SET idAvatar = NULL WHERE idAvatar = p_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_listar`(IN p_idUsuario INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM avatares a
    INNER JOIN usuarios u ON u.id = a.idUsuario
    WHERE p_idUsuario IS NULL OR a.idUsuario = p_idUsuario
    ORDER BY a.dsEstado DESC, a.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_obtener`(IN p_id INT)
BEGIN
    SELECT a.id, a.idUsuario, a.dsNombre, a.dsRutaImagen, a.dsEstado, u.dsNombre AS dsNombreUsuario
    FROM avatares a
    INNER JOIN usuarios u ON u.id = a.idUsuario
    WHERE a.id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_registrar`(
    IN p_idUsuario INT,
    IN p_nombre    VARCHAR(60),
    IN p_ruta      VARCHAR(255),
    IN p_creador   VARCHAR(100))
BEGIN
    INSERT INTO avatares (idUsuario, dsNombre, dsRutaImagen, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_idUsuario, p_nombre, p_ruta, p_creador, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_avatar_usar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avatar_usar`(
    IN p_idUsuario   INT,
    IN p_idAvatar    INT,
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE usuarios SET idAvatar = p_idAvatar, dsUsuarioModificacion = p_modificador WHERE id = p_idUsuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_calif_guardar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calif_guardar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_calif_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calif_listar`()
BEGIN
    SELECT c.id, c.idUsuario, u.dsNombre AS dsNombreUsuario, c.idTema, t.dsNombre AS dsNombreTema,
           c.nuCalifTema, c.nuCalifApp, c.dsTemaSugerido, c.dsComentario, c.dtFecha
    FROM calificaciones c
    INNER JOIN usuarios u ON u.id = c.idUsuario
    INNER JOIN temas t ON t.id = c.idTema
    ORDER BY c.dtFecha DESC
    LIMIT 300;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_calif_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calif_obtener`(IN p_idUsuario INT, IN p_idTema INT)
BEGIN
    SELECT c.id, c.idUsuario, c.idTema, t.dsNombre AS dsNombreTema, c.nuCalifTema, c.nuCalifApp, c.dsTemaSugerido, c.dsComentario, c.dtFecha
    FROM calificaciones c INNER JOIN temas t ON t.id = c.idTema
    WHERE c.idUsuario = p_idUsuario AND c.idTema = p_idTema;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_calif_resumen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calif_resumen`()
BEGIN
    SELECT t.id AS idTema, t.dsNombre AS dsNombreTema, COUNT(c.id) AS nuCalificaciones,
           IFNULL(ROUND(AVG(c.nuCalifTema), 2), 0) AS nuPromedioTema,
           IFNULL(ROUND(AVG(c.nuCalifApp), 2), 0) AS nuPromedioApp
    FROM temas t LEFT JOIN calificaciones c ON c.idTema = t.id
    GROUP BY t.id, t.dsNombre
    ORDER BY t.dsNombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_imgres_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_imgres_actualizar`(IN p_id INT, IN p_minimo INT, IN p_mensaje VARCHAR(120), IN p_ruta VARCHAR(255))
BEGIN
    UPDATE imagenes_resultado
    SET nuPorcentajeMinimo = p_minimo, dsMensaje = p_mensaje, dsRutaImagen = IFNULL(p_ruta, dsRutaImagen)
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_imgres_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_imgres_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE imagenes_resultado SET dsEstado = p_estado WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_imgres_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_imgres_listar`()
BEGIN
    SELECT id, nuPorcentajeMinimo, dsMensaje, dsRutaImagen, dsEstado FROM imagenes_resultado ORDER BY nuPorcentajeMinimo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_imgres_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_imgres_obtener`(IN p_id INT)
BEGIN
    SELECT id, nuPorcentajeMinimo, dsMensaje, dsRutaImagen, dsEstado FROM imagenes_resultado WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_imgres_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_imgres_registrar`(IN p_minimo INT, IN p_mensaje VARCHAR(120), IN p_ruta VARCHAR(255))
BEGIN
    INSERT INTO imagenes_resultado (nuPorcentajeMinimo, dsMensaje, dsRutaImagen) VALUES (p_minimo, p_mensaje, p_ruta);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_juego_niveles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_juego_niveles`(IN p_idUsuario INT, IN p_idTema INT)
BEGIN
    SELECT n.id, n.dsNombre, n.nuOrden, n.nuPorcentajeAprobacion,
           (SELECT COUNT(*) FROM preguntas q WHERE q.idTema = p_idTema AND q.idNivel = n.id AND q.dsEstado = '1') AS nuPreguntas,
           EXISTS(SELECT 1 FROM partidas pa WHERE pa.idUsuario = p_idUsuario AND pa.idTema = p_idTema AND pa.idNivel = n.id AND pa.nuAprobado = 1) AS nuAprobado,
           IFNULL((SELECT MAX(pa.nuPorcentaje) FROM partidas pa WHERE pa.idUsuario = p_idUsuario AND pa.idTema = p_idTema AND pa.idNivel = n.id AND pa.dtFin IS NOT NULL), 0) AS nuMejorPorcentaje,
           (SELECT COUNT(*) FROM partidas pa WHERE pa.idUsuario = p_idUsuario AND pa.idTema = p_idTema AND pa.idNivel = n.id AND pa.dtFin IS NOT NULL) AS nuIntentos,
           IFNULL(pr.id, 0) AS idPremio, pr.dsNombre AS dsPremioNombre, pr.dsRutaImagen AS dsPremioImagen, IFNULL(pr.nuPuntos, 0) AS nuPremioPuntos,
           EXISTS(SELECT 1 FROM usuario_premios up WHERE up.idUsuario = p_idUsuario AND up.idPremio = pr.id) AS nuPremioGanado
    FROM niveles n
    LEFT JOIN premios pr ON pr.idTema = p_idTema AND pr.idNivel = n.id AND pr.dsEstado = '1'
    ORDER BY n.nuOrden;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_juego_resumen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_juego_resumen`(IN p_idUsuario INT)
BEGIN
    SELECT (SELECT IFNULL(SUM(mejor), 0) FROM (SELECT MAX(nuPuntos) AS mejor FROM partidas
                                                 WHERE idUsuario = p_idUsuario AND dtFin IS NOT NULL GROUP BY idTema, idNivel) m)
         + (SELECT IFNULL(SUM(p.nuPuntos), 0) FROM usuario_premios up INNER JOIN premios p ON p.id = up.idPremio WHERE up.idUsuario = p_idUsuario) AS nuPuntos,
           (SELECT COUNT(*) FROM partidas WHERE idUsuario = p_idUsuario AND dtFin IS NOT NULL) AS nuPartidas,
           (SELECT COUNT(*) FROM (SELECT DISTINCT idTema, idNivel FROM partidas WHERE idUsuario = p_idUsuario AND nuAprobado = 1) d) AS nuNivelesAprobados,
           (SELECT COUNT(*) FROM usuario_premios WHERE idUsuario = p_idUsuario) AS nuPremios;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_juego_sortear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_juego_sortear`(IN p_idTema INT, IN p_idNivel INT, IN p_cantidad INT)
BEGIN
    SELECT id FROM preguntas WHERE idTema = p_idTema AND idNivel = p_idNivel AND dsEstado = '1' ORDER BY RAND() LIMIT p_cantidad;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_juego_temas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_juego_temas`(IN p_idUsuario INT)
BEGIN
    SELECT t.id, t.dsNombre, t.dsDescripcion,
           (SELECT COUNT(*) FROM niveles) AS nuNiveles,
           (SELECT COUNT(DISTINCT pa.idNivel) FROM partidas pa
             WHERE pa.idUsuario = p_idUsuario AND pa.idTema = t.id AND pa.nuAprobado = 1) AS nuAprobados,
           IFNULL(pp.puntos, 0) + IFNULL(pr.puntos, 0) AS nuPuntos,
           (SELECT COUNT(*) FROM preguntas q WHERE q.idTema = t.id AND q.dsEstado = '1') AS nuPreguntas
    FROM temas t
    LEFT JOIN (SELECT idTema, SUM(mejor) AS puntos
               FROM (SELECT idTema, idNivel, MAX(nuPuntos) AS mejor FROM partidas
                      WHERE idUsuario = p_idUsuario AND dtFin IS NOT NULL GROUP BY idTema, idNivel) m
               GROUP BY idTema) pp ON pp.idTema = t.id
    LEFT JOIN (SELECT p.idTema, SUM(p.nuPuntos) AS puntos FROM usuario_premios up
               INNER JOIN premios p ON p.id = up.idPremio WHERE up.idUsuario = p_idUsuario GROUP BY p.idTema) pr ON pr.idTema = t.id
    WHERE t.dsEstado = '1'
    HAVING nuPreguntas > 0
    ORDER BY t.dsNombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(IN p_correo VARCHAR(100))
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsPassword, dsRol, dsEstado, idAvatar
    FROM usuarios
    WHERE dsCorreo = p_correo
      AND dsEstado = '1';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_log_error` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_log_error`(
    IN p_origen  VARCHAR(100),
    IN p_mensaje VARCHAR(500),
    IN p_detalle TEXT,
    IN p_usuario VARCHAR(100))
BEGIN
    INSERT INTO log_errores (dsOrigen, dsMensaje, dsDetalle, dsUsuario)
    VALUES (p_origen, p_mensaje, p_detalle, p_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_nivel_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nivel_listar`()
BEGIN
    SELECT id, dsNombre, nuOrden, nuPorcentajeAprobacion FROM niveles ORDER BY nuOrden;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_actualizar`(
    IN p_id INT, IN p_titulo VARCHAR(150), IN p_resumen VARCHAR(300), IN p_contenido TEXT, IN p_ruta VARCHAR(255))
BEGIN
    UPDATE noticias
    SET dsTitulo = p_titulo, dsResumen = p_resumen, dsContenido = p_contenido, dsRutaImagen = IFNULL(p_ruta, dsRutaImagen)
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE noticias SET dsEstado = p_estado WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_listar`()
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado
    FROM noticias ORDER BY dtPublicacion DESC, id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_obtener`(IN p_id INT)
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado FROM noticias WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_publicas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_publicas`(IN p_cantidad INT)
BEGIN
    SELECT id, dsTitulo, dsResumen, dsContenido, dsRutaImagen, dtPublicacion, dsEstado
    FROM noticias WHERE dsEstado = '1'
    ORDER BY dtPublicacion DESC, id DESC
    LIMIT p_cantidad;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_noticia_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_noticia_registrar`(
    IN p_titulo VARCHAR(150), IN p_resumen VARCHAR(300), IN p_contenido TEXT, IN p_ruta VARCHAR(255), IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO noticias (dsTitulo, dsResumen, dsContenido, dsRutaImagen, dsUsuarioCreacion)
    VALUES (p_titulo, p_resumen, p_contenido, p_ruta, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_opcion_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_opcion_listar`(IN p_idPregunta INT)
BEGIN
    SELECT id, idPregunta, dsTexto, nuEsCorrecta FROM opciones WHERE idPregunta = p_idPregunta ORDER BY id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_partida_finalizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_partida_finalizar`(IN p_idPartida INT)
BEGIN
    DECLARE v_user INT DEFAULT NULL;
    DECLARE v_tema INT;
    DECLARE v_nivel INT;
    DECLARE v_total INT;
    DECLARE v_resp INT;
    DECLARE v_ac INT;
    DECLARE v_pts INT;
    DECLARE v_seg INT;
    DECLARE v_min INT;
    DECLARE v_pct DECIMAL(5,2);
    DECLARE v_apr TINYINT;

    SELECT idUsuario, idTema, idNivel, nuTotalPreguntas INTO v_user, v_tema, v_nivel, v_total
    FROM partidas WHERE id = p_idPartida AND dtFin IS NULL;
    IF v_user IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Partida no valida'; END IF;

    SELECT COUNT(*), IFNULL(SUM(r.nuEsCorrecta), 0), IFNULL(SUM(CASE WHEN r.nuEsCorrecta = 1 THEN q.nuPuntos ELSE 0 END), 0), IFNULL(SUM(r.nuSegundos), 0)
    INTO v_resp, v_ac, v_pts, v_seg
    FROM respuestas r INNER JOIN preguntas q ON q.id = r.idPregunta WHERE r.idPartida = p_idPartida;
    IF v_resp < v_total THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Faltan preguntas por responder'; END IF;

    SET v_pct = IF(v_total = 0, 0, ROUND(v_ac * 100 / v_total, 2));
    SELECT nuPorcentajeAprobacion INTO v_min FROM niveles WHERE id = v_nivel;
    SET v_apr = IF(v_pct >= v_min, 1, 0);

    UPDATE partidas
    SET dtFin = NOW(), nuAciertos = v_ac, nuPuntos = v_pts, nuPorcentaje = v_pct, nuAprobado = v_apr, nuSegundosTotal = v_seg
    WHERE id = p_idPartida;

    -- el premio se gana una sola vez por la llave unica
    IF v_apr = 1 THEN
        INSERT IGNORE INTO usuario_premios (idUsuario, idPremio, idPartida)
        SELECT v_user, id, p_idPartida FROM premios WHERE idTema = v_tema AND idNivel = v_nivel AND dsEstado = '1';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_partida_iniciar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_partida_iniciar`(IN p_idUsuario INT, IN p_idTema INT, IN p_idNivel INT, IN p_total INT)
BEGIN
    DECLARE v_orden INT DEFAULT NULL;
    DECLARE v_prev INT DEFAULT NULL;
    SELECT nuOrden INTO v_orden FROM niveles WHERE id = p_idNivel;
    SELECT id INTO v_prev FROM niveles WHERE nuOrden < v_orden ORDER BY nuOrden DESC LIMIT 1;
    IF v_prev IS NOT NULL AND NOT EXISTS(SELECT 1 FROM partidas WHERE idUsuario = p_idUsuario AND idTema = p_idTema AND idNivel = v_prev AND nuAprobado = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nivel bloqueado';
    END IF;
    INSERT INTO partidas (idUsuario, idTema, idNivel, nuTotalPreguntas) VALUES (p_idUsuario, p_idTema, p_idNivel, p_total);
    SELECT LAST_INSERT_ID() AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_partida_resultado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_partida_resultado`(IN p_idPartida INT, IN p_idUsuario INT)
BEGIN
    SELECT pa.id, pa.idTema, pa.idNivel, t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           pa.nuTotalPreguntas, pa.nuAciertos, pa.nuPuntos, pa.nuPorcentaje, pa.nuAprobado, pa.nuSegundosTotal,
           n.nuPorcentajeAprobacion,
           IFNULL((SELECT id FROM niveles WHERE nuOrden > n.nuOrden ORDER BY nuOrden LIMIT 1), 0) AS idSiguienteNivel,
           ir.dsMensaje AS dsMensajeResultado, ir.dsRutaImagen AS dsImagenResultado,
           IFNULL(pr.id, 0) AS idPremio, pr.dsNombre AS dsPremioNombre, pr.dsRutaImagen AS dsPremioImagen, IFNULL(pr.nuPuntos, 0) AS nuPremioPuntos
    FROM partidas pa
    INNER JOIN temas t ON t.id = pa.idTema
    INNER JOIN niveles n ON n.id = pa.idNivel
    LEFT JOIN imagenes_resultado ir ON ir.id = (SELECT i.id FROM imagenes_resultado i
                                                 WHERE i.dsEstado = '1' AND i.nuPorcentajeMinimo <= pa.nuPorcentaje
                                                 ORDER BY i.nuPorcentajeMinimo DESC LIMIT 1)
    LEFT JOIN usuario_premios up ON up.idPartida = pa.id
    LEFT JOIN premios pr ON pr.id = up.idPremio
    WHERE pa.id = p_idPartida AND pa.idUsuario = p_idUsuario AND pa.dtFin IS NOT NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pregunta_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pregunta_actualizar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pregunta_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pregunta_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE preguntas SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pregunta_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pregunta_listar`(IN p_idTema INT, IN p_idNivel INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsTipo, p.dsEnunciado, p.nuPuntos, p.nuSegundos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM preguntas p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE (p_idTema IS NULL OR p.idTema = p_idTema) AND (p_idNivel IS NULL OR p.idNivel = p_idNivel)
    ORDER BY t.dsNombre, n.nuOrden, p.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pregunta_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pregunta_obtener`(IN p_id INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsTipo, p.dsEnunciado, p.nuPuntos, p.nuSegundos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM preguntas p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE p.id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pregunta_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pregunta_registrar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premios_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premios_usuario`(IN p_idUsuario INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsNombre, p.dsDescripcion, p.dsRutaImagen, p.nuPuntos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM usuario_premios up
    INNER JOIN premios p ON p.id = up.idPremio
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE up.idUsuario = p_idUsuario
    ORDER BY up.dtObtenido DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premio_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premio_actualizar`(
    IN p_id INT, IN p_idTema INT, IN p_idNivel INT, IN p_nombre VARCHAR(80), IN p_descripcion VARCHAR(255),
    IN p_ruta VARCHAR(255), IN p_puntos INT, IN p_modificador VARCHAR(100))
BEGIN
    UPDATE premios
    SET idTema = p_idTema, idNivel = p_idNivel, dsNombre = p_nombre, dsDescripcion = p_descripcion,
        dsRutaImagen = IFNULL(p_ruta, dsRutaImagen), nuPuntos = p_puntos, dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premio_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premio_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE premios SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premio_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premio_listar`()
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsNombre, p.dsDescripcion, p.dsRutaImagen, p.nuPuntos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM premios p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    ORDER BY t.dsNombre, n.nuOrden;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premio_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premio_obtener`(IN p_id INT)
BEGIN
    SELECT p.id, p.idTema, p.idNivel, p.dsNombre, p.dsDescripcion, p.dsRutaImagen, p.nuPuntos, p.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel
    FROM premios p
    INNER JOIN temas t ON t.id = p.idTema
    INNER JOIN niveles n ON n.id = p.idNivel
    WHERE p.id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_premio_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_premio_registrar`(
    IN p_idTema INT, IN p_idNivel INT, IN p_nombre VARCHAR(80), IN p_descripcion VARCHAR(255),
    IN p_ruta VARCHAR(255), IN p_puntos INT, IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO premios (idTema, idNivel, dsNombre, dsDescripcion, dsRutaImagen, nuPuntos, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_idTema, p_idNivel, p_nombre, p_descripcion, p_ruta, p_puntos, p_creador, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ranking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ranking`(IN p_idTema INT)
BEGIN
    SELECT u.id AS idUsuario, u.dsNombre, av.dsRutaImagen AS dsRutaAvatar,
           IFNULL(pp.puntos, 0) + IFNULL(pr.puntos, 0) AS nuPuntos,
           IFNULL(ap.aprobados, 0) AS nuNivelesAprobados,
           IFNULL(pr.premios, 0) AS nuPremios
    FROM usuarios u
    INNER JOIN (SELECT DISTINCT idUsuario FROM partidas WHERE dtFin IS NOT NULL AND (p_idTema IS NULL OR idTema = p_idTema)) j ON j.idUsuario = u.id
    LEFT JOIN avatares av ON av.id = u.idAvatar AND av.dsEstado = '1'
    LEFT JOIN (SELECT idUsuario, SUM(mejor) AS puntos
               FROM (SELECT idUsuario, idTema, idNivel, MAX(nuPuntos) AS mejor FROM partidas
                      WHERE dtFin IS NOT NULL AND (p_idTema IS NULL OR idTema = p_idTema) GROUP BY idUsuario, idTema, idNivel) m
               GROUP BY idUsuario) pp ON pp.idUsuario = u.id
    LEFT JOIN (SELECT up.idUsuario, SUM(p.nuPuntos) AS puntos, COUNT(*) AS premios FROM usuario_premios up
               INNER JOIN premios p ON p.id = up.idPremio WHERE (p_idTema IS NULL OR p.idTema = p_idTema) GROUP BY up.idUsuario) pr ON pr.idUsuario = u.id
    LEFT JOIN (SELECT idUsuario, COUNT(*) AS aprobados
               FROM (SELECT DISTINCT idUsuario, idTema, idNivel FROM partidas WHERE nuAprobado = 1 AND (p_idTema IS NULL OR idTema = p_idTema)) d
               GROUP BY idUsuario) ap ON ap.idUsuario = u.id
    WHERE u.dsEstado = '1'
    ORDER BY nuPuntos DESC, nuNivelesAprobados DESC, u.dsNombre
    LIMIT 200;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_avance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_avance`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_distribucion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_distribucion`()
BEGIN
    SELECT n.id AS idNivel, n.dsNombre, n.nuOrden, COUNT(m.idUsuario) AS nuJugadores
    FROM niveles n
    LEFT JOIN (SELECT p.idUsuario, MAX(nv.nuOrden) AS ord
               FROM partidas p INNER JOIN niveles nv ON nv.id = p.idNivel
               WHERE p.dtFin IS NOT NULL
               GROUP BY p.idUsuario) m ON m.ord = n.nuOrden
    GROUP BY n.id, n.dsNombre, n.nuOrden
    ORDER BY n.nuOrden;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_resumen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_resumen`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_respuesta_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_respuesta_registrar`(
    IN p_idPartida INT, IN p_idPregunta INT, IN p_idOpcion INT, IN p_correcta TINYINT, IN p_segundos INT)
BEGIN
    INSERT INTO respuestas (idPartida, idPregunta, idOpcion, nuEsCorrecta, nuSegundos)
    VALUES (p_idPartida, p_idPregunta, p_idOpcion, p_correcta, p_segundos);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_actualizar`(
    IN p_id INT, IN p_nombre VARCHAR(100), IN p_idTema INT, IN p_idNivel INT, IN p_cantidad INT)
BEGIN
    UPDATE sets_qr SET dsNombre = p_nombre, idTema = p_idTema, idNivel = p_idNivel, nuCantidadPreguntas = p_cantidad WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_asignar_partida` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_asignar_partida`(IN p_idPartida INT, IN p_idUsuario INT, IN p_idSetQr INT)
BEGIN
    UPDATE partidas SET idSetQr = p_idSetQr
    WHERE id = p_idPartida AND idUsuario = p_idUsuario AND idSetQr IS NULL AND dtFin IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1))
BEGIN
    UPDATE sets_qr SET dsEstado = p_estado WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_listar`()
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    ORDER BY s.dtFechaCreacion DESC, s.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_obtener`(IN p_id INT)
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    WHERE s.id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_por_codigo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_por_codigo`(IN p_codigo VARCHAR(36))
BEGIN
    SELECT s.id, s.dsCodigo, s.dsNombre, s.idTema, s.idNivel, s.nuCantidadPreguntas, s.dsEstado,
           t.dsNombre AS dsNombreTema, n.dsNombre AS dsNombreNivel,
           (SELECT COUNT(*) FROM partidas p WHERE p.idSetQr = s.id) AS nuPartidas
    FROM sets_qr s
    INNER JOIN temas t ON t.id = s.idTema
    INNER JOIN niveles n ON n.id = s.idNivel
    WHERE s.dsCodigo = p_codigo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_setqr_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setqr_registrar`(
    IN p_codigo VARCHAR(36), IN p_nombre VARCHAR(100), IN p_idTema INT, IN p_idNivel INT, IN p_cantidad INT, IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO sets_qr (dsCodigo, dsNombre, idTema, idNivel, nuCantidadPreguntas, dsUsuarioCreacion)
    VALUES (p_codigo, p_nombre, p_idTema, p_idNivel, p_cantidad, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tema_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tema_actualizar`(IN p_id INT, IN p_nombre VARCHAR(60), IN p_descripcion VARCHAR(255), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE temas SET dsNombre = p_nombre, dsDescripcion = p_descripcion, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tema_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tema_cambiar_estado`(IN p_id INT, IN p_estado CHAR(1), IN p_modificador VARCHAR(100))
BEGIN
    UPDATE temas SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tema_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tema_listar`()
BEGIN
    SELECT id, dsNombre, dsDescripcion, dsEstado FROM temas ORDER BY dsNombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tema_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tema_obtener`(IN p_id INT)
BEGIN
    SELECT id, dsNombre, dsDescripcion, dsEstado FROM temas WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_tema_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tema_registrar`(IN p_nombre VARCHAR(60), IN p_descripcion VARCHAR(255), IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO temas (dsNombre, dsDescripcion, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_nombre, p_descripcion, p_creador, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_actualizar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_cambiar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_cambiar_estado`(
    IN p_id          INT,
    IN p_estado      CHAR(1),
    IN p_modificador VARCHAR(100))
BEGIN
    UPDATE usuarios
    SET dsEstado = p_estado, dsUsuarioModificacion = p_modificador
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_listar`()
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsRol, dsEstado, idAvatar
    FROM usuarios
    ORDER BY id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_obtener` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_obtener`(IN p_id INT)
BEGIN
    SELECT id, dsCedula, dsNombre, dsCorreo, dsRol, dsEstado, idAvatar
    FROM usuarios
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_registrar`(
    IN p_cedula  VARCHAR(20),
    IN p_nombre  VARCHAR(100),
    IN p_correo  VARCHAR(100),
    IN p_hash    VARCHAR(255),
    IN p_rol     VARCHAR(10),
    IN p_creador VARCHAR(100))
BEGIN
    INSERT INTO usuarios (dsCedula, dsNombre, dsCorreo, dsPassword, dsRol, dsUsuarioCreacion, dsUsuarioModificacion)
    VALUES (p_cedula, p_nombre, p_correo, p_hash, p_rol, p_creador, p_creador);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-23  0:43:37
