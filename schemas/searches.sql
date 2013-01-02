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