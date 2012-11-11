-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 11, 2012 at 11:39 AM
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
-- Table structure for table `po_admin_pages`
--

CREATE TABLE IF NOT EXISTS `po_admin_pages` (
  `admin_page_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`admin_page_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `po_admin_pages`
--

INSERT INTO `po_admin_pages` (`admin_page_id`, `name`, `url`, `enabled`) VALUES
(1, 'News', 'news', 1),
(2, 'Members', 'members', 1),
(3, 'Services', 'services', 1),
(4, 'Custom Pages', 'pages', 1),
(5, 'Properties', 'properties/add', 1);

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
-- Table structure for table `po_bookmarks`
--

CREATE TABLE IF NOT EXISTS `po_bookmarks` (
  `bookmark_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` mediumint(8) unsigned NOT NULL,
  `type` varchar(50) NOT NULL,
  `resource_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`bookmark_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `po_bookmarks`
--


-- --------------------------------------------------------

--
-- Table structure for table `po_deals`
--

CREATE TABLE IF NOT EXISTS `po_deals` (
  `deal_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `property_id` mediumint(8) unsigned NOT NULL,
  `created_by` mediumint(8) unsigned NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`deal_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_deals`
--

INSERT INTO `po_deals` (`deal_id`, `type`, `property_id`, `created_by`, `value`, `approved`) VALUES
(1, 'stamp duty', 9, 1, 10000, 0),
(2, 'furniture package', 9, 1, 2000, 0);

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
  `owner_id` mediumint(8) unsigned NOT NULL,
  `filename` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `image` tinyint(1) NOT NULL DEFAULT '0',
  `uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`media_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `po_media`
--

INSERT INTO `po_media` (`media_id`, `property_id`, `owner_id`, `filename`, `description`, `image`, `uploaded`) VALUES
(1, 9, 1, '4faff930-287a-11e2-94f7-bbcff633a73b.mp3', 'beep :)', 0, '2012-11-07 11:27:36'),
(2, 9, 1, 'd481be50-287a-11e2-94f7-bbcff633a73b.jpg', 'news-thumb', 0, '2012-11-07 11:31:19'),
(4, 9, 1, '465a3200-2943-11e2-a445-2f39375b57ff.png', '', 1, '2012-11-08 11:26:09'),
(11, 9, 1, '8ad19750-2945-11e2-b4bc-5f66e9f836b9.jpg', '', 1, '2012-11-08 11:42:23');

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `po_news`
--

INSERT INTO `po_news` (`news_id`, `user_id`, `title`, `content`, `posted_at`) VALUES
(1, 1, 'test', 'hello this is a test post woo!', '2012-10-09 10:02:11'),
(3, 1, 'testing 2', 'Test of another post :o', '2012-10-13 00:44:53');

-- --------------------------------------------------------

--
-- Table structure for table `po_pages`
--

CREATE TABLE IF NOT EXISTS `po_pages` (
  `page_id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(100) NOT NULL,
  `header` varchar(100) NOT NULL,
  `content` mediumtext NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `page_created_at` datetime NOT NULL,
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `po_pages`
--

INSERT INTO `po_pages` (`page_id`, `url`, `header`, `content`, `enabled`, `page_created_at`) VALUES
(1, '/about', 'About Property Owl', '<p>Propertyowl.com.au was established by a group of real estate and marketing professionals to assist buyers of residential property access to the best discounts, offers, deals or incentives that a residential property developer (seller) will provide.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is Australia''s first to provide residential property developers with their own unique website platform specifically developed to showcase and sell their products without being lost amongst the thousands of private sellers of homes, land, apartments, units, townhouses, etc.\r\n</p>\r\n<p>\r\nThe website allows property developers a greater reach to larger audiences of prospective buyers who have a particular interest in new properties.\r\n</p>\r\n<p>\r\nThe propertyowl.com.au website provides our subscribers with genuine deals without having to cut through the noise of advertising, marketing hype and pushy sales people.\r\n</p>\r\n<p>\r\nThe website has been developed to provide full disclosure of all known information relating to a residential product/development either ''off the plan'' or ''completed'' so that our registered subscribers to propertyowl.com.au can make informed buying decisions, whilst also taking advantage of the great deals on offer.\r\n</p>\r\n<p>\r\nPropertyowl.com.au uses its best endeavours to obtain all known information that relates to specific residential developments advertised on the website. We value the feedback that you provide us as it enables us to constantly improve our site.\r\n</p>\r\n<p>\r\nPropertyowl.com.au is committed to enriching the lives of Australians through its support of charitable organisations and innovative programs to build strong and nurturing communities.\r\n</p>', 1, '2012-11-05 12:10:22'),
(2, '/terms-and-conditions', 'Terms and Conditions', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus.<br /> <br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '0000-00-00 00:00:00'),
(14, '/faq', 'Frequently Asked Questions', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 0, '2012-11-06 09:14:04'),
(15, '/privacy', 'Privacy Policy', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '2012-11-06 09:14:51'),
(16, '/research', 'Research', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '2012-11-06 09:17:14');

-- --------------------------------------------------------

--
-- Table structure for table `po_properties`
--

CREATE TABLE IF NOT EXISTS `po_properties` (
  `property_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `state` varchar(5) NOT NULL,
  `description` text NOT NULL,
  `property_type_id` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '0',
  `bedrooms` int(11) NOT NULL DEFAULT '0',
  `bathrooms` int(11) NOT NULL DEFAULT '0',
  `cars` int(11) NOT NULL DEFAULT '0',
  `development_stage` varchar(100) NOT NULL,
  `internal_area` varchar(50) NOT NULL,
  `external_area` varchar(50) NOT NULL,
  `feature_image` varchar(100) NOT NULL,
  `listed_by` mediumint(8) unsigned NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`property_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `po_properties`
--

INSERT INTO `po_properties` (`property_id`, `title`, `address`, `suburb`, `state`, `description`, `property_type_id`, `price`, `bedrooms`, `bathrooms`, `cars`, `development_stage`, `internal_area`, `external_area`, `feature_image`, `listed_by`, `approved`, `created_at`) VALUES
(2, 'Qld property!', '345 fake road', '', 'qld', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(1, 'deal of a lifetime!', '123 example street', '', 'qld', 'This is a once in a life time opportunity', 6, 345000, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-08 19:49:47'),
(3, 'Blue wonder', '11 Caithness Street', '', 'nsw', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(4, 'Cold estate', '27 Mansion Court', '', 'vic', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(5, 'Title', '12 Karen Court', '', 'nt', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(6, 'Wow, awesome!', '9 Ellie Court', '', 'wa', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(7, 'LOCATION LOCATION LOCATION', '26 Kurrajong Street', '', 'sa', 'some descriptive description', 3, 1341411, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-19 09:54:52'),
(8, 'Some final entry', '123 example street', '', 'tas', 'This is a once in a life time opportunity', 1, 345000, 1, 1, 1, '', '', '', '', 1, 0, '2012-10-08 19:49:47'),
(9, 'Foobar', '12 fazcvn street', '', 'qld', 'this is a foobar', 1, 10, 1, 2, 3, '', '', '', '', 2, 0, '2012-11-06 18:32:56'),
(10, 'Redbank Plains', '12 Karen Corut', 'Redbank Plains', 'qld', 'This is a redbank plains', 1, 900000, 0, 0, 0, 'completed', '', '', '', 2, 0, '2012-11-08 22:34:19');

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
-- Table structure for table `po_services`
--

CREATE TABLE IF NOT EXISTS `po_services` (
  `service_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `image` varchar(100) NOT NULL,
  `service_created_at` datetime NOT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_services`
--

INSERT INTO `po_services` (`service_id`, `name`, `description`, `image`, `service_created_at`) VALUES
(1, 'testaroo', 'this is a test service', '', '2012-11-06 10:27:16'),
(2, 'testing 2..', 'this is another test service', '', '2012-11-06 10:27:16');

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_users`
--

INSERT INTO `po_users` (`user_id`, `first_name`, `last_name`, `email`, `password`, `account_type_id`, `company`, `phone`, `work_phone`, `mobile`, `address`, `suburb`, `state`, `postcode`, `subscribed_newsletter`, `subscribed_alerts`) VALUES
(1, 'Brendan', 'Scarvell', 'bscarvell@gmail.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', 3, 'Digital8', '', '', '0478 613 007', '12 Karen Court', 'Redbank Plains', 'qld', '4301', 0, 0),
(2, 'Test', 'Developer', 'foo@bar.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', 2, '', '', '', '', '', '', '', '', 0, 0);
