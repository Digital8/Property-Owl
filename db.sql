-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 25, 2012 at 04:26 PM
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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `po_admin_pages`
--

INSERT INTO `po_admin_pages` (`admin_page_id`, `name`, `url`, `enabled`) VALUES
(1, 'News', 'news', 1),
(2, 'Members', 'members', 1),
(3, 'Services', 'services', 1),
(4, 'Custom Pages', 'pages', 1),
(5, 'Properties', 'properties', 1),
(7, 'Reports', 'reports', 1);

-- --------------------------------------------------------

--
-- Table structure for table `po_barn`
--

CREATE TABLE IF NOT EXISTS `po_barn` (
  `barn_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` mediumint(8) unsigned NOT NULL,
  `lot` int(11) NOT NULL,
  `bed` int(11) NOT NULL,
  `bath` int(11) NOT NULL,
  `car` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `internal_size` varchar(100) NOT NULL,
  `external_size` varchar(100) NOT NULL,
  `aspect` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`barn_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `po_barn`
--


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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `po_deals`
--

INSERT INTO `po_deals` (`deal_id`, `type`, `property_id`, `created_by`, `value`, `approved`) VALUES
(9, 'afo', 9, 1, 10000, 0);

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
-- Table structure for table `po_lots`
--

CREATE TABLE IF NOT EXISTS `po_lots` (
  `lot_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` mediumint(8) unsigned NOT NULL,
  `bedrooms` tinyint(4) NOT NULL,
  `bathrooms` tinyint(4) NOT NULL,
  `carspaces` tinyint(4) NOT NULL,
  `level` int(11) NOT NULL,
  `interior_size` int(11) NOT NULL,
  `exterior_size` int(11) NOT NULL,
  `aspect` varchar(10) NOT NULL,
  `floor_plan` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`lot_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `po_lots`
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
  `hero` tinyint(1) NOT NULL DEFAULT '0',
  `uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`media_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `po_media`
--

INSERT INTO `po_media` (`media_id`, `property_id`, `owner_id`, `filename`, `description`, `image`, `hero`, `uploaded`) VALUES
(11, 9, 1, '8ad19750-2945-11e2-b4bc-5f66e9f836b9.jpg', '', 1, 1, '2012-11-24 08:04:42'),
(12, 9, 1, 'ea037e10-3394-11e2-bad3-cd982acbcfc3.JPG', 'photo.JPG', 0, 0, '2012-11-21 14:35:44'),
(13, 9, 1, 'd77d3cf0-3460-11e2-a1c1-75b0dcd6ca17.png', 'profile-pic.png', 1, 0, '2012-11-24 08:04:42');

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
(1, 1, 'test', 'hello this is a test post woo!', '2012-10-09 10:02:11');

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
(2, '/terms-and-conditions', 'Terms and Conditions', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus.\r\n \r\nSed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.\r\n\r\nMaecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '0000-00-00 00:00:00'),
(14, '/faq', 'Frequently Asked Questions', '<h1>FAQS</h1>\r\n<h3>What is Property Owl?</h3>\r\n<p>Property owl.com.au is a deal based website specifically created for new property. It allows subscribers to search a large variety of residential property types across Australia whilst taking advantage of the many deals offered by Sellers.</p>\r\n<p>Property Owl was formed by a group of like-minded sales and marketing professionals to bring the very best in property deals to the market place. Property Owl has done the leg work for you as we understand that your time is precious.</p>\r\n<h3>Is there a cost in joining Property Owl?</h3>\r\n<p>No. There are no associated costs or joining fees when becoming a subscriber to the Property Owl website.</p>\r\n<h3>What is the advantage of becoming a subscriber of Property Owl?</h3>\r\n<p>You will enjoy being the first to view all the best and exclusive weekly residential property deals across Australia.</p>\r\n<h3>Are the deals advertised Exclusive to Property Owl?</h3>\r\n<p>Yes. All Property Owl deals are exclusive whereby the respective Seller has entered into a binding contractual arrangement for a specified time frame. Sellers will provide exclusive deals that cannot be marketed or advertised in other mediums.</p>\r\n<h3>Why would I not just contact a developer directly to obtain the same deal that has been advertised on Property Owl?</h3>\r\n<p>You can contact the Seller but the deal on offer is exclusive to Property owl and not available through agents or the Seller direct.</p>\r\n<h3>Will any of my personal information be used for any other purpose other than Property Owl updates?</h3>\r\n<p>No. Your personal information will not be used for any purpose other than to provide you with Property Owl updates should you wish to receive them. Your personal information will not be used for or provided to any other third party.</p>\r\n<h3>How does Property Owl work?</h3>\r\n<p>Once you have registered with Property Owl, you can search all new property deals as they become available. Simply fill in the required information to secure a deal or complete the enquiry form to request further information. If you decide to take up the purchase of an advertised property deal then simply click on the ‘Secure the Deal’ tab and provide the required information. Once completed simply click ‘Submit’.</p>\r\n<h3>Why was Property Owl developed?</h3>\r\n<p>Property Owl has been developed for two reasons.</p>\r\n<ol><li>To provide Sellers of new property with their own unique internet platform to advertise and sell their products to the wider market place, and</li>\r\n<li>To provide Property Owl subscribers with the best deals on offer from Sellers across Australia.</li>\r\n</ol>\r\n<h3>How do I obtain further information in relation to a property that appeals to me?</h3>\r\n<p>Simply complete the Enquire About This Deal section in the left hand column. Your email will be responded to by the Seller or the Sellers nominated representative.</p>\r\n<h3>How do I know I have the best deal available?</h3>\r\n<p>The Seller guarantees to Property Owl that the deal will be the best available.</p>\r\n<h3>How long does a Property Owl deal last?</h3>\r\n<p>Each deal will last for one week. As you can understand, these will be the best deals on offer from each respective Seller, therefore, one week is the maximum time available, unless sold out prior. The deal can remain listed on the website for a longer period however the deal or offer may not be as good as when it was first advertised.</p>\r\n<h3>How do I purchase a property advertised on Property Owl?</h3>\r\n<p>Simply, click on the ‘Secure the Deal’ tab and enter the information required. A representative of the Seller will be in contact with you to verify your intention to purchase and to explain the buying process.</p>\r\n<h3>What is the process to be adopted when purchasing a Property Owl?</h3>\r\n<p>Property Owl will pass your information to the Sellers nominated agents who will commence the sales contract process with you. The standard legislative\r\nrequirements for each State or Territory will be adhered to be adhered to by the Seller / Agents.</p>\r\n<h3>If I am a Foreign Investor (Overseas Purchaser) can I purchase property through Property Owl?</h3>\r\n<p>Yes. New dwellings acquired ‘off the plan’ (before construction commences or during the construction phase) or after construction is complete are normally approved for purchase by Foreign Investors where the dwellings:</p>\r\n<ul><li>have not previously been sold (that is, they are purchased from the Seller); and</li>\r\n<li>have not been occupied for more than 12 months.</li></ul>\r\n<p>There are no restrictions on the number of such properties in a new development which may be sold to foreign persons, provided that a Seller markets the properties locally as well as overseas (that is, the properties cannot be marketed exclusively overseas).</p>\r\n<p>This category includes dwellings that are part of extensively refurbished buildings where the building''s use has undergone a change from non-residential (for example, office or warehouse) to residential. It does not include established residential real estate that has been refurbished or renovated.</p>\r\n<p>A property purchased under this category may be rented out, sold to Australian interests or other eligible purchasers, or retained for the foreign investor''s own use. Once the property has been purchased, it is second-hand real estate and is subject to the restrictions applying to that category.</p>\r\n<h3>Am I legally bound to purchase a Property Owl property after I have submitted an enquiry for further information?</h3>\r\n<p>No. You are not legally bound at any stage, unless of course you choose to purchase one of the advertised properties and there enter into a contract between yourself and the Seller. Once contracts and other documentation have been signed and executed between the parties then you will be bound by the terms and conditions of the contract. State and Territory legislative requirements must still be adhered to by both parties.</p>\r\n<h3>Am I required to pay a deposit if I decide to purchase an apartment?</h3>\r\n<p>Yes. The usual practice is for the Seller to request an initial holding deposit amount (consideration) in order that the property you are seeking to purchase is held off the market. Once contracts etc. have been executed by the Buyer and Seller than a further deposit amount will be payable. The total amount payable usually equates to 10 per cent of the purchase price.</p>\r\n<h3>What forms of deposit will be acceptable to the developer?</h3>\r\n<p>There are three main types of deposit – cash, deposit bonds and bank guarantee. Each deal will contain information as to which method(s) the Seller will accept, however you will usually find that they will accept all of the aforementioned deposit types.</p>\r\n<h3>What are my legal obligations once I have entered into a contract to purchase a property through Property Owl?</h3>\r\n<p>All requirements under relevant state legislation and guidelines must be adhered to including your right to obtain independent legal advice prior to entering into a contract.</p>\r\n<h3>What happens if I refer a friend who purchases a property through Property Owl?</h3>\r\n<p>We thank you for your trust and loyalty to Property Owl. To reward you for this referral Property Owl will provide you with a token of our appreciation. This will be in the form of a cash gratuity (nest egg) to the value of $1000.00 payable in accordance with the Seller''s payment to Property Owl.</p>\r\n<p>If you and one other both refer the same person to a property on the Property Owl website, then the person whose link is used by the new subscriber to subscribe to the Property owl website will be the one who will be entitled to the nest egg should they purchase a property. For any purchase transaction, only one referral fee will be payable.</p>\r\n<h3>As a Property Owl subscriber am I entitled to receive regular research and market updates?</h3>\r\n<p>Yes. As a Property Owl member you will be entitled to receive regular property research and market updates. If you no longer wish to receive property research or market updates then simply un-check the tick box on your profile page. Alternatively, just click on the ‘Wise Owl’ tab on the website to access all the latest in property news and research.</p>', 1, '2012-11-06 09:14:04'),
(15, '/privacy', 'Privacy Policy', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. \r\n\r\nSed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.\r\n\r\nMaecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '2012-11-06 09:14:51'),
(16, '/research', 'Research', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras porttitor, augue auctor lacinia congue, justo arcu imperdiet neque, quis tempus enim felis ut ante. Maecenas non dui sit amet ante ornare ullamcorper. Etiam rutrum pulvinar hendrerit. Sed nibh est, mollis a convallis ut, posuere ut lectus. <br /><br />Sed et nunc tortor. Ut magna augue, volutpat quis tempus nec, pellentesque nec tortor. Maecenas quis enim sapien. Nam iaculis, eros eu vehicula vestibulum, lorem elit facilisis nisi, quis porttitor nisl ante quis dolor.<br /><br />Maecenas gravida dictum justo, non sollicitudin augue iaculis sed. Sed lobortis accumsan justo, sit amet convallis magna placerat aliquam. Curabitur convallis porta justo, et dapibus nunc fermentum nec. Praesent tincidunt viverra quam, vel semper massa dapibus a. Phasellus sit amet risus sed quam imperdiet tempus et ut justo. Nam ut neque eu lorem aliquam bibendum.', 1, '2012-11-06 09:17:14');

-- --------------------------------------------------------

--
-- Table structure for table `po_properties`
--

CREATE TABLE IF NOT EXISTS `po_properties` (
  `property_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `deal_of` int(11) NOT NULL DEFAULT '0',
  `title` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `postcode` varchar(10) NOT NULL,
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
  `deal_type` enum('owl','barn','all') NOT NULL DEFAULT 'owl',
  `listed_by` mediumint(8) unsigned NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`property_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `po_properties`
--

INSERT INTO `po_properties` (`property_id`, `deal_of`, `title`, `address`, `suburb`, `postcode`, `state`, `description`, `property_type_id`, `price`, `bedrooms`, `bathrooms`, `cars`, `development_stage`, `internal_area`, `external_area`, `feature_image`, `deal_type`, `listed_by`, `approved`, `created_at`) VALUES
(2, 0, 'Qld property!', '345 fake road', 'asdf', '1324', 'qld', 'some descriptive descriptionv', 1, 1341411, 3, 2, 2, 'otp', '', '', '', 'barn', 2, 0, '2012-10-19 09:54:52'),
(1, 2, 'deal of a lifetime!', '123 example street', '', '', 'qld', 'This is a once in a life time opportunity', 6, 345000, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-08 19:49:47'),
(3, 2, 'Blue wonder', '11 Caithness Street', '', '', 'nsw', 'some descriptive description', 3, 1341411, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-19 09:54:52'),
(4, 2, 'Cold estate', '27 Mansion Court', '', '', 'vic', 'some descriptive description', 3, 1341411, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-19 09:54:52'),
(5, 0, 'Title', '12 Karen Court', '', '', 'nt', 'some descriptive description', 3, 1341411, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-19 09:54:52'),
(6, 0, 'Wow, awesome!', '9 Ellie Court', '', '', 'wa', 'some descriptive description', 3, 1341411, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-19 09:54:52'),
(7, 0, 'LOCATION LOCATION LOCATION', '26 Kurrajong Street', '', '', 'sa', 'some descriptive description', 3, 1341411, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-19 09:54:52'),
(8, 0, 'Some final entry', '123 example street', '', '', 'tas', 'This is a once in a life time opportunity', 1, 345000, 3, 2, 2, '', '', '', '', 'owl', 1, 0, '2012-10-08 19:49:47'),
(9, 0, 'Foobar', '12 fazcvn street', '', '', 'qld', 'this is a foobar', 1, 140000, 3, 2, 2, '', '', '', '', 'owl', 2, 0, '2012-11-06 18:32:56'),
(10, 0, 'Redbank Plains', '12 Karen Corut', 'Redbank Plains', '', 'qld', 'This is a redbank plains', 1, 900000, 3, 2, 2, 'completed', '', '', '', 'owl', 2, 1, '2012-11-08 22:34:19'),
(17, 0, 'Dont buy it', '12 Bell Street', 'Ipswich', '', 'qld', 'Dont buy this place.', 5, 493100, 3, 2, 2, 'otp', '', '', '', 'all', 2, 0, '2012-11-21 12:06:27');

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
-- Table structure for table `po_saveddeals`
--

CREATE TABLE IF NOT EXISTS `po_saveddeals` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `deal_id` mediumint(8) unsigned NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `po_saveddeals`
--

INSERT INTO `po_saveddeals` (`id`, `deal_id`, `user_id`, `enabled`) VALUES
(1, 9, 1, 0),
(2, 9, 1, 1),
(3, 17, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `po_services`
--

CREATE TABLE IF NOT EXISTS `po_services` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `po_services`
--

INSERT INTO `po_services` (`service_id`, `category_id`, `company`, `logo`, `phone`, `address`, `suburb`, `state`, `email`, `postcode`, `visible`, `description`, `image`, `service_created_at`) VALUES
(1, 2, 'testaroo', '', '', '', 'Ipswich', 'qld', '', '', 0, 'this is a test service', '', '2012-11-06 10:27:16'),
(2, 1, 'testing 2..', '', '', '', 'blacktown', 'nsw', '', '', 0, 'this is another test service', '', '2012-11-06 10:27:16');

-- --------------------------------------------------------

--
-- Table structure for table `po_service_categories`
--

CREATE TABLE IF NOT EXISTS `po_service_categories` (
  `category_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `po_service_categories`
--

INSERT INTO `po_service_categories` (`category_id`, `category`) VALUES
(1, 'Interior Design'),
(2, 'Exterior Designers'),
(3, 'Digital Media');

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
(1, 'Brendan', 'Scarvell', 'bscarvell@gmail.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', 3, 'Digital8', '3288 2222', '3288 1111', '0412 345 678', '123 asdf street!', 'Redbank Plainz', '', '4302', 1, 1),
(2, 'Test', 'Developer', 'foo@bar.com', '7e18d77120b0458d02e9756642c4365df93e263da7b738e6c1aa75d72c5daf73', 2, '', '', '', '', '', '', '', '', 0, 0);

---
--- ad tables
---

delimiter $$

CREATE TABLE `po_adspaces` (
  `adspace_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`adspace_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1$$


delimiter $$

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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1$$


delimiter $$

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
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1$$


