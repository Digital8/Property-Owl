async = require 'async'

system = require '../../system'
db = system.db

models =
  users: system.load.model 'user'
  services: system.load.model 'services'
  advertisers: system.load.model 'advertiser'
  properties: system.load.model 'properties'

helpers = {}

exports.index = (req,res) ->
  db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['barn'], (err, barns) ->
    db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['owl'], (err, owls) ->
      res.render 'admin/reports/index', barns: barns or {}, owls: owls or {}, menu: 'reports'

exports.dealListings = (req,res) ->
  listings = [
    'created_at':'01/10/2012'
    'developer':'Developer 1'
    'status':'current'
    'owl_deal_count':'12'
    'barn_deal_count':'14'
  ]
  
  models.users.getUsersByGroup 2, (err, developers) ->
  
    res.render 'admin/reports/dealListings', listings: listings or {}, developers: developers or {}, menu: 'reports'

exports.websiteRegistrations = (req,res) ->
  registrations = [
    'created_at':'01/10/2012'
    'state':'QLD'
    'count':'241'
  ]
  
  res.render 'admin/reports/websiteRegistrations', registrations: registrations or {}, menu: 'reports'

exports.propertySearches = (req,res) ->
  searches = [
    'date':'01/10/2012'
    'state':'QLD'
    'property_type':'Apartment'
    'deal_type':'Owl Deal'
    'stage':'Completed'
    'price':'$300,000 - $400,000'
    'search_count':'427'
  ]
  models.properties.getPropertyTypes (err, propertyTypes) ->
  
    res.render 'admin/reports/propertySearches', searches: searches or {}, propertyTypes: propertyTypes or {}, menu: 'reports'

exports.dealRegistrations = (req,res) ->
  registrations = [
    'date':'01/10/2012'
    'user_name':'John Doe'
    'status':'Interested'
    'owl_deal_count':'34'
    'barn_deal_count':'34'
  ]
  models.users.getUsersByGroup 1, (err, members) ->
    res.render 'admin/reports/dealRegistrations', registrations: registrations or {}, members: members or {}, menu: 'reports'

exports.servicesEnquiries = (req,res) ->
  enquiries = [
    'date':'01/10/2012'
    'supplier':'Company 1'
    'enquiry_count':'24'
  ]
  models.services.getAllServices (err, suppliers) ->
  
    res.render 'admin/reports/servicesEnquiries', enquiries: enquiries or {}, suppliers: suppliers or {}, menu: 'reports'

exports.advertisingClicks = (req,res) ->
  adverts = [
    'advertisement_id':'1'
    'created_at':'01/10/2012'
    'advertiser':'Advertiser 1'
    'ad':'ad 282'
    'clickthroughs':'34'
  ]
  models.advertisers.all (err, advertisers) ->
    res.render 'admin/reports/advertisingClicks', adverts: adverts or {}, advertisers: advertisers or {}, menu: 'reports'