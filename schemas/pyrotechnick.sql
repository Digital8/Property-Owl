CREATE DATABASE  IF NOT EXISTS `po` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `po`;
-- MySQL dump 10.13  Distrib 5.5.24, for osx10.5 (i386)
--
-- Host: localhost    Database: po
-- ------------------------------------------------------
-- Server version	5.5.29

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
-- Table structure for table `affiliate_categories`
--

DROP TABLE IF EXISTS `affiliate_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliate_categories` (
  `affiliate_category_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`affiliate_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_categories`
--

LOCK TABLES `affiliate_categories` WRITE;
/*!40000 ALTER TABLE `affiliate_categories` DISABLE KEYS */;
INSERT INTO `affiliate_categories` VALUES (1,'Interior Decorating'),(2,'Building and Construction'),(3,'Landscaping');
/*!40000 ALTER TABLE `affiliate_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `affiliates`
--

DROP TABLE IF EXISTS `affiliates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliates` (
  `affiliate_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `logo` varchar(100) DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `address` text NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `state` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `postcode` varchar(20) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(100) NOT NULL,
  `image` varchar(100) NOT NULL,
  `affiliate_category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`affiliate_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliates`
--

LOCK TABLES `affiliates` WRITE;
/*!40000 ALTER TABLE `affiliates` DISABLE KEYS */;
INSERT INTO `affiliates` VALUES (1,'','0400 111 333','1 Queen Street','Brisbane','qld','test@test.test','4000',0,'We\'ve got your back!','',3,'Backenders','0000-00-00 00:00:00','0000-00-00 00:00:00'),(2,'','0400 111 333','1 Wickham Terrace','Fortitude Valley','qld','test@test.test','4000',1,'this is another test service','',1,'Inside Jobs','0000-00-00 00:00:00','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `affiliates` ENABLE KEYS */;
UNLOCK TABLES;

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
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`barn_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barns`
--

LOCK TABLES `barns` WRITE;
/*!40000 ALTER TABLE `barns` DISABLE KEYS */;
INSERT INTO `barns` VALUES (1,'Emirates House','167 Eagle St','Brisbane','4000','qld','woops','Air-conditioning','Parking','River','',2,0,'2012-12-10 00:58:32','2012-12-10 00:58:32');
/*!40000 ALTER TABLE `barns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks` (
  `bookmark_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `type` varchar(50) NOT NULL,
  `entity_id` mediumint(8) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`bookmark_id`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES (11,3,'owl',42,'2012-12-12 02:37:27'),(40,1,'owl',51,'2013-01-02 18:17:26'),(39,1,'owl',10,'2013-01-02 15:29:54'),(38,1,'owl',42,'2012-12-31 12:45:40'),(37,1,'owl',1,'2012-12-31 11:57:29');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clicks`
--

DROP TABLE IF EXISTS `clicks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clicks` (
  `click_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` mediumint(8) NOT NULL,
  `ip_address` varchar(25) NOT NULL,
  `referer` text NOT NULL,
  `user_agent` text NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  `req` mediumtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `type` varchar(45) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`click_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clicks`
--

LOCK TABLES `clicks` WRITE;
/*!40000 ALTER TABLE `clicks` DISABLE KEYS */;
INSERT INTO `clicks` VALUES (8,4,'','','',1,'','2012-12-14 05:07:52','affiliate','2012-12-14 15:07:52');
/*!40000 ALTER TABLE `clicks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_types`
--

DROP TABLE IF EXISTS `deal_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deal_types` (
  `deal_type_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`deal_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_types`
--

LOCK TABLES `deal_types` WRITE;
/*!40000 ALTER TABLE `deal_types` DISABLE KEYS */;
INSERT INTO `deal_types` VALUES (1,'Stamp Duty'),(2,'Furniture Package'),(3,'Blinds'),(4,'Rental Guarantee'),(5,'Entertainment System'),(6,'Other');
/*!40000 ALTER TABLE `deal_types` ENABLE KEYS */;
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
  `entity_id` mediumint(8) unsigned NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  `deal_type_id` int(11) DEFAULT '6',
  `type` varchar(45) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`deal_id`)
) ENGINE=MyISAM AUTO_INCREMENT=261 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deals`
--

LOCK TABLES `deals` WRITE;
/*!40000 ALTER TABLE `deals` DISABLE KEYS */;
INSERT INTO `deals` VALUES (60,'Care-taking Service',10,3,250,6,'owl',NULL,NULL),(49,'stamp duty',17,1,20000,6,'owl',NULL,NULL),(15,'5% off the list price when 5 are sold',2,1,30000,6,'owl',NULL,NULL),(54,'helicopter pad',43,3,50000,5,'owl',NULL,NULL),(52,'stamp duty',45,1,10000,1,'owl',NULL,NULL),(55,'automatisch',43,3,4000,3,'owl',NULL,NULL),(50,'stamp',17,1,30000,5,'owl',NULL,NULL),(53,'furniture package',45,1,30028,2,'owl',NULL,NULL),(59,'u',10,3,10000,1,'owl',NULL,NULL),(73,'u',47,3,149996,1,'owl',NULL,NULL),(69,'u',48,1,10000,1,'owl',NULL,NULL),(66,'Horse',49,1,12000,6,'owl',NULL,NULL),(68,'u',50,1,11000,4,'owl',NULL,NULL),(72,'Car',51,3,10000,6,'owl',NULL,NULL),(71,'Outdoor Setting',52,1,12000,2,'owl',NULL,NULL),(239,'',0,0,0,0,'','0000-00-00 00:00:00','0000-00-00 00:00:00'),(240,'',0,0,0,0,'','0000-00-00 00:00:00','0000-00-00 00:00:00'),(241,'',42,1,0,0,'','0000-00-00 00:00:00','0000-00-00 00:00:00'),(242,'',42,1,0,0,'','0000-00-00 00:00:00','0000-00-00 00:00:00'),(253,'',42,1,0,1,'[object Object]','0000-00-00 00:00:00','0000-00-00 00:00:00'),(254,'',42,1,0,1,'[object Object]','0000-00-00 00:00:00','0000-00-00 00:00:00'),(255,'test',42,1,18,4,'owl','0000-00-00 00:00:00','0000-00-00 00:00:00'),(260,'test',1,1,100,6,'barn',NULL,NULL);
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
-- Table structure for table `enquiries`
--

DROP TABLE IF EXISTS `enquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enquiries` (
  `enquiry_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `entity_id` mediumint(8) unsigned NOT NULL,
  `enquiry` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `updated_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`enquiry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiries`
--

LOCK TABLES `enquiries` WRITE;
/*!40000 ALTER TABLE `enquiries` DISABLE KEYS */;
INSERT INTO `enquiries` VALUES (12,1,1,'test','2013-01-02 19:46:38','affiliate','2013-01-02 19:46:38'),(13,1,1,'test','2013-01-02 19:48:38','affiliate','2013-01-02 19:48:38'),(14,1,0,'','2013-01-03 11:31:26','affiliate','2013-01-03 11:31:26'),(15,1,0,'','2013-01-03 11:33:26','affiliate','2013-01-03 11:33:26'),(16,1,51,'','2013-01-03 11:48:56','affiliate','2013-01-03 11:48:56'),(17,1,51,'','2013-01-03 11:50:56','affiliate','2013-01-03 11:50:56'),(18,1,51,'','2013-01-03 11:52:56','affiliate','2013-01-03 11:52:56'),(19,1,51,'test','2013-01-03 11:53:50','owl','2013-01-03 11:53:50'),(20,1,51,'test','2013-01-03 12:02:56','owl','2013-01-03 12:02:56'),(21,1,2,'test','2013-01-03 13:23:41',NULL,'2013-01-03 13:23:41');
/*!40000 ALTER TABLE `enquiries` ENABLE KEYS */;
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
  `description` varchar(100) DEFAULT NULL,
  `class` enum('image','file','misc') NOT NULL DEFAULT 'misc',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`media_id`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medias`
--

LOCK TABLES `medias` WRITE;
/*!40000 ALTER TABLE `medias` DISABLE KEYS */;
INSERT INTO `medias` VALUES (11,9,1,'8ad19750-2945-11e2-b4bc-5f66e9f836b9.jpg','','image','2012-12-09 23:54:15','0000-00-00 00:00:00','owl'),(12,9,1,'ea037e10-3394-11e2-bad3-cd982acbcfc3.JPG','photo.JPG','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(13,9,1,'d77d3cf0-3460-11e2-a1c1-75b0dcd6ca17.png','profile-pic.png','image','2012-12-09 23:54:15','0000-00-00 00:00:00','owl'),(15,0,0,'','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(16,39,1,'9dd4f0a7-a795-45eb-a73b-1f282f176b8a','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(17,40,1,'c3e2da67-9fdb-40e4-a339-9476b259b358','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(18,1,1,'cd60ef61-d7f3-4ebf-b5c6-1242a446cacf','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(43,47,1,'478fa72e-8f81-47c2-9f06-aed2f838d264.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(35,41,1,'95f0b8c5-8a27-41ad-9327-f00952e25dc1.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(34,41,1,'2a982199-e169-4448-a173-08c9af18e99f.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(37,43,1,'11b6f252-3980-43a2-be1d-b552707860c3.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(38,43,1,'016606b4-2a4a-45b8-84f3-6c3be03d7753.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(39,17,1,'29618948-4930-48e1-ab49-93c4d5828b30.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(44,47,1,'6cc63577-4b85-428c-83aa-c188475ebfd0.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(41,45,1,'956a1eb2-5255-447b-8045-e65c7f78cbb6.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(42,10,3,'9e6af5b5-c433-4ae5-b0bf-ac19bf27578c.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(45,48,1,'c5712252-bb79-4271-8031-1acb262dd837.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(46,48,1,'f9ed5f01-d840-4cf8-9cb1-232ee80ac9fb.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(47,49,1,'119726e9-3f93-4258-9887-d00823d0cf79.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(48,49,1,'dc087e9e-7a81-4b8e-b169-d7e394beb122.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(49,50,1,'e9a7b1ab-c81c-4b65-a20f-29a023a32cdb.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(50,50,1,'09d5cc5a-78af-4752-a2b4-9e8948678295.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(51,52,1,'af9cbf30-8fd7-4264-93c8-ef04a663c4bc.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(52,51,3,'814c997c-9ae8-4571-bded-f71deac485bd.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(53,42,3,'8fee6ccc-ac0b-4b30-88b4-4039f380db6a.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(54,42,3,'e2c65f13-1ec6-4fc3-b6d6-09111651d6e9.png','','image','2012-12-27 06:24:41','0000-00-00 00:00:00','owl'),(55,42,1,'0a450b13-5dd4-4a7f-a444-c7f97b175e34.png','','image','2012-12-27 06:24:41','2012-12-14 03:47:49',''),(68,0,0,'','test','image','2012-12-31 01:51:23','2012-12-28 03:51:36',''),(66,42,1,'23b0b17d-3b89-4192-8406-8a2d6775b872.png','','image','2012-12-31 01:51:23','2012-12-28 03:46:58','owl'),(65,42,1,'fbaf545c-e176-4c6d-bacd-8bdf681239dc.png','','image','2012-12-31 01:51:23','2012-12-28 02:14:02','owl'),(64,42,1,'119c7c2b-71e5-4323-b82c-e0d97fbf1e31.png','','image','2012-12-31 01:51:23','2012-12-28 02:12:02','owl'),(74,42,1,'186a22dc-d751-4708-9a4c-30c06b97d166.png','IMG_0040.PNG','file','2013-01-02 09:56:02','2013-01-02 09:56:02','owl');
/*!40000 ALTER TABLE `medias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `news_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` mediumtext NOT NULL,
  `created_at` datetime NOT NULL,
  `type` enum('news','research') NOT NULL DEFAULT 'news',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`news_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (5,7,'\"Two more rate cuts to come\"','Written by Jennifer Duke   (as reported in Smart Property Investment)\r\n10 December 2012\r\n\r\nDespite last week’s rate cut, more will be on the cards over the first quarter of 2013, according to a leading economist.\r\n\r\nHead of investment strategy and economics for AMP Capital, Shane Oliver, noted in his latest weekly report that the Reserve Bank of Australia “now appears to be finally recognising that the \'normal\' level of bank lending rates may now be lower than simple historic averages would suggest, which in turn suggests they are realising that monetary policy is not as easy as they had been thinking”.\r\n\r\nHe also pointed out that expectations for the RBA governor Glenn Stevens’ speech on Wednesday are that it will “indicate the RBA retains an easing bias”.\r\n\r\nMr Oliver told Smart Property Investment he expects to see another two rate cuts in 2013: “We’ll probably get another couple of cuts next year, both 25 basis points each, around February, March, April or May. This will mean the mortgage rates after this time will be down around six per cent,” he said.\r\n\r\n“The cuts will be enough to revive the housing market, but there is this tendency, when interest rates come down, for people to say … there’s no recovery in sight.”\r\n\r\nHowever, he added, when rates come down to six per cent, those with a $300,000 mortgage will see themselves paying $4,500 less yearly on their interest bill than at the peak of the cycle. This will roll over into more spending and a pick-up across the board.\r\n\r\n“Really, the bottom line is that rates haven’t come down as much as they need to yet; they need to come down more. When we get that occurring over the year, we’ll start to see a pick-up occurring in the housing market and in the other indicators. But it’s not particularly surprising that we haven’t seen a pick-up yet, it’s still early days.”','2012-12-13 18:15:07','news',NULL),(6,7,'\"First home buyers swell activity\"','As reported in Your Investment Property - 6 November 2012\r\n\r\nFirst home buyers are accounting for 30% of all sales in the WA market, while first timers in Victoria were expected to begin benefitting from stamp duty cuts on the weekend.\r\n\r\nData from the Real Estate Institute of Western Australia shows that first home buyers are now the source of 30% of all sales in the state, on the back of more affordable and stable property prices.\r\n\r\nREIWA president David Airey said reasonably stable prices and low interest rates over nine months have resulted in overall turnover picking up by almost 20% compared with the same time last year.\r\n\r\nREIWA expected the median house price to return to parity with a June quarter reading of $484,000, while stable conditions saw a reduction in discounting, to just under 6% of properties.\r\n\r\n“Investors still seem hesitant to return, but there are signs of this starting to turn around as rental yields improve on the back of rising rents, low interest rates and stable prices,\" he said.\r\n\r\nThe Real Estate Institute of Victoria said first home buyers in the state began benefitting from stamp duty concessions on the weekend, if their settlement is due to fall after January 1.\r\n\r\nWith the next round of stamp duty cuts due to come into effect next year, REIV chief executive Enzo Raimondo said buyers should be aware concessions were attached to settlements, not the purchase contract.\r\n\r\n“This means if you are buying your first home right now, you meet the eligibility criteria and your settlement date is 1 January or later, you will be eligible for the 30% discount,\" he said.','2012-12-10 21:04:00','news',NULL),(7,7,'\"Buyers more valuable than listings in tough market\"','\r\nReal Estate Business\r\nFriday, 07 December 2012\r\nby Stacey Moseley\r\n\r\nIn a tough real estate market agents should approach a selling campaign as if they were building a case to put in front of a jury, a principal and former industry trainer has said.\r\n\r\nDane Atherton, managing director of Harcourts Coastal, on the Gold Coast, opened his office 18 months ago when many other reputable businesses were closing down. In that time he has had to reshape the way he sells property, focusing more on finding a buyer than finding a vendor.\r\n\r\n“There is really no other way to put it, we are in a very tough market,” he told over 150 agents who attended Richardson & Wrench’s annual Jump Start 2012 training event last Friday.\r\n\r\n“We have the tough job of telling vendors that almost all our stock is 30 per cent cheaper than when they bought it a few years ago.\r\n\r\n“We have outlawed asking, ‘how was the open home on the weekend?’, because more often than not we would get no one through the home at all.”\r\n\r\nInstead, Mr Atherton and his staff focus on what he refers to as, ‘building a case’ for a buyer.\r\n\r\n“Gathering listings is fine, but it isn’t our main focus. Instead, we prospect for buyers in our marketplace,” he said.\r\n\r\nAccording to Mr Atherton, speed can be the biggest factor in killing a selling campaign in a tough real estate market, like that on the Gold Coast where property values remain well below their peak.\r\n\r\n“I believe speed kills a selling campaign, so we slow down the process and delay negotiations in order to get the vendor in the right head space,” he said. “Some agents rush out with a high offer but it can come too early. A vendor might be greedy and expect more so the offer goes begging.\"\r\n\r\n“For our marketplace it is the lower offers early that normally stimulate selling later on.”','2012-12-10 21:15:03','news',NULL),(8,7,'\"Units, townhouses proving popular in Qld\"','Monday, 10 December 2012\r\n(as reported in Real Estate Business online)\r\n\r\nStaff Reporter\r\n\r\nBuyers are snapping up units and townhouses in the $250,000 to $350,000 price range across the Sunshine State, according to new data from the Real Estate Institute of Queensland (REIQ).\r\n\r\nThe REIQ September median unit and townhouse price report found the numbers of sales increased substantially over the period.\r\n\r\nAcross the state, sales of units and townhouses grew by 40 per cent in the September quarter, compared to the previous quarter. The numbers of sales were also up 14 per cent compared to the same period last year.\r\n\r\nREIQ CEO Anton Kardash said the data also showed sales increasing for units and townhouses priced under $350,000.\r\n\r\n\"More than 800 preliminary sales were recorded for properties priced under $250,000, which is a very affordable price for many buyers. This was an increase of nearly 40 per cent on the same period last year,\" he said.\r\n\r\n\"The greatest numbers of sales was in the $250,000 to $350,000 price bracket, which recorded about 1,250 preliminary sales over the quarter, also an increase on last year.\r\n\r\n\"Units and townhouses continue to be a reasonably priced, and also preferable, option for many buyers who want the convenience of living closer to the city while also keeping a lid on their borrowings.\"\r\n\r\nThe REIQ reported there was a noticeable shift in demand for lower-priced units and townhouses in Cairns and the Gold Coast over the quarter, with both regions recording significant jumps in the numbers of sales of properties for under $250,000.\r\n\r\nIn Brisbane, the median unit and townhouse price increased 0.6 per cent to $405,000 over the September quarter and also recorded a small positive price result over the year ending September.\r\n\r\n\"Brisbane’s median unit price edged up 0.3 per cent over the year, which is a welcome result and one we haven’t witnessed for a year or two now,\" he said. \"This is hopefully the start of the pricing turnaround that we have been anticipating given our property market has been improving throughout the year.\"\r\n\r\nAccording to the REIQ, the construction of new unit and townhouse developments in regional Queensland has resulted in median prices in some areas being skewed either high or low, depending on the types of properties that sold over the quarter.\r\n\r\nIt said this is especially true in Mackay, which posted a median price increase of 9.4 per cent to $320,000 over the quarter. However, this was partly due to a number of sales of luxury units in Nelson street.\r\n\r\nThe REIQ added, however, that while sales numbers across Queensland grew over the September quarter, the June quarter was unusually quiet due to many buyers waiting for the return of stamp duty concessions on 1 July, making comparisons between the two quarters more pronounced than usual.','2012-12-10 21:20:51','news',NULL),(9,7,'\"December rate cut not enough\"','Thursday, 06 December 2012\r\n(as reported in Real Estate Business online)\r\n\r\nStaff Reporter\r\n\r\nDespite the Reserve Bank\'s (RBA) cutting 25 basis points from the cash rate earlier this week, industry pundits are already calling for further cuts.\r\n\r\n1300HomeLoan’s managing director John Kolenda welcomed the RBA decision, which saw the official cash rate drop by 25 basis points to three per cent, but said “more still needs to be done”.\r\n\r\n“Let’s face it, this rate cut was an absolute no-brainer and more is going to be needed before things start to improve,” Mr Kolenda said.\r\n\r\n“Retail and construction are continuing to flounder, the mining sector is turning down and now wages have recorded their first fall in years, so there was really no choice but to cut.\r\n\r\n“It would have been far better if rates were cut last month to put two cuts in the lead-up to Christmas, but as usual it is too little too late from the RBA.”\r\n\r\nMr Kolenda’s comments were echoed by AMP chief economist, Shane Oliver, who agreed more cuts are needed to boost the non-mining sectors of the economy.\r\n\r\n“While the RBA has cut the official cash rate back to its post-GFC record low of three per cent, overall policy settings are nowhere near as stimulatory as they were in mid-2009,” Mr Oliver said.\r\n\r\n“Bank lending rates are much higher, the Australian dollar is way higher and fiscal policy is being tightened not loosened. As such, even lower rates will be needed to boost the non-mining sectors of the economy as the mining boom fades at a time when the Australian dollar remains strong and fiscal cutbacks are intensifying.\r\n\r\n“Post-GFC caution has likely resulted in a reduction in the neutral level for bank lending rates, such that they are only just mildly stimulatory. Standard variable mortgage rates will need to fall to around six per cent at least, which implies that the official cash rate will need to fall to 2.5 per cent at least. This is expected to occur during the first six months of next year, with the RBA cutting again in February.”','2012-12-10 21:23:09','news',NULL),(10,7,'\"Modest fall in auction clearance rates\"','Monday, 03 December 2012\r\n(as reported in Real Estate Business online)\r\n\r\nSimon Parker\r\n\r\nAuction clearance rates eased slightly last week in the major capital cities, new data shows.\r\n\r\nIn Sydney, the clearance rate came in at 57 per cent for last week based on 442 reported auctions, propertydata.com.au reported. This was down slightly on the previous week’s results, which came in at 62 per cent.\r\n\r\nAustralian Property Monitors (APM) reported a similar result for Saturday, showing a 54 per cent clearance rate in Sydney on 363 reported auctions.\r\n\r\n“This week we have again seen strong auctions results across New South Wales,” said Real Estate Institute of NSW CEO, Tim McKibbin. “With many vendors keen to get their properties sold before Christmas, it is likely that the property market will end the year on the positive note. This is pleasing to see, and we are confident that these results will carry over into the New Year, generating increased confidence from buyers and healthy competition in the market.”\r\n\r\nIn Melbourne, propertydata.com.au reported a 60 per cent clearance rate for the weekend, based on 853 reported auctions, down slightly on last week\'s result of 61 per cent. A similar clearance rate result – 59 per cent – was reported by APM.\r\n\r\nREIV CEO Enzo Raimondo said November had been a good month for auctions in Melbourne.\r\n\r\n“There were 2,792 auctions in November, which was 11 per cent lower than the 3154 held in October,” he said.\r\n\r\n“The difference was due to the Melbourne Cup carnival. The clearance rate was 61 per cent for the month which is in line with the year to date trend. November was the fourth consecutive month with a clearance rate in excess of 60 per cent.”\r\n\r\n“The REIV expects about 970 auctions next weekend.”\r\n\r\nIn south east Queensland, independent auctioneers Jason Andrew Group (JA) reported a 45 per cent clearance rate.\r\n\r\nThe company, which handles around 20 per cent of auctions in the region, said the number of registered buyers at auction rose to an average of 1.29 compared to the previous week’s result of 1.07, while the number of registered bidders making a bid fell marginally from 61 per cent to 57 per cent.\r\n\r\nCrowd numbers increased, with an average of 14.6 in attendance at each auction, up from 11.5 the previous week.\r\n\r\nDirector Jason Andrew said the spurt of buyer enthusiasm recorded in winter had failed to translate to the widely anticipated spring selling season.\r\n\r\n“Buyer activity simply couldn’t keep up with the influx of new properties – spring average bidder registrations fell from 1.51 in winter to 1.41 in spring,” Mr Andrew said. “Compounding the issue was the number of vendors who mistakenly believed a market recovery was taking place and that prices were on the rise. Highly attached to inflated price expectations, many of these vendors were unwilling to shift to meet the market.”\r\n\r\n“Despite many optimistic reports about the state of the market, the numbers are very clear – the spring clearance result was 45 per cent, a full 12 per cent lower than the winter result of 52 per cent.”\r\n\r\n“With plenty of uncertainty still in the air, we would encourage vendors who are serious about selling to ensure they have access to enough market information to develop realistic price expectations. Buyers in the current market are on the whole unprepared to pay a premium.”','2012-12-10 21:24:45','news',NULL),(11,7,'\"Cost of living relief just days away for Queenslanders\"','Treasurer and Minister for Trade\r\nThe Honourable Tim Nicholls\r\nWednesday, June 20, 2012\r\n(reported in REIQ eNews 200612)\r\n\r\nQueenslanders will receive a much needed boost to household budgets after the passage of the Newman Government’s Cost of Living Bill through Parliament last night (Tuesday 19 June).\r\n\r\nTreasurer Tim Nicholls said the Treasury (Cost of Living) and Other Legislation Amendment Act included a range of measures that would deliver cost of living relief for Queensland families and businesses.\r\n\r\n“This Bill was the first introduced by the Newman Government after the election and shows just how committed we are to reducing cost of living pressure for families and providing relief for small businesses,” Mr Nicholls said.\r\n\r\nIt delivers a number of the LNP’s key election commitments, including:\r\n\r\n• Reinstating the transfer duty home concession, saving families up to $7000 (From 1 July);\r\n• Increasing the payroll tax exemption threshold for businesses from $1 million to $1.1 million;\r\n• Freezing the standard electricity tariff (Tariff 11) saving families an average of $120;\r\n• Abolishing sustainability declarations when selling houses; and\r\n• Introducing an Office of Best Practice Regulation to cut unnecessary red tape\r\n\r\n“These measures go right to the heart of the Newman Government’s priorities of helping families and small businesses who did it tough under years of Labor,” Mr Nicholls said.\r\n\r\n“During the debate, LNP MPs spoke of their concern after listening to stories from many local residents – from Logan to Hinchinbrook – who were struggling under ever-increasing cost of living pressures.\r\n\r\n“The Newman Government has listened to those concerns and acted without hesitation to do what we said we’d do – deliver cost of living relief.”\r\n\r\nMr Nicholls said home buyers would once again benefit from lower transfer duty on acquiring their family home.\r\n\r\n“This will also boost our ailing property sector which struggled under the policies of the previous Government.”\r\n\r\nHe also said increasing the payroll tax exemption threshold would make Queensland an even more attractive place to do business and create job opportunities in small and medium businesses.\r\n\r\n“This is the first step in our commitment to increasing the threshold to $1.6 million over six years,” he said.\r\n\r\n“Businesses will also benefit from our commitment to slash red tape by 20%.\r\n\r\n“Each of these measures, in addition to our pledge to freeze car registration and reduce water bills, will help Queensland families and businesses who were constantly fleeced through increased taxes and charges by the former Labor Government.”\r\n\r\nENDS\r\n\r\nMedia Contact: Rachael Power - 0409 947 957','2012-12-10 21:29:10','news',NULL);
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
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
  `development_status_id` int(11) NOT NULL,
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
  `approved` tinyint(1) NOT NULL DEFAULT '1',
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`owl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owls`
--

LOCK TABLES `owls` WRITE;
/*!40000 ALTER TABLE `owls` DISABLE KEYS */;
INSERT INTO `owls` (`owl_id`, `title`, `address`, `suburb`, `postcode`, `state`, `description`, `development_type_id`, `price`, `bedrooms`, `bathrooms`, `cars`, `development_status_id`, `level`, `internal_area`, `external_area`, `aspect`, `indoor_features`, `outdoor_features`, `other_features`, `feature_image`, `barn_id`, `listed_by`, `approved`, `approved_at`, `created_at`, `updated_at`) VALUES
(42, 'Rose Cottage', '117 Lansdowne Way', 'Chuwar', '4306', 'qld', 'A nice house in the suburbs of far Western Brisbane.', 1, 789000, 6, 2, 5, 1, NULL, 218, 5130, NULL, 'Split-level, open-planned layout\r\nFireplace', 'Salt-water Swimming Pool\r\nPagola', 'Short walk to shops\r\nChicken Coop', '53', NULL, 1, 1, '2013-01-02 08:59:39', '2012-10-08 19:49:47', '0000-00-00 00:00:00'),
(10, 'Fit for a King!', '12 Karen Court', 'Redbank Plains', '1442', 'qld', 'Reside in style with this fantastic property in suburban Redbank Plans, Queensland.', 1, 900000, 4, 2, 2, 0, NULL, 120, 220, NULL, NULL, NULL, NULL, '', NULL, 2, 1, '2013-01-02 08:59:39', '2012-12-05 06:37:23', '0000-00-00 00:00:00'),
(17, 'Dont buy it', '12 Bell Street', 'Ipswich', '2134', 'qld', 'Dont buy this place.', 2, 493100, 11, 22, 33, 0, NULL, 111, 222, NULL, '', '', '', '', NULL, 2, 1, '2013-01-02 08:59:39', '2012-12-05 06:37:23', '0000-00-00 00:00:00'),
(47, 'MODERN AND STYLISH AND DESIRABLE', '15 Kent St', 'Deakin', '2600', 'act', 'Exciting near new two storey terrace home in a discreet group of 5 in the highly sought after suburb of Deakin. ', 1, 980000, 3, 2, 2, 0, NULL, 140, 100, NULL, '', '', 'Air conditioning\r\nAlarm System\r\nBalcony / Deck\r\nBroadband internet access\r\nBuilt in wardrobes\r\nDishwasher\r\nDouble glazed windows\r\nFloorboards\r\nFully fenced\r\nGarden / Courtyard\r\nInternal Laundry\r\nNorth Facing\r\nPets allowed\r\nSecure Parking\r\nWall / ceiling i', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-05 18:30:39', '0000-00-00 00:00:00'),
(48, 'OMG - This is an Awesome Waterfront Property!', '32 Rosevears Dr', 'Lanena', '7275', 'tas', 'For the buyers serious about boating and lifestyle I have 2046m2 of low maintenance property which allows time on the boat!\r\n\r\nEnjoying a HIGH WATER TITLE and an excellent quality jetty and floating pontoon, brick boathouse with winch, this property is the real deal!\r\n\r\nQuality solid brick house is spacious and complete in itself upstairs and enjoys awesome river views and sunshine then downstairs there is the easy possibility of making it all self contained, may suit a family with elders?\r\n\r\nThere is a separate, heated indoor pool for exercise and a triple garage big enough to take boat and caravan! Everything is in such excellent order the owners can lock up and go for 3-4 months at a time - how good is that?', 1, 899000, 4, 3, 3, 0, NULL, 1000, 2047, NULL, '', '', 'High Water Title\r\nQuality Boat Shed\r\nJetty & Floating Pontoon\r\nHuge Rumpus Room', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-06 00:26:20', '0000-00-00 00:00:00'),
(49, 'Magnificence At Its Best', '64 McMinns Dr', 'McMinns Lagoon', '0822', 'nt', 'With absolute water frontage to McMinns Lagoon Wildlife Reserve and set amongst 6 magnificent acres of fertile and exotic Northern Territory land, this eco friendly, architecturally designed, nature lovers paradise is offered for sale. Don''t miss this opportunity to purchase your piece of paradise in this highly sought after exclusive location! This boutique property is one of the Northern Territory''s finest examples of a luxury rural lifestyle within 30 minutes of the Darwin CBD. Enjoy all the benefits of an iconic Territorian lifestyle just 7 minutes from the new Coolalinga shopping and regional centre. Incorporating Coles, Kmart, supporting speciality shops and entertaining facilities are due to commence construction only months away.\r\nMcMinns Lagoon is a highly sought after rural location and this property, being one of only 6 on the lagoon, is its epicentre. Nestled at one end of the kidney shaped Lagoon the property enjoys views across the far side of the Lagoon greatly enhancing the amenity and privacy of the property', 8, 2300000, 5, 2, 3, 0, NULL, 300, 2500, NULL, 'Built-In Wardrobes\r\nFormal Lounge\r\nSeparate Dining', 'Garden\r\nSecure Parking', 'Close to Shops', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-06 00:34:26', '0000-00-00 00:00:00'),
(50, 'House & Land Packages returning 12.2% pa!!!', '61 Dampier Terrace', 'Derby', '6728', 'wa', 'The Derby property market has undergone significant changes; development and growth over the last five years have continued to defy critics, with expansions from government departments and the influx of resource based projects expected in the near future, NOW is the time to capitalise on the upward swing of this market!', 6, 635000, 4, 2, 2, 0, NULL, 682, 3570, NULL, 'Air Conditioning\r\nWater Closets', 'Patio', '', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-06 00:39:55', '0000-00-00 00:00:00'),
(51, 'MODERN ARCHITECTURALLY DESIGNED TOWNHOUSES, APARTMENTS & UNITS', '18-24 Winona St', 'Findon', '5023', 'sa', 'Choose from a vibrant mix of modern apartments and townhouses.\r\n\r\nSelect a design that meets your needs with up to 12 options available from courtyards to level 2 apartments serviced by lifts.\r\n\r\nAdaptable floorplans all designed with lifestyle in mind, stepless entrance points, overwidth doorways and easy access bathrooms, secure entry and intercom. Bright kitchens adjacent to open plan living areas flowing out to generous balconies or courtyards blending home and community. All apartments have secure under cover parking with auto roller doors.\r\n\r\nThese brand new apartments boast secure entry with intercoms, a six star energy rating and electric boosted solar hot water services.\r\n\r\nEmbrace a new lifestyle with low maintenance living, a better way to enjoy all the benefits of this fabulous suburb with over 50 specialty shops and services\r\nat your doorstep. Less than 6 kms to the beach and a short trip to the city.\r\n\r\nTake advantage of the new $8,500 housing construction grant available to any purchaser and up to $23,500 assistance for first home owners.', 4, 279950, 2, 1, 1, 1, NULL, 0, 0, NULL, '', '', '', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-06 00:43:59', '0000-00-00 00:00:00'),
(52, 'Stunning north facing apartment', '380 Bay St', 'Brighton', '3186', 'vic', 'The 380degrees development is the residential masterpiece by RotheLowman Architects', 4, 995000, 2, 2, 2, 0, NULL, 58, 19, NULL, '', '', 'Study', '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-06 00:47:45', '0000-00-00 00:00:00'),
(43, 'Suite 1 Level 7 Emirates House', '167 Eagle St', 'Brisbane', '4000', 'qld', 'prestige city views', 4, 450000, 12, 4, 6, 0, NULL, 4000, 10000, NULL, NULL, NULL, NULL, '', 1, 0, 1, '2013-01-02 08:59:39', '2012-12-05 08:23:10', '0000-00-00 00:00:00'),
(45, 'Luxurious terrace home', '16 Pottinger St', 'Dawes Point', '2000', 'nsw', 'Few residences can create such an immediate impression of quality, space and sophisticated family living.', 1, 3200000, 3, 3, 2, 0, NULL, 109, 200, NULL, NULL, NULL, NULL, '', NULL, 0, 1, '2013-01-02 08:59:39', '2012-12-05 09:55:27', '0000-00-00 00:00:00');

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
  `stop` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`advertisement_id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_advertisements`
--

LOCK TABLES `po_advertisements` WRITE;
/*!40000 ALTER TABLE `po_advertisements` DISABLE KEYS */;
INSERT INTO `po_advertisements` VALUES (16,'BAC Box ad',19,23,2,'e3fbc410-f741-4964-9c8d-66a627575e20.png','',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(15,'TOFS Tower',20,18,2,'d27c496e-8b64-4974-9985-0624c7d70fc4.png','',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(8,'St George Bank',18,18,1,'af74767f-8149-4d1a-99ec-c31cee46f3af.png','http://www.stgeorge.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(7,'Westpac \"X-mas\" 2012 Campaign',18,0,1,'b68f2ead-1d06-4b34-9ca9-8543996b1b80.png','http://westpac.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(11,'about page left box',18,1,4,'8ee2d2af-b86b-4f8b-913d-73bfd46fb773.png','',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(12,'TOFS',20,23,1,'3d32aee6-ffaf-4f37-9549-fb51b24d3061.png','http://www.tofs.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(13,'BAC Banner',19,14,1,'96d48050-c98e-4891-912f-41650e04f2b8.png','',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(19,'test',22,32,2,'1f7b759a-a3f1-413d-9578-08d2b82db876.png','',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00');
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
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_advertisers`
--

LOCK TABLES `po_advertisers` WRITE;
/*!40000 ALTER TABLE `po_advertisers` DISABLE KEYS */;
INSERT INTO `po_advertisers` VALUES (20,'The Outdoor Furniture Specialists','Outdoor Furniture','Jamie McCalman','jamie@tofs.com.au','3350 8822','Commercial Road','Fortitude Valley','QLD','4006','0000-00-00 00:00:00'),(19,'BAC Corporate','Corporate Apparell','Shaun Cronan','shaunc@baccorp.com.au','0412 590 327','','','','','0000-00-00 00:00:00'),(18,'INC','Australia\'s largest retail advertising network','Luke Hillier','luke.hillier@inc.co','(03) 9016 7943','31 Coventry St','South Melbourne','Victoria','3205','2012-11-26 22:44:07'),(21,'Advantage Pools','Swimming pools and tennis courts','Luke Rowan','luke@advantagepools.com.au','0411 721 449','','Coorparoo','Queensland','4151','0000-00-00 00:00:00'),(22,'Gold Coast Audi','Best Audi deals','Simon French','simonf@audicentregoldcoast.com.au','5509 5606','','','qld','','0000-00-00 00:00:00'),(23,'Homeloans.com.au','Great mortgage deals','Carlo Tonini','carlo.tonini@homeloans.com.au','0400 009 914  ','','WEST END','qld','4101','0000-00-00 00:00:00'),(24,'James Frizelle Automotive','Deals on Hyundai','','','','','Southport','qld','4215','0000-00-00 00:00:00'),(25,'Nick','i fucking sell ads cunt','nick kinsey','pyrotechnick@gmail.com','213587+9526854','117 Lansdowne Way','Chuwar','qld','4306','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `po_advertisers` ENABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_pages`
--

LOCK TABLES `po_pages` WRITE;
/*!40000 ALTER TABLE `po_pages` DISABLE KEYS */;
INSERT INTO `po_pages` VALUES (16,'/research','Research','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.',1,'2012-11-06 09:17:14',1),(14,'/faq','Frequently Asked Questions','<h1>FAQS</h1>\r\n<h3>What is Property Owl?</h3>\r\n<p>Property owl.com.au is a deal based website specifically created for new property. It allows subscribers to search a large variety of residential property types across Australia whilst taking advantage of the many deals offered by Sellers.</p>\r\n<p>Property Owl was formed by a group of like-minded sales and marketing professionals to bring the very best in property deals to the market place. Property Owl has done the leg work for you as we understand that your time is precious.</p>\r\n<h3>Is there a cost in joining Property Owl?</h3>\r\n<p>No. There are no associated costs or joining fees when becoming a subscriber to the Property Owl website.</p>\r\n<h3>What is the advantage of becoming a subscriber of Property Owl?</h3>\r\n<p>You will enjoy being the first to view all the best and exclusive weekly residential property deals across Australia.</p>\r\n<h3>Are the deals advertised Exclusive to Property Owl?</h3>\r\n<p>Yes. All Property Owl deals are exclusive whereby the respective Seller has entered into a binding contractual arrangement for a specified time frame. Sellers will provide exclusive deals that cannot be marketed or advertised in other mediums.</p>\r\n<h3>Why would I not just contact a developer directly to obtain the same deal that has been advertised on Property Owl?</h3>\r\n<p>You can contact the Seller but the deal on offer is exclusive to Property owl and not available through agents or the Seller direct.</p>\r\n<h3>Will any of my personal information be used for any other purpose other than Property Owl updates?</h3>\r\n<p>No. Your personal information will not be used for any purpose other than to provide you with Property Owl updates should you wish to receive them. Your personal information will not be used for or provided to any other third party.</p>\r\n<h3>How does Property Owl work?</h3>\r\n<p>Once you have registered with Property Owl, you can search all new property deals as they become available. Simply fill in the required information to secure a deal or complete the enquiry form to request further information. If you decide to take up the purchase of an advertised property deal then simply click on the ‘Secure the Deal’ tab and provide the required information. Once completed simply click ‘Submit’.</p>\r\n<h3>Why was Property Owl developed?</h3>\r\n<p>Property Owl has been developed for two reasons.</p>\r\n<ol><li>To provide Sellers of new property with their own unique internet platform to advertise and sell their products to the wider market place, and</li>\r\n<li>To provide Property Owl subscribers with the best deals on offer from Sellers across Australia.</li>\r\n</ol>\r\n<h3>How do I obtain further information in relation to a property that appeals to me?</h3>\r\n<p>Simply complete the Enquire About This Deal section in the left hand column. Your email will be responded to by the Seller or the Sellers nominated representative.</p>\r\n<h3>How do I know I have the best deal available?</h3>\r\n<p>The Seller guarantees to Property Owl that the deal will be the best available.</p>\r\n<h3>How long does a Property Owl deal last?</h3>\r\n<p>Each deal will last for one week. As you can understand, these will be the best deals on offer from each respective Seller, therefore, one week is the maximum time available, unless sold out prior. The deal can remain listed on the website for a longer period however the deal or offer may not be as good as when it was first advertised.</p>\r\n<h3>How do I purchase a property advertised on Property Owl?</h3>\r\n<p>Simply, click on the ‘Secure the Deal’ tab and enter the information required. A representative of the Seller will be in contact with you to verify your intention to purchase and to explain the buying process.</p>\r\n<h3>What is the process to be adopted when purchasing a Property Owl?</h3>\r\n<p>Property Owl will pass your information to the Sellers nominated agents who will commence the sales contract process with you. The standard legislative\r\nrequirements for each State or Territory will be adhered to be adhered to by the Seller / Agents.</p>\r\n<h3>If I am a Foreign Investor (Overseas Purchaser) can I purchase property through Property Owl?</h3>\r\n<p>Yes. New dwellings acquired ‘off the plan’ (before construction commences or during the construction phase) or after construction is complete are normally approved for purchase by Foreign Investors where the dwellings:</p>\r\n<ul><li>have not previously been sold (that is, they are purchased from the Seller); and</li>\r\n<li>have not been occupied for more than 12 months.</li></ul>\r\n<p>There are no restrictions on the number of such properties in a new development which may be sold to foreign persons, provided that a Seller markets the properties locally as well as overseas (that is, the properties cannot be marketed exclusively overseas).</p>\r\n<p>This category includes dwellings that are part of extensively refurbished buildings where the building\'s use has undergone a change from non-residential (for example, office or warehouse) to residential. It does not include established residential real estate that has been refurbished or renovated.</p>\r\n<p>A property purchased under this category may be rented out, sold to Australian interests or other eligible purchasers, or retained for the foreign investor\'s own use. Once the property has been purchased, it is second-hand real estate and is subject to the restrictions applying to that category.</p>\r\n<h3>Am I legally bound to purchase a Property Owl property after I have submitted an enquiry for further information?</h3>\r\n<p>No. You are not legally bound at any stage, unless of course you choose to purchase one of the advertised properties and there enter into a contract between yourself and the Seller. Once contracts and other documentation have been signed and executed between the parties then you will be bound by the terms and conditions of the contract. State and Territory legislative requirements must still be adhered to by both parties.</p>\r\n<h3>Am I required to pay a deposit if I decide to purchase an apartment?</h3>\r\n<p>Yes. The usual practice is for the Seller to request an initial holding deposit amount (consideration) in order that the property you are seeking to purchase is held off the market. Once contracts etc. have been executed by the Buyer and Seller than a further deposit amount will be payable. The total amount payable usually equates to 10 per cent of the purchase price.</p>\r\n<h3>What forms of deposit will be acceptable to the developer?</h3>\r\n<p>There are three main types of deposit – cash, deposit bonds and bank guarantee. Each deal will contain information as to which method(s) the Seller will accept, however you will usually find that they will accept all of the aforementioned deposit types.</p>\r\n<h3>What are my legal obligations once I have entered into a contract to purchase a property through Property Owl?</h3>\r\n<p>All requirements under relevant state legislation and guidelines must be adhered to including your right to obtain independent legal advice prior to entering into a contract.</p>\r\n<h3>What happens if I refer a friend who purchases a property through Property Owl?</h3>\r\n<p>We thank you for your trust and loyalty to Property Owl. To reward you for this referral Property Owl will provide you with a token of our appreciation. This will be in the form of a cash gratuity (nest egg) to the value of $1000.00 payable in accordance with the Seller\'s payment to Property Owl.</p>\r\n<p>If you and one other both refer the same person to a property on the Property Owl website, then the person whose link is used by the new subscriber to subscribe to the Property owl website will be the one who will be entitled to the nest egg should they purchase a property. For any purchase transaction, only one referral fee will be payable.</p>\r\n<h3>As a Property Owl subscriber am I entitled to receive regular research and market updates?</h3>\r\n<p>Yes. As a Property Owl member you will be entitled to receive regular property research and market updates. If you no longer wish to receive property research or market updates then simply un-check the tick box on your profile page. Alternatively, just click on the ‘Wise Owl’ tab on the website to access all the latest in property news and research.</p>',1,'2012-11-06 09:14:04',1),(15,'/privacy','Privacy Policy','<h2>Introduction</h2>\r\n<p>The www.propertyowl.com.au website is operated by Property Owl Pty Ltd, which recognises the importance of your privacy and understands your concerns about the security of your personal information. Property Owl Pty Ltd is committed to protecting any personal information about you that we hold. This privacy policy details how we generally manage your personal information and strive to safeguard your privacy. In this policy, ‘us’, ‘we’ or ‘our’ means Property Owl Pty Ltd (ACN 151 357 667) and its related entities.</p>\r\n<p>Property Owl Pty Ltd reserves the right, at our sole discretion, to modify or remove portions of this Privacy Policy at any time. These guidelines are subject to change at any time. Any such changes will be made to this page. You should review this Privacy Policy periodically so that you are aware of any changes in how we manage your personal information.</p>\r\n<p>Property Owl Pty Ltd cannot control and does not make any representations about third party websites that may be linked or associated to the propertyowl.com.au website.</p>\r\n<h2>Compliance with the Privacy Act 1988 (Cth) and the National Privacy Principles</h2>\r\n<p>Most private sector organisations in Australia, including Property Owl Pty Ltd, must comply with the Privacy Act 1988 (Cth) and the National Privacy Principles (\"NPPs\") contained within that Act.</p>\r\n<h2>Collecting personal information about you</h2>\r\n<p>The personal information Property Owl Pty Ltd collects in relation to you includes (but is not limited to) your name, contact details (including phone numbers, e-mail address and address postcode) and, depending on the services or products you purchase, financial information, which may include your credit card information.</p>\r\n<p>We also collect information about you that is not personal information. For example, we may collect data relating to your activity on our websites (including IP addresses) via tracking technologies such as cookies, or we may collect information from you in response to a survey. We generally use this information to report statistics, analyse trends, administer our services, diagnose problems and target and improve the quality of our products and services.</p>\r\n<p>To the extent this information does not constitute personal information, the National Privacy Principles do not apply and we may use this information for any purpose and for any means whatsoever. You agree that we may use and disclose Non-Confidential Information for any purpose and by any means whatsoever.</p>\r\n<p>We advise that you do not publish or communicate personal information, or at least limit the personal information that you publish or communicate, to the public such as forums or blogs (Non-Confidential Information). You acknowledge that we cannot control any third party collection or use of your Non- Confidential Information.</p>\r\n<h2>How We Collect Information</h2>\r\n<p>We may have collected your personal information from a variety of sources, including from you, advertisers, mailing lists, contractors and business partners. We may also collect your personal information when you request or acquire a product or service from us, register with us as a member, provide a product or service to us, complete a survey or questionnaire, enter a competition or event, contribute in a fundraising event, participate in our services (including, blogs and forums) or when you communicate with us by e-mail, telephone or in writing.</p>\r\n<p>If, at any time, you provide personal or other information about someone other than yourself, you warrant that you have that person’s consent to provide such information for the purpose specified.</p>\r\n<h2>Why Do We Collect Information</h2>\r\n<p>Property Owl Pty Ltd collects information about you for the primary purpose of providing you with the products and services you have requested from us.</p>\r\n<p>If you do not provide us with the information that we request, we may not be able to provide you with our products or services. For example, if you do not subscribe as a member of the propertyowl.com.au website then you will not be able to access features or services that are reserved for members only.</p>\r\n<p>We also collect information about you for the purposes outlined below in the section entitled “How Do We Use Information”.</p>\r\n<h2>How Do We Use Information</h2>\r\n<p>In addition to the primary purpose outlined above, we may use the personal information we collect, and you consent to us using your personal information, for the following purposes:</p>\r\n<ol><li>to provide you with news and information about our products and services;</li>\r\n<li>to send marketing and promotional material that we believe you may be interested in. This material may relate to any of Property Owl’s developments, advertisers or businesses which we believe may be of interest to you;</li>\r\n<li>for purposes that are necessary or incidental to the provision of goods and services to you;</li>\r\n<li>to personalise and customise your experiences;</li>\r\n<li>to manage and enhance our products and services;</li>\r\n<li>to communicate with you, including by email, mail or telephone;</li>\r\n<li>to conduct competitions or promotions on behalf of Property Owl Pty Ltd and selected third parties;</li>\r\n<li>to verify your identity;</li>\r\n<li>to investigate any complaints about or made by you, or if we have reason to suspect that you are in breach of any of our terms and conditions or that you are or have been otherwise engaged in any unlawful activity; and/or</li>\r\n<li>as required or permitted by any law (including the Privacy Act).</li></ol>\r\n<h2>How Do We Disclose Information</h2>\r\n<p>We may disclose personal information, and you consent to us disclosing your personal information, to other members of Property Owl Pty Ltd and its related entities.\r\nWe may also disclose personal information, and you consent to us disclosing your personal information, to third parties:</p>\r\n<ol><li>engaged by us to perform functions or provide products and services on our behalf, such as mail outs, marketing, research and advertising;</li>\r\n<li>that are our agents, business partners or joint venture entities or partners;</li>\r\n<li>that sponsor or promote any competition that we conduct or promote via our services;</li>\r\n<li>authorised by you to receive information held by us;</li>\r\n<li>as part of any investigation into you or your activity, for example, if we have reason to suspect that you have committed a breach of any of our terms and conditions, or have otherwise been engaged in any unlawful activity, and we reasonably believe that disclosure is necessary to the Police, any relevant authority or enforcement body, or your Internet Service Provider or network administrator;</li>\r\n<li>as part of a sale (or proposed sale) of all or part of our business; and/or</li>\r\n<li>as required or permitted by any law (including the Privacy Act).</li></ol>\r\n<h2>Opting In Or Out</h2>\r\n<p>At the point we collect information from you, you may be asked to “opt in” to consent to us using or disclosing your personal information other than in accordance with this policy or any applicable law. For example, you may be asked to opt-in to receive further information or communications from our advertisers and supporters which do not fall into one of the categories described above.</p>\r\n<p>You will be given the opportunity to “opt out” from receiving communications from us or from third parties that send communications to you in accordance with this policy. For example, you will be given the option to unsubscribe from e-newsletters and other marketing or promotional material sent by us. You may “opt out” from receiving these communications by either clicking on an unsubscribe link at the end of an email or by updating your personal details within your own ‘Account’ page. You may also cancel your account on your ‘Account’ page.</p>\r\n<p>If you receive communications purporting to be connected with us or our services that you believe have been sent to you other than in accordance with this policy, or in breach of any law, please email us.</p>\r\n<h2>Management and Security of Information</h2>\r\n<p>We have appointed a Privacy Officer to oversee the management of personal information in accordance with this policy and the Privacy Act.</p>\r\n<p>Other than in relation to Non-Confidential Information, we will take all reasonable steps to protect the personal information that we hold from misuse, loss, or unauthorised access, including by means of firewalls, pass word access, secure servers and encryption of credit card transactions.</p>\r\n<p>However, you acknowledge that the security of online transactions and the security of communications sent by electronic means or by post cannot be guaranteed. You provide information to us via the internet or by post at your own risk. We do not accept responsibility for misuse or loss of, or unauthorised access to, your personal information.</p>\r\n<p>You acknowledge that we are not responsible for the privacy or security practices of any third party (including third parties that we are permitted to disclose your personal information to in accordance with this policy or any applicable laws). The collection and use of your information by such third party/ies may be subject to separate privacy and security policies.</p>\r\n<p>If you suspect any misuse or loss of, or unauthorised access to, your personal information, please let us know immediately.</p>\r\n<h2>Access to your personal information</h2>\r\n<p>In most cases, you can gain access to personal information that we hold about you. We will handle requests for access to your personal information in accordance with the NPPs.</p>\r\n<p>We encourage all requests for access to your personal information to be directed to the Privacy Officer by email to or by writing to the address below.</p>\r\n<p>We will deal with all requests for access to personal information as quickly as possible. Requests for a large amount of information, or information which is not currently in use, may require further time before a response can be given.</p>\r\n<p>If you would like to access details of the personal information held by Property Owl Pty Ltd about you, please email the Privacy Officer at swoopin@propertyowl.com.au or contact us in writing at the following address:</p>\r\n<p>Attn: Privacy Officer<br />\r\nProperty Owl Pty Ltd<br />\r\nPO Box 2648, Brisbane, Qld 4001</p>',1,'2012-11-06 09:14:51',1),(2,'/terms-and-conditions','Terms and Conditions','<h2>1 Introduction</h2>\r\n<p>These terms and conditions, together with the Property Owl Pty Ltd Privacy Policy and any additional terms, conditions, notices and disclaimers displayed elsewhere on the website govern your use of and access to propertyowl.com.au.</p>\r\n<p>Property Owl Pty Ltd may change all or part of these Terms and Conditions at any time. Any changes to the Terms and Conditions will be posted on the propertyowl.com.au website. Your subsequent or continued use of the propertyowl.com.au website will constitute your acceptance of any changes made to the Terms and Conditions. If you object to the Terms and Conditions of Use or changes made to the Terms and Conditions, your only remedy is to immediately discontinue your use of the propertyowl.com.au website.</p>\r\n<p>These terms and conditions of use were last updated on 26 October 2012.</p>\r\n<h2>2 PropertyOwl.com.au Website</h2>\r\n<p>At Property Owl Pty Ltd we make every reasonable endeavor to ensure that the website is available at all times. Property Owl Pty Ltd does not make any representations or warranties that your access to the website will be uninterrupted, timely, secure or error free. Your access to the propertyowl.com.au website may be suspended without notice in the case of system failure, maintenance or repair or any other reason beyond our control.</p>\r\n<p>Except as expressly provided otherwise within these Terms and Conditions, we reserve the right to change or discontinue the website, feature or service (or part thereof) displayed on propertyowl.com.au at any time.</p>\r\n<p>Except as expressly provided otherwise in the Terms and Conditions we reserve the right to change the pricing for any chargeable service or feature on propertyowl.com.au at any time without having to provide any notice to you.</p>\r\n<h2>3 Membership Registration</h2>\r\n<p>To access or use certain parts of the property owl website, you must register as a member.</p><p>Registration is free.</p>\r\n<p>When registering as a member, you must provide us with accurate, complete, and up-to-date registration information as requested. It is your responsibility to inform us of any changes to your registration information. If propertyowl.com.au approves registration, we will require you to confirm your identity and acceptance of these Terms and Conditions.</p>\r\n<p>You must not register as a member multiple times.</p>\r\n<p>You must not impersonate or create a membership for any person other than yourself.</p>\r\n<p>We may at any time request a form of identification to verify your identity. In the event that you fail or refuse to provide the requested form of identification then we may, at our absolute discretion suspend or terminate any membership you have registered.</p>\r\n<p>You must ensure the security and confidentiality of your membership details, including any username and/or password assigned to you. You are wholly responsible for all activities which occur under your membership details (including unauthorised use of your credit card). You must notify us immediately if you become aware of any unauthorised use of your membership details. You must not permit your membership details to be used by or transferred to any other person.</p>\r\n<p>We reserve the right to, in our sole discretion, suspend or terminate your membership or access to all or any part of the propertyowl.com.au website, including if we believe you are abusing the services in any way, have breached the Terms and Conditions or are no longer an active member.</p>\r\n<h2>4 Your conduct</h2>\r\n<p>You must not:</p>\r\n<ol><li>use the property owl website in breach of any applicable laws or regulations;</li>\r\n<li>use the property owl website (or Material obtained from the propertyowl.com.au website):\r\n<ol type=\"a\"><li>to transmit (or authorise the transmission of) \"junk mail,\" \"chain letters,\" unsolicited emails, instant messaging, \"spimming,\" or \"spamming\";</li>\r\n<li>to impersonate any person or entity;</li>\r\n<li>to solicit money, passwords or personal information from any person;</li>\r\n<li>to harm, abuse, harass, stalk, threaten or otherwise offend others;</li>\r\n<li>or for any unlawful purpose;</li></ol></li>\r\n<li>use the property owl website to upload, post, transmit or otherwise make available (or attempt to upload, post, transmit or otherwise make available) any Material that:\r\n<ol type=\"a\">\r\n<li>is not your original work, or which in any way violates or infringes (or could reasonably be expected to violate or infringe) the intellectual property or other rights of another person;</li>\r\n<li>contains, promotes, or provides information about unlawful activities or conduct;</li>\r\n<li>is, or could reasonably be expected to be, defamatory, obscene, offensive, threatening, abusive, pornographic, vulgar, profane, indecent or otherwise unlawful, including Material that racially or religiously vilifies, incites violence or hatred, or is likely to offend, insult or humiliate others based on race, religion, ethnicity, gender, age, sexual orientation or any physical or mental disability;</li>\r\n<li>exploits another person in any manner;</li>\r\n<li>contains nudity, excessive violence, or sexual acts or references;</li>\r\n<li>includes an image or personal information of another person or persons unless you have their consent;</li>\r\n<li>poses or creates a privacy or security risk to any person;</li>\r\n<li>you know or suspect (or ought reasonably to have known or suspected) to be false, misleading or deceptive;</li>\r\n<li>contains large amounts of untargeted, unwanted or repetitive content;</li>\r\n<li>contains restricted or password only access pages, or hidden content;</li>\r\n<li>contains viruses, or other computer codes, files or programs designed to interrupt, limit or destroy the functionality of other computer software or hardware;</li>\r\n<li>advertises, promotes or solicits any goods or services or commercial activities (except where expressly permitted or authorised by us); or</li>\r\n<li>contains financial, legal, medical or other professional advice;</li></ol></li>\r\n<li>interfere with, disrupt, or create an undue burden on the propertyowl.com.au website;</li>\r\n<li>use any robot, spider, or other device or process to retrieve, index, or in any way reproduce, modify or circumvent the navigational structure, security or presentation of the propertyowl.com.au website;</li>\r\n<li>use the propertyowl.com.au website with the assistance of any automated scripting tool or software;</li>\r\n<li>frame or mirror any part of the propertyowl.com.au website without our prior written authorisation;</li>\r\n<li>use code or other devices containing any reference to the property owl website to direct other persons to any other web page;</li>\r\n<li>except to the extent permitted by law, modify, adapt, sublicense, translate, sell, reverse engineer, decipher, decompile or otherwise disassemble any portion of the Property Owl website or cause any other person to do so; or</li>\r\n<li>delete any attributions or legal or proprietary notices on the Property Owl website.</li></ol>\r\n<h2>5 Your Material</h2>\r\n<p>By uploading, transmitting, posting or otherwise making available any Material via the Property Owl website, you:</p>\r\n<ol><li>grant us a non-exclusive, worldwide, royalty-free, perpetual, license to use, reproduce, edit and exploit the Material in any form and for any purpose;</li>\r\n<li>except where expressly stated otherwise, you also grant each user of the Property Owl website a non- exclusive, worldwide, royalty-free, perpetual, license to use, reproduce, edit and exploit the Material in any form for any purpose, subject to the Terms and Conditions;</li>\r\n<li>warrant that you have the right to grant the abovementioned licenses;</li>\r\n<li>warrant that the Material does not breach the Terms and Conditions; and</li>\r\n<li>unconditionally waive all moral rights (as defined by the Copyright Act 1968) which you may have in respect of the Material.</li></ol>\r\n<p>We reserve the right (but have no obligation) to:</p>\r\n<ol><li>review, modify, reformat, reject or remove any Material which you upload, post, transmit or otherwise make available (or attempt to upload, post, transmit or otherwise make available) that, in our opinion, violates the Terms and Conditions or otherwise has the potential to harm, endanger or violate the rights of any person; and</li>\r\n<li>monitor use of the Property Owl website, and store or disclose any information that we collect, including in order to investigate compliance with the Terms and Conditions or for the purposes of any police investigation or governmental request.</li></ol>\r\n<p>We are not responsible for, and accept no liability with respect to, any Material uploaded, posted, transmitted or otherwise made available on the Property Owl website by any person other than us. For the avoidance of doubt, we will not be taken to have uploaded, posted, transmitted or otherwise made Material available on the Property Owl website simply by facilitating others to post, transmit or other make Material available. Furthermore, we do not endorse any opinion, advice or statement made by any third person other than us.</p>\r\n<h2>6 Contacting us</h2>\r\n<p>If you think that the Property Owl website has been accessed or used by another user in breach of the Terms and Conditions, please email us at <a href=\"mailto:support@propertyowl.com.au?Subject=Property%20Owl%20Terms%20and%20Conditions%20Enquiry\">support@propertyowl.com.au</a> We will consider whether there are grounds for taking any action, but you will not necessarily be contacted as to our decision.</p>\r\n<p>In particular, if you wish to send us a copyright infringement notification, you must identify the Material(s) that you believe infringe(s) your copyright, identify each copyright protected work in which you own the rights and which you believe has been infringed, identify how each copyright protected work has been or is being infringed and include your contact information. You will need to sign the notice and send it to <a href=\"mailto:support@propertyowl.com.au?Subject=Property%20Owl%20Terms%20and%20Conditions%20Enquiry\">support@propertyowl.com.au</a>.</p>\r\n<h2>7 Intellectual Property</h2>\r\n<p>Except where expressly provided otherwise in the Terms and Conditions, you do not have any right, title or interest in or to any proprietary rights relating to the Property owl website.</p>\r\n<p>The Property Owl website contains Material that is protected by copyright, trade mark and other laws. Except where expressly provided otherwise in the Terms and Conditions, you may reproduce and display the Material on the Property Owl website for your own personal, non-commercial use only. Except for the temporary copy held in your computer\'s cache and a single permanent copy for your personal reference, the material may not otherwise be used, stored, reproduced, published, altered or transmitted in any form or by any means in whole or in part without our prior written approval or the written approval of our licensor.</p>\r\n<p>In particular, you may not use any Material on the Property Owl website to establish, maintain or provide, or assist in establishing, maintaining or providing your own publications, Internet site or other means of distribution.</p>\r\n<p>Nothing displayed on the Property Owl website should be construed as granting any right of use in relation to any logo, masthead or trade mark displayed on the Property Owl website without the express written consent of the relevant owner.</p>\r\n<h2>8 Third party websites, advertising and activities</h2>\r\n<p>We may feature or display links and pointers to websites operated by third parties on the Property Owl website. Such websites do not form part of the Property Owl website and are not under our control. We do not accept any responsibility in connection with any such website. If you link to any such websites, you leave the Property Owl website entirely at your own risk.</p>\r\n<p>You must not link to the Property Owl website from any other website (or otherwise authorise any other person to link from a third party website to the Property Owl website) without our prior written consent.</p>\r\n<p>The Property Owl website may feature or display third party advertising. By featuring or displaying such advertising, we do not in any way represent that we recommend or endorse the relevant advertiser, its products or services.</p>\r\n<p>If you contact a third party using functionality provided on the Property Owl website, including via e-mail, we do not accept any responsibility for any communications or transactions between you and the relevant third party.</p>\r\n<p>From time to time, we may promote, advertise, or sponsor functions, events, offers, competitions or other activities that may be conducted offline and may be conducted by third parties. You participate in any such activities entirely at your own risk. We do not accept any responsibility in connection with your participation in activities conducted by any third party. These communications and/or activities may be subject to separate terms and conditions and are conducted in accordance with the terms of Property Owl Pty Ltd’s Privacy Policy. For example, the personal information you provide when registering on the Property Owl website may be used, or disclosed, for the purpose of sending you marketing or promotional material about a third party business that we believe may be of interest to you. You will be given an opportunity to unsubscribe to any of these communications in accordance with applicable legislation.</p>\r\n<h2>9 Disclaimer</h2>\r\n<p>You use the Property Owl website at your sole risk.</p>\r\n<p>Except where expressly stated otherwise, material on the Property Owl website is provided as general information only. It is not intended as advice and must not be relied upon as such. You should make your own inquiries and take independent advice tailored to your specific circumstances prior to making any decisions.</p>\r\n<p>We do not make any representation or warranty that any material on the Property Owl website will be reliable, accurate or complete, nor do we accept any responsibility arising in any way from errors or omissions.</p>\r\n<p>We will not be liable for any loss resulting from any action or decision by you in reliance on the material on the Property Owl website, nor any interruption, delay in operation or transmission, virus, communications failure, Internet access difficulties, or malfunction in equipment or software.</p>\r\n<p>You acknowledge that we are not responsible for, and accept no liability in relation to, any other users’ use of, access to or conduct in connection with the Property Owl website in any circumstance.</p>\r\n<h2>10 Limitation of liability</h2>\r\n<p>You use the Property Owl website at your sole risk.</p>\r\n<p>To the extent permitted by law, we exclude all conditions and warranties relating to your use of the Property Owl website that are not expressly set out in the Terms and Conditions.</p>\r\n<p>To the extent that our liability for breach of any warranty or condition, whether implied or express, cannot be excluded by law, our liability will be limited, at our option, to:</p>\r\n<ol><li>in the case of services supplied or offered by us:\r\n<ol type=\"a\">\r\n<li>the re-supply of those services; or</li>\r\n<li>the payment of the cost of having those services re-supplied; and</li></ol></li>\r\n<li>in the case of goods supplied or offered by us:\r\n<ol type=\"a\"><li>the replacement of the goods or the supply of equivalent goods;</li>\r\n<li>the repair of the goods;</li>\r\n<li>the payment of the cost of having the goods replaced; or</li>\r\n<li>the payment of the cost of having the goods repaired.</li></ol></li></ol>\r\n<p>In relation to any express warranty or condition set out in the Terms and Conditions in connection with goods or services supplied or offered by us via the Property Owl website, our liability to you will be limited to the amount(s) paid by you (if any) in respect of those goods or services.</p>\r\n<p>Under no circumstances will we be liable to you for any indirect, incidental, special and/or consequential losses or damages (including loss of profits, revenue, production, goodwill, data or opportunity) of whatever nature howsoever arising in connection with the Property Owl website.</p>\r\n<h2>11 Indemnity</h2>\r\n<p>You agree to fully indemnify and hold us harmless against any expenses, costs, loss (including consequential loss) or damage that we may suffer or incur as a result of or in connection with your use of, access to or conduct in connection with the Property Owl website, including any breach by you of the Terms and Conditions.</p>\r\n<h2>12 GST</h2>\r\n<p>Unless stated to be otherwise, charges referred to for any goods or services supplied (or offered for supply) via the Property Owl website are stated exclusive of GST. Where GST applies to any supply made to you, we will apply the GST and issue you with a Tax Invoice. GST means the Australian goods and services tax charged under A New Tax System (Goods and Services Tax) Act 1999 (\"Act\"). Tax Invoice means tax invoice as defined by the Act.</p>\r\n<h2>13 Severability</h2>\r\n<p>If any provision of the Terms and Conditions is deemed invalid by a court of competent jurisdiction, the invalidity of such provision shall not affect the validity of the remaining provisions of the Terms and Conditions, which shall remain in full force and effect.</p>\r\n<p><strong>No waiver</strong></p>\r\n<p>No waiver of any term of the Conditions shall be deemed a further or continuing waiver of such term or any other term. Any failure to assert any right under the Conditions shall not constitute a waiver of such right.</p>\r\n<h2>14 Affirmation regarding age</h2>\r\n<p>By using the propertyowl.com.au website, you affirm that you are 18 years or over, have full legal capacity or otherwise possess legal parental or guardian consent.</p>\r\n<h2>15 Applicable law</h2>\r\n<p>These Terms and Conditions shall be construed in accordance with and governed by the laws of Queensland, Australia. You consent to the exclusive jurisdiction of the courts in Queensland Courts to determine any matter or dispute which arises under the Terms and Conditions.</p>\r\n<h2>16 Definitions</h2>\r\n<p>In these terms and conditions:</p>\r\n<p>\"Terms and Conditions\" means these terms and conditions, together with the Property Owl Pty Ltd Privacy Policy and any other additional terms, conditions, notices and disclaimers displayed elsewhere on the propertyowl.com.au website.</p>\r\n<p>\"Property Owl website\" means the website that we own and/or operate from time to time, regardless of how that website is accessed by users (including via the Internet, mobile phone or any other device). It also includes other domain names owned or operated by Property Owl Pty Ltd or its other related entities.</p>\r\n<p>\"Material\" means text, illustrations, photos, audio, video, any combination of these or other material.</p>\r\n<p>\"Us\", \"we\" or \"our\" means Property Owl Pty Ltd (ACN 151 357 667) and/or its related entities.</p>',1,'0000-00-00 00:00:00',1),(1,'/about','About Property Owl','<p>Propertyowl.com.au was established by a group of real estate and marketing professionals to assist buyers of residential property access to the best discounts, offers, deals or incentives that a residential property developer (seller) will provide.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is Australia\'s first to provide residential property developers with their own unique website platform specifically developed to showcase and sell their products without being lost amongst the thousands of private sellers of homes, land, apartments, units, townhouses, etc.\r\n</p>\r\n<p>\r\nThe website allows property developers a greater reach to larger audiences of prospective buyers who have a particular interest in new properties.\r\n</p>\r\n<p>\r\nThe propertyowl.com.au website provides our subscribers with genuine deals without having to cut through the noise of advertising, marketing hype and pushy sales people.\r\n</p>\r\n<p>\r\nThe website has been developed to provide full disclosure of all known information relating to a residential product/development either \'off the plan\' or \'completed\' so that our registered subscribers to propertyowl.com.au can make informed buying decisions, whilst also taking advantage of the great deals on offer.\r\n</p>\r\n<p>\r\nPropertyowl.com.au uses its best endeavours to obtain all known information that relates to specific residential developments advertised on the website. We value the feedback that you provide us as it enables us to constantly improve our site.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is committed to enriching the lives of Australians through its support of charitable organisations and innovative programs to build strong and nurturing communities.\r\n</p>',1,'2012-11-05 12:10:22',1),(17,'/admin','Administration','',1,'2012-12-01 19:50:54',NULL),(18,'/','Home Page','h1 Welcome to Property Owl!\r\np\r\n  | Property Owl offers the best deals on new residential properties Australia wide, with new deals uploaded to the website every Wednesday at 12 midday!\r\np\r\n  | The Property Owl website provides for the best possible deals on selected new properties across the Australian real estate market.  Properties listed on Property Owl must include a minimum value deal to advertise on the website.  It is important to note that these deals are not available through the Seller direct.\r\np So how does it work?\r\np\r\n  | New deals are uploaded to the Property Owl website on a weekly basis via the \r\n  span.emphasis \'Owl Deals\' \r\n  | tab.  All properties represented on the website are then assessed by the Property Owl system where the best \'value for money\' deal for each state across Australia is accessed via the \r\n  span.emphasis \'Best State Deal\' \r\n  | tab.   Once the best value for money deals have been selected for each state, the Property Owl system then assesses and selects the best deal nationally and is accessed via the \r\n  span.emphasis \'Australia\'s Best Property Deal\' \r\n  | tab.\r\np\r\n  | The \'value for money\' deals (based on percentage value) calculated and selected by the Property Owl system are legitimate deals.  Sellers cannot secure the \'The Best State\' and \'Australia\'s Best Property Deal\' positions on the website through paid advertising.  In order to secure these positions the Sellers must put forward their best deal - Simple.\r\np\r\n  | You must be quick in securing these deals in \'Best State Deal\' and \'Australia\'s Best Property Deal\' as they are for a 7 day period, unless sold sooner.  The timer on the left hand side of the web page indicates how much time remains before the deal finishes.\r\np\r\n  | If you like any of the deals represented then simply click on the \r\n  span(style=\'color: #009300;\')\r\n    strong green \r\n  span.emphasis \'Secure the Deal\' \r\n  | tab where you will be prompted to complete the relevant enquiry form.  Once completed it is then forwarded to the Sellers representative who will contact you in relation to the next step of the purchasing process.\r\np\r\n  | If you are interested in obtaining an even better deal, then swoop on a selected property within \r\n  span.emphasis \'The Barn\' \r\n  | .  In \'The Barn\' Sellers list a number of similar new properties in the one location and offer further deals to groups of individuals who collectively take up the offer within the required time.\r\np\r\n  | Not currently in the market to purchase a property yourself?  Refer a friend who then registers with and subsequently purchases a property through Property Owl and you will be rewarded with a $1000.00 nest egg for your referral.\r\np So what are you waiting for - Swoop in today!\r\np\r\n  span.emphasis Property Owl – Innovation in delivering Australia\'s Best Property Deals.',1,'2012-12-05 12:07:59',1),(22,'/owls/top','Australia\'s Best Deal','',1,'2012-12-10 16:11:30',0),(23,'/owls/hot','Best State Deals','',1,'2012-12-10 16:11:58',0),(24,'/owls/locate','Owl Deals','',1,'2012-12-10 16:12:22',0),(25,'/news','News','',1,'2012-12-10 16:12:42',0),(26,'/affiliates','Products & Services','',1,'2012-12-10 16:13:19',0),(27,'/account','My Account','',1,'2012-12-10 16:13:54',0),(28,'/contact','Contact','',1,'2012-12-10 16:14:38',0),(29,'/barns','Barn Listings','',1,'2012-12-10 16:15:12',0),(30,'/search','Search','',1,'2012-12-10 16:15:50',0),(31,'/how-it-works','How It Works','<p>Did you know that a group of owls is known as a &#39;Parliament of Owls?</p>\r\n            <p>So why is this piece of trivia important?  Because collectively as a group of individuals you will have greater opportunities in catching the deal that you seek.</p>\r\n            <p>Sellers of new properties (land, apartments, townhouses, house land packages, etc.) who have 3 – 5 similar properties can sell these at the one time.  Sellers recognise the benefits of selling multiple properties at the same time and are willing to share those benefits with you the buyer.</p>\r\n            <p>Click &#39;Swoop Here&#39; on any of the new residential property listings to access a host of information that relates specifically to the barn deal selected.</p>\r\n            <p>A &#39;Barn&#39; listing with all available properties and land (lots) for sale will then be displayed in a matrix located below the images of the development.  Research and select the particular property (lot) you wish to purchase by clicking on the GO tab on the right side of the matrix.  Once selected, that particular property (lot) will be shaded another colour to indicate that it is no longer available.</p>\r\n            <p>Complete the enquiry template, including your contact telephone/mobile details.</p>\r\n            <p>Provided all Lots are secured within the time frame then the deal is activated.</p>\r\n            <p>Once activated the seller\'s agent will be in contact to discuss the buying process.  Don\'t worry if you missed out.  Register in The Barn to remain in contention for further deals as they come online or if a buyer does not progress to the next stage.</p>\r\n            <p>Remember that by purchasing in The Barn, you are availing yourself to an extra special deal that is not available elsewhere.  You will sometimes also notice View Barn Deal icon in an Owl Deals listing - click on this to access The Barn listing immediately.  The deal will be different but how much time can you spare?</p>\r\n            <p>Buy now in Owl Deals or wait for the registered number of properties (lots) to be swooped on in The Barn.</p>',1,'2012-12-11 16:25:40',1),(32,'/refer-a-friend','Refer A Friend','<p>We all seem to know someone who is looking to invest in property be it land, apartments, houses, house and land, townhouses etc.!</p>\r\n<p>So why not be rewarded for referring them to the right property deals?</p>\r\n<p>Spread the word through the Refer a Friend link and when they buy a property advertised through Property Owl within 6 months of being referred, you will receive a $1000 nest egg. Swoop in and start referring now. </p>\r\n<p>The more you refer, the bigger your nest egg reward could be. It\'s that easy. </p>',1,'2012-12-11 16:32:39',1);
/*!40000 ALTER TABLE `po_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_registrations`
--

DROP TABLE IF EXISTS `po_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `po_registrations` (
  `registration_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `resource_id` mediumint(9) NOT NULL,
  `type` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `registered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`registration_id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_registrations`
--

LOCK TABLES `po_registrations` WRITE;
/*!40000 ALTER TABLE `po_registrations` DISABLE KEYS */;
INSERT INTO `po_registrations` VALUES (1,1,'property',1,'2012-11-30 04:52:49'),(4,2,'property',1,'2012-11-30 04:57:53'),(5,0,'property',1,'2012-12-04 13:09:27'),(6,41,'owl',1,'2012-12-04 20:16:17'),(7,43,'owl',1,'2012-12-04 22:23:20'),(8,43,'owl',7,'2012-12-05 04:59:01'),(9,10,'owl',7,'2012-12-05 06:27:10'),(10,42,'owl',7,'2012-12-05 09:40:08'),(11,1,'barn',7,'2012-12-05 10:10:43'),(12,47,'owl',7,'2012-12-05 13:29:59'),(13,48,'owl',7,'2012-12-05 13:30:55'),(14,43,'owl',3,'2012-12-08 09:16:37'),(15,47,'owl',3,'2012-12-11 14:51:24'),(16,42,'owl',1,'2013-01-02 07:01:42'),(17,1,'barn',1,'2013-01-02 07:08:32');
/*!40000 ALTER TABLE `po_registrations` ENABLE KEYS */;
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
  `created_at` datetime NOT NULL,
  `pref_suburb` varchar(20) NOT NULL,
  `pref_state` varchar(10) NOT NULL,
  `pref_ptype` varchar(25) NOT NULL,
  `pref_dtype` varchar(25) NOT NULL,
  `pref_min_price` varchar(10) NOT NULL,
  `pref_max_price` varchar(10) NOT NULL,
  `pref_min_beds` varchar(10) NOT NULL,
  `pref_max_beds` varchar(10) NOT NULL,
  `pref_bathrooms` varchar(10) NOT NULL,
  `pref_cars` varchar(10) NOT NULL,
  `pref_dev_stage` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_users`
--

LOCK TABLES `po_users` WRITE;
/*!40000 ALTER TABLE `po_users` DISABLE KEYS */;
INSERT INTO `po_users` VALUES (1,'Brendan','Scarvell','bscarvell@gmail.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',3,'Digital8','3288 2222','3288 1111','0412 345 678','123 asdf street!','Redbank Plainz','','',0,0,'2012-10-05 09:00:01','chuwar','qld','house','all','Any','Any','Any','Any','Any','Any','all'),(2,'Test','Developer','foo@bar.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',2,'','','','','','','','',1,1,'2012-12-05 09:00:01','','','','','','','','','','',''),(3,'Nicholas','Kinsey','pyro@feisty.io','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',3,'Digital8','','','','','','','',0,0,'2012-11-29 09:00:01','','','','','','','','','','',''),(5,'Steve','Jobs','steve@apple.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',3,'','','','','','','','',0,0,'2012-12-05 08:53:36','','','','','','','','','','',''),(6,'Robyn','Simpson','robyn@marketsmartly.com','f09e0c1931a31bdaed0f1620107e7c304b0de9d4cca399253584bca2dfb239c7',3,'','','','','','','','',0,0,'2012-12-05 14:07:15','','','','','','','','','','',''),(7,'Chris','Rutherford','chris@propertyowl.com.au','43aec9225b767d1bf5f2a07f939f882c1428fa47d2c9b57cfe880586b87806a7',3,'','','','0414924551','','','','',0,0,'2012-12-05 15:37:44','','','','','','','','','','',''),(8,'Rob','Hunt','rob@propertyowl.com.au','f230a0f847872926d99fcd9ecfbcf6632bc4aebe7d51174ad05192e267af85f0',3,'Property Owl Pty Ltd','0412741211','0412741211','0412741211','2, 19 Daniells Street','Carina','','4152',1,1,'2012-12-06 13:53:26','','','','','','','','','','',''),(9,'Alice','Ledner','Cole_Stanton@marcus.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',2,'','','','','','','','',0,0,'2012-12-08 18:21:34','','','','','','','','','','',''),(10,'Kaylin','Olson','Ernie_Schmitt@maurine.com','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',3,'','','','','','','','',0,0,'2012-12-08 18:22:12','','','','','','','','','','',''),(11,'Test','Buyer','buyer@propertyowl.com.au','7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73',1,'','','','','','','','',0,0,'2012-12-09 10:59:00','','','','','','','','','','','');
/*!40000 ALTER TABLE `po_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `raf`
--

DROP TABLE IF EXISTS `raf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `raf` (
  `raf_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `comment` text NOT NULL,
  `entity_id` mediumint(9) NOT NULL,
  `entity_type` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`raf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raf`
--

LOCK TABLES `raf` WRITE;
/*!40000 ALTER TABLE `raf` DISABLE KEYS */;
INSERT INTO `raf` VALUES (2,1,'pyro@feisty.io','4444 5555','nick','kinsey','test',47,'owl','2012-12-31 04:58:48','2012-12-31 04:58:48');
/*!40000 ALTER TABLE `raf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `searches`
--

DROP TABLE IF EXISTS `searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searches` (
  `search_id` int(11) NOT NULL AUTO_INCREMENT,
  `suburb` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `development_type_id` int(11) DEFAULT NULL,
  `minPrice` int(11) DEFAULT NULL,
  `maxPrice` int(11) DEFAULT NULL,
  `minBeds` int(11) DEFAULT NULL,
  `maxBeds` int(11) DEFAULT NULL,
  `bathrooms` int(11) DEFAULT NULL,
  `cars` int(11) DEFAULT NULL,
  PRIMARY KEY (`search_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `searches`
--

LOCK TABLES `searches` WRITE;
/*!40000 ALTER TABLE `searches` DISABLE KEYS */;
INSERT INTO `searches` VALUES (1,'test','all','2013-01-02 17:26:15','2013-01-02 17:26:15',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'test','all','2013-01-02 17:26:40','2013-01-02 17:26:40',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'test','all','2013-01-02 17:29:07','2013-01-02 17:29:07',0,0,0,0,0,0,0),(4,'chuwar','qld','2013-01-02 17:29:35','2013-01-02 17:29:35',1,50000,100000,3,4,4,5);
/*!40000 ALTER TABLE `searches` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-01-03 13:24:30
