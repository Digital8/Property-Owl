CREATE TABLE IF NOT EXISTS `enquiries` (
  `enquiry_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL,
  `affiliate_id` mediumint(8) unsigned NOT NULL,
  `enquiry` text NOT NULL,
  `sent_at` datetime NOT NULL,
  PRIMARY KEY (`enquiry_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;