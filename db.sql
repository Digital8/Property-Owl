-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 22, 2012 at 10:41 AM
-- Server version: 5.1.44
-- PHP Version: 5.3.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `po`
--

-- --------------------------------------------------------

--
-- Table structure for table `po_account_types`
--

CREATE TABLE IF NOT EXISTS `po_account_types` (
  `account_type_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`account_type_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `po_account_types`
--

INSERT INTO `po_account_types` (`account_type_id`, `name`, `description`) VALUES
(1, 'Potential Buyer', ''),
(2, 'Property Developer', ''),
(3, 'Administrator', '');

-- --------------------------------------------------------

--
-- Table structure for table `po_barn`
--

CREATE TABLE IF NOT EXISTS `po_barn` (
  `barn_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `owner_id` mediumint(8) unsigned NOT NULL,
  `barn_created_at` datetime NOT NULL,
  PRIMARY KEY (`barn_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `po_barn`
--

INSERT INTO `po_barn` (`barn_id`, `title`, `description`, `owner_id`, `barn_created_at`) VALUES
(1, 'the name', '- Developer pays stampduty\r\n- Some thing\r\n- Some other thing\r\n- Some other other thing', 1, '2012-10-18 16:24:58');

-- --------------------------------------------------------

--
-- Table structure for table `po_barn_to_property`
--

CREATE TABLE IF NOT EXISTS `po_barn_to_property` (
  `barn_id` mediumint(8) unsigned NOT NULL,
  `property_id` mediumint(8) unsigned NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `po_barn_to_property`
--

INSERT INTO `po_barn_to_property` (`barn_id`, `property_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `po_deals`
--

CREATE TABLE IF NOT EXISTS `po_deals` (
  `deal_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `deal_type_id` int(10) unsigned NOT NULL,
  `property_id` mediumint(8) unsigned NOT NULL,
  `created_by` mediumint(8) unsigned NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `po_deals`
--


-- --------------------------------------------------------

--
-- Table structure for table `po_deal_types`
--

CREATE TABLE IF NOT EXISTS `po_deal_types` (
  `deal_type_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`deal_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `po_deal_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `po_media`
--

CREATE TABLE IF NOT EXISTS `po_media` (
  `media_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` mediumint(8) unsigned NOT NULL,
  `filename` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`media_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `po_media`
--


-- --------------------------------------------------------

--
-- Table structure for table `po_news`
--

CREATE TABLE IF NOT EXISTS `po_news` (
  `news_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` mediumtext NOT NULL,
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`news_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `po_news`
--

INSERT INTO `po_news` (`news_id`, `user_id`, `title`, `content`, `posted_at`) VALUES
(1, 1, 'test', 'hello this is a test post woo!', '2012-10-09 10:02:11'),
(3, 1, 'testing 2', 'Test of another post :o', '2012-10-13 00:44:53');

-- --------------------------------------------------------

--
-- Table structure for table `po_properties`
--

CREATE TABLE IF NOT EXISTS `po_properties` (
  `property_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `state` varchar(5) NOT NULL,
  `description` text NOT NULL,
  `property_type_id` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '0',
  `bedrooms` int(11) NOT NULL DEFAULT '0',
  `bathrooms` int(11) NOT NULL DEFAULT '0',
  `cars` int(11) NOT NULL DEFAULT '0',
  `development_stage` varchar(100) NOT NULL,
  `feature_image` varchar(100) NOT NULL,
  `listed_by` mediumint(8) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`property_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_properties`
--

INSERT INTO `po_properties` (`property_id`, `title`, `address`, `state`, `description`, `property_type_id`, `price`, `bedrooms`, `bathrooms`, `cars`, `development_stage`, `feature_image`, `listed_by`, `created_at`) VALUES
(1, 'deal of a lifetime!', '123 example street', 'qld', 'This is a once in a life time opportunity', 1, 345000, 4, 2, 2, '', '', 1, '2012-10-08 19:49:47'),
(2, 'Qld property!', '345 fake road', 'qld', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(3, 'Blue wonder', '11 Caithness Street', 'nsw', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(4, 'Cold estate', '27 Mansion Court', 'vic', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(5, 'Title', '12 Karen Court', 'nt', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(6, 'Wow, awesome!', '9 Ellie Court', 'wa', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(7, 'LOCATION LOCATION LOCATION', '26 Kurrajong Street', 'sa', 'some descriptive description', 3, 1341411, 2, 2, 1, '', '', 1, '2012-10-19 09:54:52'),
(8, 'Some final entry', '123 example street', 'tas', 'This is a once in a life time opportunity', 1, 345000, 4, 2, 2, '', '', 1, '2012-10-08 19:49:47');

-- --------------------------------------------------------

--
-- Table structure for table `po_property_types`
--

CREATE TABLE IF NOT EXISTS `po_property_types` (
  `property_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`property_type_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `po_property_types`
--

INSERT INTO `po_property_types` (`property_type_id`, `type`) VALUES
(1, 'House'),
(2, 'Townhouse'),
(3, 'Unit'),
(4, 'Apartment'),
(5, 'Land'),
(6, 'House & Land'),
(7, 'Vila'),
(8, 'Acerage');

-- --------------------------------------------------------

--
-- Table structure for table `po_users`
--

CREATE TABLE IF NOT EXISTS `po_users` (
  `user_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `user_address` text NOT NULL,
  `account_type_id` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_users`
--

INSERT INTO `po_users` (`user_id`, `first_name`, `last_name`, `email`, `password`, `user_address`, `account_type_id`) VALUES
(1, 'Brendan', 'Scarvell', 'bscarvell@gmail.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', '', 3),
(2, 'Test', 'Developer', 'foo@bar.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', '', 2);
