CREATE DATABASE  IF NOT EXISTS `po` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `po`;
-- MySQL dump 10.13  Distrib 5.5.24, for osx10.5 (i386)
--
-- Host: localhost    Database: po
-- ------------------------------------------------------
-- Server version	5.5.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `barns`
--

DROP TABLE IF EXISTS `barns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `barns` (
  `barn_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `postcode` varchar(10) NOT NULL,
  `state` varchar(5) NOT NULL,
  `description` text NOT NULL,
  `indoor_features` varchar(255) DEFAULT NULL,
  `outdoor_features` varchar(255) DEFAULT NULL,
  `other_features` varchar(255) DEFAULT NULL,
  `feature_image` varchar(100) NOT NULL,
  `listed_by` int(11) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`barn_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barns`
--

LOCK TABLES `barns` WRITE;
/*!40000 ALTER TABLE `barns` DISABLE KEYS */;
/*!40000 ALTER TABLE `barns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deals`
--

DROP TABLE IF EXISTS `deals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deals` (
  `deal_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) DEFAULT NULL,
  `owl_id` mediumint(8) unsigned NOT NULL,
  `created_by` mediumint(8) unsigned NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  `deal_type_id` int(11) DEFAULT '6',
  PRIMARY KEY (`deal_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deals`
--

LOCK TABLES `deals` WRITE;
/*!40000 ALTER TABLE `deals` DISABLE KEYS */;
INSERT INTO `deals` VALUES (9,'afo',10,1,10000,6),(13,'stamp duty',17,1,20000,6),(14,'stamp',17,1,30000,6),(15,'5% off the list price when 5 are sold',2,1,30000,6);
/*!40000 ALTER TABLE `deals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `development_statuses`
--

DROP TABLE IF EXISTS `development_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `development_statuses` (
  `development_status_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`development_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `development_statuses`
--

LOCK TABLES `development_statuses` WRITE;
/*!40000 ALTER TABLE `development_statuses` DISABLE KEYS */;
INSERT INTO `development_statuses` VALUES (1,'Complete'),(2,'Off The Plan');
/*!40000 ALTER TABLE `development_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `development_types`
--

DROP TABLE IF EXISTS `development_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `development_types` (
  `development_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`development_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `development_types`
--

LOCK TABLES `development_types` WRITE;
/*!40000 ALTER TABLE `development_types` DISABLE KEYS */;
INSERT INTO `development_types` VALUES (1,'House'),(2,'Townhouse'),(3,'Unit'),(4,'Apartment'),(5,'Land'),(6,'House & Land'),(7,'Vila'),(8,'Acerage');
/*!40000 ALTER TABLE `development_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medias`
--

DROP TABLE IF EXISTS `medias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medias` (
  `media_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` mediumint(8) unsigned NOT NULL,
  `owner_id` mediumint(8) unsigned NOT NULL,
  `filename` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `image` tinyint(1) NOT NULL DEFAULT '0',
  `hero` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`media_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medias`
--

LOCK TABLES `medias` WRITE;
/*!40000 ALTER TABLE `medias` DISABLE KEYS */;
INSERT INTO `medias` VALUES (11,9,1,'8ad19750-2945-11e2-b4bc-5f66e9f836b9.jpg','',1,1,'2012-11-23 22:04:42','0000-00-00 00:00:00'),(12,9,1,'ea037e10-3394-11e2-bad3-cd982acbcfc3.JPG','photo.JPG',0,0,'2012-11-21 04:35:44','0000-00-00 00:00:00'),(13,9,1,'d77d3cf0-3460-11e2-a1c1-75b0dcd6ca17.png','profile-pic.png',1,0,'2012-11-23 22:04:42','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `medias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owls`
--

DROP TABLE IF EXISTS `owls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `owls` (
  `owl_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `postcode` varchar(10) NOT NULL,
  `state` varchar(5) NOT NULL,
  `description` text NOT NULL,
  `development_type_id` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '0',
  `bedrooms` int(11) NOT NULL DEFAULT '0',
  `bathrooms` int(11) NOT NULL DEFAULT '0',
  `cars` int(11) NOT NULL DEFAULT '0',
  `development_stage` varchar(100) NOT NULL,
  `level` int(11) DEFAULT NULL,
  `internal_area` int(11) NOT NULL,
  `external_area` int(11) NOT NULL,
  `aspect` enum('north','south','east','west','north-east','north-west','south-east','sout-west') DEFAULT NULL,
  `indoor_features` varchar(255) DEFAULT NULL,
  `outdoor_features` varchar(255) DEFAULT NULL,
  `other_features` varchar(255) DEFAULT NULL,
  `feature_image` varchar(100) NOT NULL,
  `barn_id` int(11) DEFAULT NULL,
  `listed_by` mediumint(8) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`owl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owls`
--

LOCK TABLES `owls` WRITE;
/*!40000 ALTER TABLE `owls` DISABLE KEYS */;
INSERT INTO `owls` VALUES (1,'deal of a lifetime!','123 example street','ippy','4000','qld','This is a once in a life time opportunity',6,345000,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-08 19:49:47','0000-00-00 00:00:00'),(3,'Blue wonder','11 Caithness Street','cairns','4524','nsw','some descriptive description',3,1341411,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,0,NULL,'2012-10-19 09:54:52','0000-00-00 00:00:00'),(4,'Cold estate','27 Mansion Court','spainland','5252','vic','some descriptive description',3,1341411,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-19 09:54:52','0000-00-00 00:00:00'),(5,'Title','12 Karen Court','the switch','5252','nt','some descriptive description',3,1341411,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-19 09:54:52','0000-00-00 00:00:00'),(6,'Wow, awesome!','9 Ellie Court','grillin\'','1722','wa','some descriptive description',3,1341411,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-19 09:54:52','0000-00-00 00:00:00'),(7,'LOCATION LOCATION LOCATION','26 Kurrajong Street','supsville','7277','sa','some descriptive description',3,1341411,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-19 09:54:52','0000-00-00 00:00:00'),(8,'Some final entry','123 example street','foobartown','7572','tas','This is a once in a life time opportunity',1,345000,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,1,1,NULL,'2012-10-08 19:49:47','0000-00-00 00:00:00'),(9,'Foobar','12 fazcvn street','pleasentville','4524','qld','this is a foobar',1,140000,1,1,1,'',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,2,1,NULL,'2012-11-06 18:32:56','0000-00-00 00:00:00'),(10,'Redbank Plains','12 Karen Corut','Redbank Plains','1442','qld','This is a redbank plains',1,900000,1,1,1,'completed',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,2,1,NULL,'2012-11-08 22:34:19','0000-00-00 00:00:00'),(17,'Dont buy it','12 Bell Street','Ipswich','2134','qld','Dont buy this place.',1,493100,1,1,1,'otp',NULL,0,0,NULL,NULL,NULL,NULL,'',NULL,2,1,NULL,'2012-11-21 12:06:27','0000-00-00 00:00:00'),(18,'Public-key local installation','4186 Gottlieb Haven','Valliemouth','2652','act','beatae et modi rerum ea consequatur sunt\r\nquo est facilis\r\nea eligendi mollitia corporis ut quo aut nostrum\r\nitaque est facilis voluptatum nam minima\r\n \r\n	totam sapiente labore neque minima vitae atque soluta\r\neaque ex qui et\r\ndistinctio in dolores ea perspiciatis aut libero\r\nest qui repellendus consequatur impedit facilis repudiandae aut\r\nquo molestiae excepturi quia modi\r\nfugit id et enim hic qui autem\r\n \r\n	et reiciendis quia\r\ndoloribus quis dolore assumenda quo nam consectetur nulla\r\ncumque non omnis itaque quaerat\r\nrepellat dolorem laboriosam voluptatibus nesciunt quae harum\r\nest repudiandae sit fugit minus rerum natus voluptate\r\nad sed esse eius\r\n \r\n	error illo omnis ratione ullam iste molestiae alias\r\ndicta sequi cupiditate sed et ducimus ratione occaecati ut\r\nut veritatis iusto dolor explicabo voluptas eligendi\r\nquos suscipit labore sunt\r\ntotam nulla asperiores sit\r\ntotam iusto alias cumque quia soluta at quod',1,39092631,1,0,3,'',NULL,3182928,97633732,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:18:00','0000-00-00 00:00:00'),(19,'Horizontal multi-tasking service-desk','1734 Ondricka Neck','Lake Gardner','8236','tas','quos sed laudantium cumque\r\nomnis exercitationem sapiente\r\nsint itaque voluptate et eveniet voluptatem mollitia\r\nquis nihil ipsa illo voluptas cupiditate accusamus odit itaque\r\nrerum aut perferendis nostrum enim\r\n \r\n	corporis velit illo sequi ut molestiae\r\nid impedit nulla deleniti sint qui\r\ndolores minus voluptatem quasi qui necessitatibus at\r\nnemo hic est totam tempora rem\r\nnulla vel velit minus molestiae id quis nobis\r\ndolores excepturi repellat\r\n \r\n	est sed ad\r\nexercitationem dolore quo quae dolor\r\nconsequatur ullam sapiente voluptates quisquam laboriosam assumenda quos\r\ndistinctio voluptatem et\r\n \r\n	et accusamus et quae voluptate iure voluptates\r\naliquid voluptatem quia sunt hic voluptatibus\r\ncommodi consequatur libero omnis sequi voluptas voluptatem\r\nesse exercitationem et incidunt cum dicta nam ut ea\r\ninventore porro at consequatur debitis assumenda non\r\nvelit itaque voluptatem',1,3419769,0,1,0,'',NULL,78448608,24126727,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:20:55','0000-00-00 00:00:00'),(20,'Re-contextualized non-volatile projection','24955 Labadie Forest','New Cara','4488','nsw','perferendis id veniam sequi eveniet et\r\nsoluta mollitia modi pariatur nam qui placeat\r\ndignissimos quaerat nulla earum consectetur ex quos\r\nmolestiae laboriosam tempore dolores maxime\r\n \r\n	perferendis ipsa ut pariatur adipisci non et\r\nquas aperiam consequatur aut ipsum est dolor\r\nmollitia porro qui\r\nlaboriosam a laudantium\r\nnobis quibusdam eius corrupti est iure autem\r\nratione sint ut omnis qui numquam odio porro\r\n \r\n	veniam nihil fugit nam ab et labore\r\nquos quibusdam unde voluptas et\r\nexercitationem aliquam dolore est qui ut dolorum fuga vel\r\nmollitia distinctio corporis alias commodi fugiat\r\n \r\n	omnis ullam commodi dolor sit omnis\r\ntempora quia recusandae quis ex culpa tenetur ullam\r\nrerum vero nam quia dicta nesciunt occaecati\r\nimpedit harum adipisci occaecati necessitatibus ipsum\r\ndolores aut dicta et alias rem',1,9192608,5,3,5,'',NULL,12550169,80726930,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:22:13','0000-00-00 00:00:00'),(21,'Triple-buffered zero defect info-mediaries','4141 Franecki Station','West Noelview','3761','wa','maiores qui doloremque\r\nqui dolor et necessitatibus quis in enim odit\r\ndolor iste quos\r\ndolores vitae omnis sequi nobis\r\n \r\n	commodi illo odit animi est rem\r\nvoluptatem ab asperiores incidunt officiis qui\r\nea beatae quo optio sit quis animi blanditiis\r\nenim doloremque eos ipsa nulla voluptas laboriosam consequuntur\r\n \r\n	accusantium vitae delectus placeat cupiditate et\r\neligendi ducimus quidem sunt commodi delectus ut\r\ndoloremque harum aspernatur\r\nlaborum dolores tempore quaerat quae eum rerum debitis\r\net corrupti fugit quia\r\n \r\n	praesentium ut et quo iusto\r\nsunt ex illo et consequuntur quis in tempore commodi\r\naut odit quod voluptatum iure\r\nalias earum ullam sit doloremque',1,33433725,1,4,1,'',NULL,56250492,73057121,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:23:11','0000-00-00 00:00:00'),(22,'Robust client-driven core','5387 Stanton Ridges','Baileymouth','0323','vic','qui voluptatum quia quidem\r\neaque dicta expedita qui\r\nsequi eos eius\r\neveniet fuga rerum ut distinctio ratione et consequatur\r\n \r\n	labore autem dignissimos quas repellendus\r\nsit aut quia dolorem necessitatibus qui debitis\r\nenim beatae pariatur sint\r\nest sunt et velit dolor architecto accusamus facere\r\ntemporibus optio quasi eaque voluptatum sint quia consequatur in\r\nquaerat quibusdam natus magni id autem asperiores numquam\r\n \r\n	dolores ea qui non accusamus\r\nut ratione corrupti in necessitatibus qui et dolore\r\nvel libero eum omnis et reprehenderit\r\ntotam exercitationem quis magni suscipit laboriosam sapiente atque quisquam\r\narchitecto voluptas sapiente ducimus error illum nam\r\nut suscipit quos est\r\n \r\n	et quia eos\r\nsed alias quos voluptas porro\r\nodio at vel quis cum vero atque\r\nvoluptates natus est molestiae\r\nea omnis praesentium repellat repellendus voluptate non sit\r\nquia alias nobis',1,6870724,5,5,2,'',NULL,75220661,32896811,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:23:22','0000-00-00 00:00:00'),(23,'Realigned optimal moderator','98658 Sporer Divide','North Shanel','7371','act','ut suscipit provident minus harum hic incidunt\r\nvoluptatem fuga delectus eligendi inventore omnis\r\ndolor ab alias\r\nquia saepe nihil quia ab rem expedita dolorem\r\nrepellat quasi ipsam magnam\r\n \r\n	sed similique omnis autem dolores sed repudiandae\r\nqui beatae et esse optio\r\nprovident qui aperiam a\r\narchitecto doloremque iure doloribus\r\ncommodi qui et\r\nmagni numquam tempore quam\r\n \r\n	beatae vel sunt est ducimus ut\r\nducimus illo veniam est\r\nsed quia veritatis provident\r\nofficiis iure laboriosam\r\nut commodi aspernatur pariatur quo vel\r\noccaecati molestiae fuga asperiores ut\r\n \r\n	ducimus debitis voluptatum maiores ea est assumenda porro\r\nrem quisquam quaerat natus consequatur sed odit\r\ndeserunt assumenda corporis nesciunt laudantium fugit\r\nlibero aut delectus odit vero rerum\r\naliquam reiciendis voluptatem autem et quia iste nobis at\r\nsunt reiciendis porro',1,71595079,3,2,0,'',NULL,58206912,80243557,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:23:52','0000-00-00 00:00:00'),(25,'Multi-lateral hybrid framework','02070 Gerlach Orchard','Port Leonmouth','0040','vic','nemo aliquam adipisci beatae necessitatibus nihil facere repellendus\r\narchitecto non cum non quis quisquam\r\nvoluptatem voluptates mollitia\r\ndolore in commodi hic et quasi labore eum\r\nvoluptatum similique sit\r\nexplicabo illo totam\r\n \r\n	animi occaecati alias quis maiores beatae vel\r\nvoluptatem ipsum sunt dicta nesciunt quidem eum quos ut\r\nratione porro rem sint\r\nullam ut aliquam dolorem cumque illum nulla delectus\r\nin officia odit sequi\r\nomnis illum nisi velit perspiciatis necessitatibus\r\n \r\n	deleniti asperiores quia omnis\r\net quo sint libero quae\r\nnemo qui in dolores quam\r\nillo in ipsa sequi omnis fugiat tempora rerum odio\r\naliquam sed fugit\r\nautem asperiores impedit\r\n \r\n	necessitatibus illum sequi odit pariatur eum perspiciatis rerum aut\r\ndolorum praesentium nobis quidem\r\ncum odit dignissimos et iste et amet ab cumque\r\nculpa repellendus rerum excepturi velit enim neque provident',1,49708717,0,4,1,'',NULL,86055691,96764832,NULL,NULL,NULL,NULL,'',NULL,0,0,NULL,'2012-12-03 06:52:29','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `owls` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER owl_creation_timestamp
BEFORE INSERT ON owls
FOR EACH ROW
SET NEW.created_at = NOW() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `po_account_types`
--

DROP TABLE IF EXISTS `po_account_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_account_types` (
  `account_type_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`account_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_account_types`
--

LOCK TABLES `po_account_types` WRITE;
/*!40000 ALTER TABLE `po_account_types` DISABLE KEYS */;
INSERT INTO `po_account_types` VALUES (1,'Potential Buyer',''),(2,'Property Developer',''),(3,'Administrator','');
/*!40000 ALTER TABLE `po_account_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_admin_pages`
--

DROP TABLE IF EXISTS `po_admin_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_admin_pages` (
  `admin_page_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`admin_page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_admin_pages`
--

LOCK TABLES `po_admin_pages` WRITE;
/*!40000 ALTER TABLE `po_admin_pages` DISABLE KEYS */;
INSERT INTO `po_admin_pages` VALUES (1,'News','news',1),(2,'Members','members',1),(3,'Services','services',1),(4,'Custom Pages','pages',1),(5,'Properties','properties',1),(7,'Reports','reports',1);
/*!40000 ALTER TABLE `po_admin_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_adspaces`
--

DROP TABLE IF EXISTS `po_adspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_adspaces` (
  `adspace_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`adspace_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_adspaces`
--

LOCK TABLES `po_adspaces` WRITE;
/*!40000 ALTER TABLE `po_adspaces` DISABLE KEYS */;
INSERT INTO `po_adspaces` VALUES (1,'Top'),(2,'Upper Tower'),(3,'Lower Tower'),(4,'Upper Box'),(5,'Lower Box');
/*!40000 ALTER TABLE `po_adspaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_advertisements`
--

DROP TABLE IF EXISTS `po_advertisements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_advertisements` (
  `advertisement_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `advertiser_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `adspace_id` int(11) NOT NULL,
  `image_id` varchar(100) NOT NULL,
  `hyperlink` varchar(100) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `start` datetime NOT NULL,
  `stop` varchar(45) NOT NULL,
  PRIMARY KEY (`advertisement_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_advertisements`
--

LOCK TABLES `po_advertisements` WRITE;
/*!40000 ALTER TABLE `po_advertisements` DISABLE KEYS */;
INSERT INTO `po_advertisements` VALUES (8,'St George Bank',18,2,1,'b81b3681-bcaa-44ba-8077-876265c979c2','http://www.stgeorge.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00',''),(7,'Westpac \"X-mas\" 2012 Campaign',18,1,1,'132c023f-2e01-49b9-8122-dc7bfc92c269','http://westpac.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','');
/*!40000 ALTER TABLE `po_advertisements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_advertisers`
--

DROP TABLE IF EXISTS `po_advertisers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_advertisers` (
  `advertiser_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `contactee` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `postcode` varchar(100) NOT NULL,
  `advertiser_created_at` datetime NOT NULL,
  PRIMARY KEY (`advertiser_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_advertisers`
--

LOCK TABLES `po_advertisers` WRITE;
/*!40000 ALTER TABLE `po_advertisers` DISABLE KEYS */;
INSERT INTO `po_advertisers` VALUES (18,'INC','Australia\'s largest retail advertising network','Luke Hillier','luke.hillier@inc.co','(03) 9016 7943','31 Coventry St','South Melbourne','Victoria','3205','2012-11-26 22:44:07');
/*!40000 ALTER TABLE `po_advertisers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_bookmarks`
--

DROP TABLE IF EXISTS `po_bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_bookmarks` (
  `bookmark_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` mediumint(8) unsigned NOT NULL,
  `type` varchar(50) NOT NULL,
  `resource_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`bookmark_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_bookmarks`
--

LOCK TABLES `po_bookmarks` WRITE;
/*!40000 ALTER TABLE `po_bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `po_bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_deal_types`
--

DROP TABLE IF EXISTS `po_deal_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_deal_types` (
  `deal_type_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`deal_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_deal_types`
--

LOCK TABLES `po_deal_types` WRITE;
/*!40000 ALTER TABLE `po_deal_types` DISABLE KEYS */;
INSERT INTO `po_deal_types` VALUES (1,'Stamp Duty'),(2,'Furniture Package'),(3,'Blinds'),(4,'Rental Guarantee'),(5,'Entertainment System'),(6,'Other');
/*!40000 ALTER TABLE `po_deal_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_news`
--

DROP TABLE IF EXISTS `po_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_news` (
  `news_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` mediumtext NOT NULL,
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `news_type` enum('news','research') NOT NULL DEFAULT 'news',
  PRIMARY KEY (`news_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_news`
--

LOCK TABLES `po_news` WRITE;
/*!40000 ALTER TABLE `po_news` DISABLE KEYS */;
INSERT INTO `po_news` VALUES (1,1,'test','hello this is a test post woo!','2012-11-29 02:22:25','news');
/*!40000 ALTER TABLE `po_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_pages`
--

DROP TABLE IF EXISTS `po_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_pages` (
  `page_id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(100) NOT NULL,
  `header` varchar(100) NOT NULL,
  `content` mediumtext NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `page_created_at` datetime NOT NULL,
  `static` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_pages`
--

LOCK TABLES `po_pages` WRITE;
/*!40000 ALTER TABLE `po_pages` DISABLE KEYS */;
INSERT INTO `po_pages` VALUES (1,'/about','About Property Owl','<p>Propertyowl.com.au was established by a group of real estate and marketing professionals to assist buyers of residential property access to the best discounts, offers, deals or incentives that a residential property developer (seller) will provide.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is Australia\'s first to provide residential property developers with their own unique website platform specifically developed to showcase and sell their products without being lost amongst the thousands of private sellers of homes, land, apartments, units, townhouses, etc.\r\n</p>\r\n<p>\r\nThe website allows property developers a greater reach to larger audiences of prospective buyers who have a particular interest in new properties.\r\n</p>\r\n<p>\r\nThe propertyowl.com.au website provides our subscribers with genuine deals without having to cut through the noise of advertising, marketing hype and pushy sales people.\r\n</p>\r\n<p>\r\nThe website has been developed to provide full disclosure of all known information relating to a residential product/development either \'off the plan\' or \'completed\' so that our registered subscribers to propertyowl.com.au can make informed buying decisions, whilst also taking advantage of the great deals on offer.\r\n</p>\r\n<p>\r\nPropertyowl.com.au uses its best endeavours to obtain all known information that relates to specific residential developments advertised on the website. We value the feedback that you provide us as it enables us to constantly improve our site.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is committed to enriching the lives of Australians through its support of charitable organisations and innovative programs to build strong and nurturing communities.\r\n</p>',1,'2012-11-05 12:10:22',1),(2,'/terms-and-conditions','Terms and Conditions','<h2>1 Introduction</h2>\r\n<p>These terms and conditions, together with the Property Owl Pty Ltd Privacy Policy and any additional terms, conditions, notices and disclaimers displayed elsewhere on the website govern your use of and access to propertyowl.com.au.</p>\r\n<p>Property Owl Pty Ltd may change all or part of these Terms and Conditions at any time. Any changes to the Terms and Conditions will be posted on the propertyowl.com.au website. Your subsequent or continued use of the propertyowl.com.au website will constitute your acceptance of any changes made to the Terms and Conditions. If you object to the Terms and Conditions of Use or changes made to the Terms and Conditions, your only remedy is to immediately discontinue your use of the propertyowl.com.au website.</p>\r\n<p>These terms and conditions of use were last updated on 26 October 2012.</p>\r\n<h2>2 PropertyOwl.com.au Website</h2>\r\n<p>At Property Owl Pty Ltd we make every reasonable endeavor to ensure that the website is available at all times. Property Owl Pty Ltd does not make any representations or warranties that your access to the website will be uninterrupted, timely, secure or error free. Your access to the propertyowl.com.au website may be suspended without notice in the case of system failure, maintenance or repair or any other reason beyond our control.</p>\r\n<p>Except as expressly provided otherwise within these Terms and Conditions, we reserve the right to change or discontinue the website, feature or service (or part thereof) displayed on propertyowl.com.au at any time.</p>\r\n<p>Except as expressly provided otherwise in the Terms and Conditions we reserve the right to change the pricing for any chargeable service or feature on propertyowl.com.au at any time without having to provide any notice to you.</p>\r\n<h2>3 Membership Registration</h2>\r\n<p>To access or use certain parts of the property owl website, you must register as a member.</p><p>Registration is free.</p>\r\n<p>When registering as a member, you must provide us with accurate, complete, and up-to-date registration information as requested. It is your responsibility to inform us of any changes to your registration information. If propertyowl.com.au approves registration, we will require you to confirm your identity and acceptance of these Terms and Conditions.</p>\r\n<p>You must not register as a member multiple times.</p>\r\n<p>You must not impersonate or create a membership for any person other than yourself.</p>\r\n<p>We may at any time request a form of identification to verify your identity. In the event that you fail or refuse to provide the requested form of identification then we may, at our absolute discretion suspend or terminate any membership you have registered.</p>\r\n<p>You must ensure the security and confidentiality of your membership details, including any username and/or password assigned to you. You are wholly responsible for all activities which occur under your membership details (including unauthorised use of your credit card). You must notify us immediately if you become aware of any unauthorised use of your membership details. You must not permit your membership details to be used by or transferred to any other person.</p>\r\n<p>We reserve the right to, in our sole discretion, suspend or terminate your membership or access to all or any part of the propertyowl.com.au website, including if we believe you are abusing the services in any way, have breached the Terms and Conditions or are no longer an active member.</p>\r\n<h2>4 Your conduct</h2>\r\n<p>You must not:</p>\r\n<ol><li>use the property owl website in breach of any applicable laws or regulations;</li>\r\n<li>use the property owl website (or Material obtained from the propertyowl.com.au website):\r\n<ol type=\"a\"><li>to transmit (or authorise the transmission of) \"junk mail,\" \"chain letters,\" unsolicited emails, instant messaging, \"spimming,\" or \"spamming\";</li>\r\n<li>to impersonate any person or entity;</li>\r\n<li>to solicit money, passwords or personal information from any person;</li>\r\n<li>to harm, abuse, harass, stalk, threaten or otherwise offend others;</li>\r\n<li>or for any unlawful purpose;</li></ol></li>\r\n<li>use the property owl website to upload, post, transmit or otherwise make available (or attempt to upload, post, transmit or otherwise make available) any Material that:\r\n<ol type=\"a\">\r\n<li>is not your original work, or which in any way violates or infringes (or could reasonably be expected to violate or infringe) the intellectual property or other rights of another person;</li>\r\n<li>contains, promotes, or provides information about unlawful activities or conduct;</li>\r\n<li>is, or could reasonably be expected to be, defamatory, obscene, offensive, threatening, abusive, pornographic, vulgar, profane, indecent or otherwise unlawful, including Material that racially or religiously vilifies, incites violence or hatred, or is likely to offend, insult or humiliate others based on race, religion, ethnicity, gender, age, sexual orientation or any physical or mental disability;</li>\r\n<li>exploits another person in any manner;</li>\r\n<li>contains nudity, excessive violence, or sexual acts or references;</li>\r\n<li>includes an image or personal information of another person or persons unless you have their consent;</li>\r\n<li>poses or creates a privacy or security risk to any person;</li>\r\n<li>you know or suspect (or ought reasonably to have known or suspected) to be false, misleading or deceptive;</li>\r\n<li>contains large amounts of untargeted, unwanted or repetitive content;</li>\r\n<li>contains restricted or password only access pages, or hidden content;</li>\r\n<li>contains viruses, or other computer codes, files or programs designed to interrupt, limit or destroy the functionality of other computer software or hardware;</li>\r\n<li>advertises, promotes or solicits any goods or services or commercial activities (except where expressly permitted or authorised by us); or</li>\r\n<li>contains financial, legal, medical or other professional advice;</li></ol></li>\r\n<li>interfere with, disrupt, or create an undue burden on the propertyowl.com.au website;</li>\r\n<li>use any robot, spider, or other device or process to retrieve, index, or in any way reproduce, modify or circumvent the navigational structure, security or presentation of the propertyowl.com.au website;</li>\r\n<li>use the propertyowl.com.au website with the assistance of any automated scripting tool or software;</li>\r\n<li>frame or mirror any part of the propertyowl.com.au website without our prior written authorisation;</li>\r\n<li>use code or other devices containing any reference to the property owl website to direct other persons to any other web page;</li>\r\n<li>except to the extent permitted by law, modify, adapt, sublicense, translate, sell, reverse engineer, decipher, decompile or otherwise disassemble any portion of the Property Owl website or cause any other person to do so; or</li>\r\n<li>delete any attributions or legal or proprietary notices on the Property Owl website.</li></ol>\r\n<h2>5 Your Material</h2>\r\n<p>By uploading, transmitting, posting or otherwise making available any Material via the Property Owl website, you:</p>\r\n<ol><li>grant us a non-exclusive, worldwide, royalty-free, perpetual, license to use, reproduce, edit and exploit the Material in any form and for any purpose;</li>\r\n<li>except where expressly stated otherwise, you also grant each user of the Property Owl website a non- exclusive, worldwide, royalty-free, perpetual, license to use, reproduce, edit and exploit the Material in any form for any purpose, subject to the Terms and Conditions;</li>\r\n<li>warrant that you have the right to grant the abovementioned licenses;</li>\r\n<li>warrant that the Material does not breach the Terms and Conditions; and</li>\r\n<li>unconditionally waive all moral rights (as defined by the Copyright Act 1968) which you may have in respect of the Material.</li></ol>\r\n<p>We reserve the right (but have no obligation) to:</p>\r\n<ol><li>review, modify, reformat, reject or remove any Material which you upload, post, transmit or otherwise make available (or attempt to upload, post, transmit or otherwise make available) that, in our opinion, violates the Terms and Conditions or otherwise has the potential to harm, endanger or violate the rights of any person; and</li>\r\n<li>monitor use of the Property Owl website, and store or disclose any information that we collect, including in order to investigate compliance with the Terms and Conditions or for the purposes of any police investigation or governmental request.</li></ol>\r\n<p>We are not responsible for, and accept no liability with respect to, any Material uploaded, posted, transmitted or otherwise made available on the Property Owl website by any person other than us. For the avoidance of doubt, we will not be taken to have uploaded, posted, transmitted or otherwise made Material available on the Property Owl website simply by facilitating others to post, transmit or other make Material available. Furthermore, we do not endorse any opinion, advice or statement made by any third person other than us.</p>\r\n<h2>6 Contacting us</h2>\r\n<p>If you think that the Property Owl website has been accessed or used by another user in breach of the Terms and Conditions, please email us at <a href=\"mailto:support@propertyowl.com.au?Subject=Property%20Owl%20Terms%20and%20Conditions%20Enquiry\">support@propertyowl.com.au</a> We will consider whether there are grounds for taking any action, but you will not necessarily be contacted as to our decision.</p>\r\n<p>In particular, if you wish to send us a copyright infringement notification, you must identify the Material(s) that you believe infringe(s) your copyright, identify each copyright protected work in which you own the rights and which you believe has been infringed, identify how each copyright protected work has been or is being infringed and include your contact information. You will need to sign the notice and send it to <a href=\"mailto:support@propertyowl.com.au?Subject=Property%20Owl%20Terms%20and%20Conditions%20Enquiry\">support@propertyowl.com.au</a>.</p>\r\n<h2>7 Intellectual Property</h2>\r\n<p>Except where expressly provided otherwise in the Terms and Conditions, you do not have any right, title or interest in or to any proprietary rights relating to the Property owl website.</p>\r\n<p>The Property Owl website contains Material that is protected by copyright, trade mark and other laws. Except where expressly provided otherwise in the Terms and Conditions, you may reproduce and display the Material on the Property Owl website for your own personal, non-commercial use only. Except for the temporary copy held in your computer\'s cache and a single permanent copy for your personal reference, the material may not otherwise be used, stored, reproduced, published, altered or transmitted in any form or by any means in whole or in part without our prior written approval or the written approval of our licensor.</p>\r\n<p>In particular, you may not use any Material on the Property Owl website to establish, maintain or provide, or assist in establishing, maintaining or providing your own publications, Internet site or other means of distribution.</p>\r\n<p>Nothing displayed on the Property Owl website should be construed as granting any right of use in relation to any logo, masthead or trade mark displayed on the Property Owl website without the express written consent of the relevant owner.</p>\r\n<h2>8 Third party websites, advertising and activities</h2>\r\n<p>We may feature or display links and pointers to websites operated by third parties on the Property Owl website. Such websites do not form part of the Property Owl website and are not under our control. We do not accept any responsibility in connection with any such website. If you link to any such websites, you leave the Property Owl website entirely at your own risk.</p>\r\n<p>You must not link to the Property Owl website from any other website (or otherwise authorise any other person to link from a third party website to the Property Owl website) without our prior written consent.</p>\r\n<p>The Property Owl website may feature or display third party advertising. By featuring or displaying such advertising, we do not in any way represent that we recommend or endorse the relevant advertiser, its products or services.</p>\r\n<p>If you contact a third party using functionality provided on the Property Owl website, including via e-mail, we do not accept any responsibility for any communications or transactions between you and the relevant third party.</p>\r\n<p>From time to time, we may promote, advertise, or sponsor functions, events, offers, competitions or other activities that may be conducted offline and may be conducted by third parties. You participate in any such activities entirely at your own risk. We do not accept any responsibility in connection with your participation in activities conducted by any third party. These communications and/or activities may be subject to separate terms and conditions and are conducted in accordance with the terms of Property Owl Pty Ltd’s Privacy Policy. For example, the personal information you provide when registering on the Property Owl website may be used, or disclosed, for the purpose of sending you marketing or promotional material about a third party business that we believe may be of interest to you. You will be given an opportunity to unsubscribe to any of these communications in accordance with applicable legislation.</p>\r\n<h2>9 Disclaimer</h2>\r\n<p>You use the Property Owl website at your sole risk.</p>\r\n<p>Except where expressly stated otherwise, material on the Property Owl website is provided as general information only. It is not intended as advice and must not be relied upon as such. You should make your own inquiries and take independent advice tailored to your specific circumstances prior to making any decisions.</p>\r\n<p>We do not make any representation or warranty that any material on the Property Owl website will be reliable, accurate or complete, nor do we accept any responsibility arising in any way from errors or omissions.</p>\r\n<p>We will not be liable for any loss resulting from any action or decision by you in reliance on the material on the Property Owl website, nor any interruption, delay in operation or transmission, virus, communications failure, Internet access difficulties, or malfunction in equipment or software.</p>\r\n<p>You acknowledge that we are not responsible for, and accept no liability in relation to, any other users’ use of, access to or conduct in connection with the Property Owl website in any circumstance.</p>\r\n<h2>10 Limitation of liability</h2>\r\n<p>You use the Property Owl website at your sole risk.</p>\r\n<p>To the extent permitted by law, we exclude all conditions and warranties relating to your use of the Property Owl website that are not expressly set out in the Terms and Conditions.</p>\r\n<p>To the extent that our liability for breach of any warranty or condition, whether implied or express, cannot be excluded by law, our liability will be limited, at our option, to:</p>\r\n<ol><li>in the case of services supplied or offered by us:\r\n<ol type=\"a\">\r\n<li>the re-supply of those services; or</li>\r\n<li>the payment of the cost of having those services re-supplied; and</li></ol></li>\r\n<li>in the case of goods supplied or offered by us:\r\n<ol type=\"a\"><li>the replacement of the goods or the supply of equivalent goods;</li>\r\n<li>the repair of the goods;</li>\r\n<li>the payment of the cost of having the goods replaced; or</li>\r\n<li>the payment of the cost of having the goods repaired.</li></ol></li></ol>\r\n<p>In relation to any express warranty or condition set out in the Terms and Conditions in connection with goods or services supplied or offered by us via the Property Owl website, our liability to you will be limited to the amount(s) paid by you (if any) in respect of those goods or services.</p>\r\n<p>Under no circumstances will we be liable to you for any indirect, incidental, special and/or consequential losses or damages (including loss of profits, revenue, production, goodwill, data or opportunity) of whatever nature howsoever arising in connection with the Property Owl website.</p>\r\n<h2>11 Indemnity</h2>\r\n<p>You agree to fully indemnify and hold us harmless against any expenses, costs, loss (including consequential loss) or damage that we may suffer or incur as a result of or in connection with your use of, access to or conduct in connection with the Property Owl website, including any breach by you of the Terms and Conditions.</p>\r\n<h2>12 GST</h2>\r\n<p>Unless stated to be otherwise, charges referred to for any goods or services supplied (or offered for supply) via the Property Owl website are stated exclusive of GST. Where GST applies to any supply made to you, we will apply the GST and issue you with a Tax Invoice. GST means the Australian goods and services tax charged under A New Tax System (Goods and Services Tax) Act 1999 (\"Act\"). Tax Invoice means tax invoice as defined by the Act.</p>\r\n<h2>13 Severability</h2>\r\n<p>If any provision of the Terms and Conditions is deemed invalid by a court of competent jurisdiction, the invalidity of such provision shall not affect the validity of the remaining provisions of the Terms and Conditions, which shall remain in full force and effect.</p>\r\n<p><strong>No waiver</strong></p>\r\n<p>No waiver of any term of the Conditions shall be deemed a further or continuing waiver of such term or any other term. Any failure to assert any right under the Conditions shall not constitute a waiver of such right.</p>\r\n<h2>14 Affirmation regarding age</h2>\r\n<p>By using the propertyowl.com.au website, you affirm that you are 18 years or over, have full legal capacity or otherwise possess legal parental or guardian consent.</p>\r\n<h2>15 Applicable law</h2>\r\n<p>These Terms and Conditions shall be construed in accordance with and governed by the laws of Queensland, Australia. You consent to the exclusive jurisdiction of the courts in Queensland Courts to determine any matter or dispute which arises under the Terms and Conditions.</p>\r\n<h2>16 Definitions</h2>\r\n<p>In these terms and conditions:</p>\r\n<p>\"Terms and Conditions\" means these terms and conditions, together with the Property Owl Pty Ltd Privacy Policy and any other additional terms, conditions, notices and disclaimers displayed elsewhere on the propertyowl.com.au website.</p>\r\n<p>\"Property Owl website\" means the website that we own and/or operate from time to time, regardless of how that website is accessed by users (including via the Internet, mobile phone or any other device). It also includes other domain names owned or operated by Property Owl Pty Ltd or its other related entities.</p>\r\n<p>\"Material\" means text, illustrations, photos, audio, video, any combination of these or other material.</p>\r\n<p>\"Us\", \"we\" or \"our\" means Property Owl Pty Ltd (ACN 151 357 667) and/or its related entities.</p>',1,'0000-00-00 00:00:00',1),(14,'/faq','Frequently Asked Questions','<h1>FAQS</h1>\r\n<h3>What is Property Owl?</h3>\r\n<p>Property owl.com.au is a deal based website specifically created for new property. It allows subscribers to search a large variety of residential property types across Australia whilst taking advantage of the many deals offered by Sellers.</p>\r\n<p>Property Owl was formed by a group of like-minded sales and marketing professionals to bring the very best in property deals to the market place. Property Owl has done the leg work for you as we understand that your time is precious.</p>\r\n<h3>Is there a cost in joining Property Owl?</h3>\r\n<p>No. There are no associated costs or joining fees when becoming a subscriber to the Property Owl website.</p>\r\n<h3>What is the advantage of becoming a subscriber of Property Owl?</h3>\r\n<p>You will enjoy being the first to view all the best and exclusive weekly residential property deals across Australia.</p>\r\n<h3>Are the deals advertised Exclusive to Property Owl?</h3>\r\n<p>Yes. All Property Owl deals are exclusive whereby the respective Seller has entered into a binding contractual arrangement for a specified time frame. Sellers will provide exclusive deals that cannot be marketed or advertised in other mediums.</p>\r\n<h3>Why would I not just contact a developer directly to obtain the same deal that has been advertised on Property Owl?</h3>\r\n<p>You can contact the Seller but the deal on offer is exclusive to Property owl and not available through agents or the Seller direct.</p>\r\n<h3>Will any of my personal information be used for any other purpose other than Property Owl updates?</h3>\r\n<p>No. Your personal information will not be used for any purpose other than to provide you with Property Owl updates should you wish to receive them. Your personal information will not be used for or provided to any other third party.</p>\r\n<h3>How does Property Owl work?</h3>\r\n<p>Once you have registered with Property Owl, you can search all new property deals as they become available. Simply fill in the required information to secure a deal or complete the enquiry form to request further information. If you decide to take up the purchase of an advertised property deal then simply click on the ‘Secure the Deal’ tab and provide the required information. Once completed simply click ‘Submit’.</p>\r\n<h3>Why was Property Owl developed?</h3>\r\n<p>Property Owl has been developed for two reasons.</p>\r\n<ol><li>To provide Sellers of new property with their own unique internet platform to advertise and sell their products to the wider market place, and</li>\r\n<li>To provide Property Owl subscribers with the best deals on offer from Sellers across Australia.</li>\r\n</ol>\r\n<h3>How do I obtain further information in relation to a property that appeals to me?</h3>\r\n<p>Simply complete the Enquire About This Deal section in the left hand column. Your email will be responded to by the Seller or the Sellers nominated representative.</p>\r\n<h3>How do I know I have the best deal available?</h3>\r\n<p>The Seller guarantees to Property Owl that the deal will be the best available.</p>\r\n<h3>How long does a Property Owl deal last?</h3>\r\n<p>Each deal will last for one week. As you can understand, these will be the best deals on offer from each respective Seller, therefore, one week is the maximum time available, unless sold out prior. The deal can remain listed on the website for a longer period however the deal or offer may not be as good as when it was first advertised.</p>\r\n<h3>How do I purchase a property advertised on Property Owl?</h3>\r\n<p>Simply, click on the ‘Secure the Deal’ tab and enter the information required. A representative of the Seller will be in contact with you to verify your intention to purchase and to explain the buying process.</p>\r\n<h3>What is the process to be adopted when purchasing a Property Owl?</h3>\r\n<p>Property Owl will pass your information to the Sellers nominated agents who will commence the sales contract process with you. The standard legislative\r\nrequirements for each State or Territory will be adhered to be adhered to by the Seller / Agents.</p>\r\n<h3>If I am a Foreign Investor (Overseas Purchaser) can I purchase property through Property Owl?</h3>\r\n<p>Yes. New dwellings acquired ‘off the plan’ (before construction commences or during the construction phase) or after construction is complete are normally approved for purchase by Foreign Investors where the dwellings:</p>\r\n<ul><li>have not previously been sold (that is, they are purchased from the Seller); and</li>\r\n<li>have not been occupied for more than 12 months.</li></ul>\r\n<p>There are no restrictions on the number of such properties in a new development which may be sold to foreign persons, provided that a Seller markets the properties locally as well as overseas (that is, the properties cannot be marketed exclusively overseas).</p>\r\n<p>This category includes dwellings that are part of extensively refurbished buildings where the building\'s use has undergone a change from non-residential (for example, office or warehouse) to residential. It does not include established residential real estate that has been refurbished or renovated.</p>\r\n<p>A property purchased under this category may be rented out, sold to Australian interests or other eligible purchasers, or retained for the foreign investor\'s own use. Once the property has been purchased, it is second-hand real estate and is subject to the restrictions applying to that category.</p>\r\n<h3>Am I legally bound to purchase a Property Owl property after I have submitted an enquiry for further information?</h3>\r\n<p>No. You are not legally bound at any stage, unless of course you choose to purchase one of the advertised properties and there enter into a contract between yourself and the Seller. Once contracts and other documentation have been signed and executed between the parties then you will be bound by the terms and conditions of the contract. State and Territory legislative requirements must still be adhered to by both parties.</p>\r\n<h3>Am I required to pay a deposit if I decide to purchase an apartment?</h3>\r\n<p>Yes. The usual practice is for the Seller to request an initial holding deposit amount (consideration) in order that the property you are seeking to purchase is held off the market. Once contracts etc. have been executed by the Buyer and Seller than a further deposit amount will be payable. The total amount payable usually equates to 10 per cent of the purchase price.</p>\r\n<h3>What forms of deposit will be acceptable to the developer?</h3>\r\n<p>There are three main types of deposit – cash, deposit bonds and bank guarantee. Each deal will contain information as to which method(s) the Seller will accept, however you will usually find that they will accept all of the aforementioned deposit types.</p>\r\n<h3>What are my legal obligations once I have entered into a contract to purchase a property through Property Owl?</h3>\r\n<p>All requirements under relevant state legislation and guidelines must be adhered to including your right to obtain independent legal advice prior to entering into a contract.</p>\r\n<h3>What happens if I refer a friend who purchases a property through Property Owl?</h3>\r\n<p>We thank you for your trust and loyalty to Property Owl. To reward you for this referral Property Owl will provide you with a token of our appreciation. This will be in the form of a cash gratuity (nest egg) to the value of $1000.00 payable in accordance with the Seller\'s payment to Property Owl.</p>\r\n<p>If you and one other both refer the same person to a property on the Property Owl website, then the person whose link is used by the new subscriber to subscribe to the Property owl website will be the one who will be entitled to the nest egg should they purchase a property. For any purchase transaction, only one referral fee will be payable.</p>\r\n<h3>As a Property Owl subscriber am I entitled to receive regular research and market updates?</h3>\r\n<p>Yes. As a Property Owl member you will be entitled to receive regular property research and market updates. If you no longer wish to receive property research or market updates then simply un-check the tick box on your profile page. Alternatively, just click on the ‘Wise Owl’ tab on the website to access all the latest in property news and research.</p>',1,'2012-11-06 09:14:04',1),(15,'/privacy','Privacy Policy','<h2>Introduction</h2>\r\n<p>The www.propertyowl.com.au website is operated by Property Owl Pty Ltd, which recognises the importance of your privacy and understands your concerns about the security of your personal information. Property Owl Pty Ltd is committed to protecting any personal information about you that we hold. This privacy policy details how we generally manage your personal information and strive to safeguard your privacy. In this policy, ‘us’, ‘we’ or ‘our’ means Property Owl Pty Ltd (ACN 151 357 667) and its related entities.</p>\r\n<p>Property Owl Pty Ltd reserves the right, at our sole discretion, to modify or remove portions of this Privacy Policy at any time. These guidelines are subject to change at any time. Any such changes will be made to this page. You should review this Privacy Policy periodically so that you are aware of any changes in how we manage your personal information.</p>\r\n<p>Property Owl Pty Ltd cannot control and does not make any representations about third party websites that may be linked or associated to the propertyowl.com.au website.</p>\r\n<h2>Compliance with the Privacy Act 1988 (Cth) and the National Privacy Principles</h2>\r\n<p>Most private sector organisations in Australia, including Property Owl Pty Ltd, must comply with the Privacy Act 1988 (Cth) and the National Privacy Principles (\"NPPs\") contained within that Act.</p>\r\n<h2>Collecting personal information about you</h2>\r\n<p>The personal information Property Owl Pty Ltd collects in relation to you includes (but is not limited to) your name, contact details (including phone numbers, e-mail address and address postcode) and, depending on the services or products you purchase, financial information, which may include your credit card information.</p>\r\n<p>We also collect information about you that is not personal information. For example, we may collect data relating to your activity on our websites (including IP addresses) via tracking technologies such as cookies, or we may collect information from you in response to a survey. We generally use this information to report statistics, analyse trends, administer our services, diagnose problems and target and improve the quality of our products and services.</p>\r\n<p>To the extent this information does not constitute personal information, the National Privacy Principles do not apply and we may use this information for any purpose and for any means whatsoever. You agree that we may use and disclose Non-Confidential Information for any purpose and by any means whatsoever.</p>\r\n<p>We advise that you do not publish or communicate personal information, or at least limit the personal information that you publish or communicate, to the public such as forums or blogs (Non-Confidential Information). You acknowledge that we cannot control any third party collection or use of your Non- Confidential Information.</p>\r\n<h2>How We Collect Information</h2>\r\n<p>We may have collected your personal information from a variety of sources, including from you, advertisers, mailing lists, contractors and business partners. We may also collect your personal information when you request or acquire a product or service from us, register with us as a member, provide a product or service to us, complete a survey or questionnaire, enter a competition or event, contribute in a fundraising event, participate in our services (including, blogs and forums) or when you communicate with us by e-mail, telephone or in writing.</p>\r\n<p>If, at any time, you provide personal or other information about someone other than yourself, you warrant that you have that person’s consent to provide such information for the purpose specified.</p>\r\n<h2>Why Do We Collect Information</h2>\r\n<p>Property Owl Pty Ltd collects information about you for the primary purpose of providing you with the products and services you have requested from us.</p>\r\n<p>If you do not provide us with the information that we request, we may not be able to provide you with our products or services. For example, if you do not subscribe as a member of the propertyowl.com.au website then you will not be able to access features or services that are reserved for members only.</p>\r\n<p>We also collect information about you for the purposes outlined below in the section entitled “How Do We Use Information”.</p>\r\n<h2>How Do We Use Information</h2>\r\n<p>In addition to the primary purpose outlined above, we may use the personal information we collect, and you consent to us using your personal information, for the following purposes:</p>\r\n<ol><li>to provide you with news and information about our products and services;</li>\r\n<li>to send marketing and promotional material that we believe you may be interested in. This material may relate to any of Property Owl’s developments, advertisers or businesses which we believe may be of interest to you;</li>\r\n<li>for purposes that are necessary or incidental to the provision of goods and services to you;</li>\r\n<li>to personalise and customise your experiences;</li>\r\n<li>to manage and enhance our products and services;</li>\r\n<li>to communicate with you, including by email, mail or telephone;</li>\r\n<li>to conduct competitions or promotions on behalf of Property Owl Pty Ltd and selected third parties;</li>\r\n<li>to verify your identity;</li>\r\n<li>to investigate any complaints about or made by you, or if we have reason to suspect that you are in breach of any of our terms and conditions or that you are or have been otherwise engaged in any unlawful activity; and/or</li>\r\n<li>as required or permitted by any law (including the Privacy Act).</li></ol>\r\n<h2>How Do We Disclose Information</h2>\r\n<p>We may disclose personal information, and you consent to us disclosing your personal information, to other members of Property Owl Pty Ltd and its related entities.\r\nWe may also disclose personal information, and you consent to us disclosing your personal information, to third parties:</p>\r\n<ol><li>engaged by us to perform functions or provide products and services on our behalf, such as mail outs, marketing, research and advertising;</li>\r\n<li>that are our agents, business partners or joint venture entities or partners;</li>\r\n<li>that sponsor or promote any competition that we conduct or promote via our services;</li>\r\n<li>authorised by you to receive information held by us;</li>\r\n<li>as part of any investigation into you or your activity, for example, if we have reason to suspect that you have committed a breach of any of our terms and conditions, or have otherwise been engaged in any unlawful activity, and we reasonably believe that disclosure is necessary to the Police, any relevant authority or enforcement body, or your Internet Service Provider or network administrator;</li>\r\n<li>as part of a sale (or proposed sale) of all or part of our business; and/or</li>\r\n<li>as required or permitted by any law (including the Privacy Act).</li></ol>\r\n<h2>Opting In Or Out</h2>\r\n<p>At the point we collect information from you, you may be asked to “opt in” to consent to us using or disclosing your personal information other than in accordance with this policy or any applicable law. For example, you may be asked to opt-in to receive further information or communications from our advertisers and supporters which do not fall into one of the categories described above.</p>\r\n<p>You will be given the opportunity to “opt out” from receiving communications from us or from third parties that send communications to you in accordance with this policy. For example, you will be given the option to unsubscribe from e-newsletters and other marketing or promotional material sent by us. You may “opt out” from receiving these communications by either clicking on an unsubscribe link at the end of an email or by updating your personal details within your own ‘Account’ page. You may also cancel your account on your ‘Account’ page.</p>\r\n<p>If you receive communications purporting to be connected with us or our services that you believe have been sent to you other than in accordance with this policy, or in breach of any law, please email us.</p>\r\n<h2>Management and Security of Information</h2>\r\n<p>We have appointed a Privacy Officer to oversee the management of personal information in accordance with this policy and the Privacy Act.</p>\r\n<p>Other than in relation to Non-Confidential Information, we will take all reasonable steps to protect the personal information that we hold from misuse, loss, or unauthorised access, including by means of firewalls, pass word access, secure servers and encryption of credit card transactions.</p>\r\n<p>However, you acknowledge that the security of online transactions and the security of communications sent by electronic means or by post cannot be guaranteed. You provide information to us via the internet or by post at your own risk. We do not accept responsibility for misuse or loss of, or unauthorised access to, your personal information.</p>\r\n<p>You acknowledge that we are not responsible for the privacy or security practices of any third party (including third parties that we are permitted to disclose your personal information to in accordance with this policy or any applicable laws). The collection and use of your information by such third party/ies may be subject to separate privacy and security policies.</p>\r\n<p>If you suspect any misuse or loss of, or unauthorised access to, your personal information, please let us know immediately.</p>\r\n<h2>Access to your personal information</h2>\r\n<p>In most cases, you can gain access to personal information that we hold about you. We will handle requests for access to your personal information in accordance with the NPPs.</p>\r\n<p>We encourage all requests for access to your personal information to be directed to the Privacy Officer by email to or by writing to the address below.</p>\r\n<p>We will deal with all requests for access to personal information as quickly as possible. Requests for a large amount of information, or information which is not currently in use, may require further time before a response can be given.</p>\r\n<p>If you would like to access details of the personal information held by Property Owl Pty Ltd about you, please email the Privacy Officer at swoopin@propertyowl.com.au or contact us in writing at the following address:</p>\r\n<p>Attn: Privacy Officer<br />\r\nProperty Owl Pty Ltd<br />\r\nPO Box 2648, Brisbane, Qld 4001</p>',1,'2012-11-06 09:14:51',1),(16,'/research','Research','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.',1,'2012-11-06 09:17:14',1),(17,'/admin','Administration','',1,'2012-12-01 19:50:54',NULL);
/*!40000 ALTER TABLE `po_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_saveddeals`
--

DROP TABLE IF EXISTS `po_saveddeals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_saveddeals` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `deal_id` mediumint(8) unsigned NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_saveddeals`
--

LOCK TABLES `po_saveddeals` WRITE;
/*!40000 ALTER TABLE `po_saveddeals` DISABLE KEYS */;
INSERT INTO `po_saveddeals` VALUES (1,9,1,0),(2,9,1,1),(3,17,1,0);
/*!40000 ALTER TABLE `po_saveddeals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_service_categories`
--

DROP TABLE IF EXISTS `po_service_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_service_categories` (
  `category_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_service_categories`
--

LOCK TABLES `po_service_categories` WRITE;
/*!40000 ALTER TABLE `po_service_categories` DISABLE KEYS */;
INSERT INTO `po_service_categories` VALUES (1,'Interior Design'),(2,'Exterior Designers'),(3,'Digital Media');
/*!40000 ALTER TABLE `po_service_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_services`
--

DROP TABLE IF EXISTS `po_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_services` (
  `service_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` mediumint(9) NOT NULL,
  `company` varchar(100) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `address` text NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `state` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `postcode` varchar(20) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(100) NOT NULL,
  `image` varchar(100) NOT NULL,
  `service_created_at` datetime NOT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_services`
--

LOCK TABLES `po_services` WRITE;
/*!40000 ALTER TABLE `po_services` DISABLE KEYS */;
INSERT INTO `po_services` VALUES (1,2,'testaroo','','','','Ipswich','act','','',1,'this is a test service','','2012-11-06 10:27:16'),(2,1,'testing 2..','','','','blacktown','act','','',1,'this is another test service','','2012-11-06 10:27:16');
/*!40000 ALTER TABLE `po_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_users`
--

DROP TABLE IF EXISTS `po_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_users` (
  `user_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `account_type_id` int(1) NOT NULL DEFAULT '1',
  `company` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `work_phone` varchar(100) NOT NULL,
  `mobile` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `postcode` varchar(100) NOT NULL,
  `subscribed_newsletter` tinyint(4) NOT NULL DEFAULT '0',
  `subscribed_alerts` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_users`
--

LOCK TABLES `po_users` WRITE;
/*!40000 ALTER TABLE `po_users` DISABLE KEYS */;
INSERT INTO `po_users` VALUES (1,'Brendan','Scarvell','bscarvell@gmail.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',3,'Digital8','3288 2222','3288 1111','0412 345 678','123 asdf street!','Redbank Plainz','','',0,0),(2,'Test','Developer','foo@bar.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',2,'','','','','','','','',1,1);
/*!40000 ALTER TABLE `po_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-03  6:54:06
