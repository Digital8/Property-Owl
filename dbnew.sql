/*
-- Query: SELECT * FROM po.po_adspaces
LIMIT 0, 1000

-- Date: 2012-11-27 12:11
*/
INSERT INTO `po_adspaces` (`adspace_id`,`name`) VALUES (1,'Top');
INSERT INTO `po_adspaces` (`adspace_id`,`name`) VALUES (2,'Upper Tower');
INSERT INTO `po_adspaces` (`adspace_id`,`name`) VALUES (3,'Lower Tower');
INSERT INTO `po_adspaces` (`adspace_id`,`name`) VALUES (4,'Upper Box');
INSERT INTO `po_adspaces` (`adspace_id`,`name`) VALUES (5,'Lower Box');

/*
-- Query: SELECT * FROM po.po_advertisements
LIMIT 0, 1000

-- Date: 2012-11-27 12:11
*/
INSERT INTO `po_advertisements` (`advertisement_id`,`description`,`advertiser_id`,`page_id`,`adspace_id`,`image_id`,`hyperlink`,`visible`,`created_at`,`start`,`stop`) VALUES (9,'CWB \"Summer 2012\" offensive',18,1,1,'628b4c27-3de1-4d8c-9df1-77fe72db8741','http://commbank.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','');
INSERT INTO `po_advertisements` (`advertisement_id`,`description`,`advertiser_id`,`page_id`,`adspace_id`,`image_id`,`hyperlink`,`visible`,`created_at`,`start`,`stop`) VALUES (8,'ANZ \"Mayan\" engagement',18,2,1,'1b64d0ed-8c38-4866-8d92-fe5b76b6133a','http://anz.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','');
INSERT INTO `po_advertisements` (`advertisement_id`,`description`,`advertiser_id`,`page_id`,`adspace_id`,`image_id`,`hyperlink`,`visible`,`created_at`,`start`,`stop`) VALUES (7,'Westpac \"X-mas\" 2012 Campaign',18,1,1,'84e6a44f-680a-4475-b724-69dfe690f310','http://westpac.com.au',1,'0000-00-00 00:00:00','0000-00-00 00:00:00','');

/*
-- Query: SELECT * FROM po.po_advertisers
LIMIT 0, 1000

-- Date: 2012-11-27 12:11
*/
INSERT INTO `po_advertisers` (`advertiser_id`,`name`,`description`,`contactee`,`email`,`phone`,`address`,`suburb`,`state`,`postcode`,`advertiser_created_at`) VALUES (18,'INC','Australia\'s largest retail advertising network','Luke Hillier','luke.hillier@inc.co','(03) 9016 7943','31 Coventry St','South Melbourne','Victoria','3205','2012-11-26 22:44:07');
