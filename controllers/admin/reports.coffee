async = require 'async'

system = require '../../system'

models =
  users: system.load.model 'user'

helpers = {}

exports.index = (req,res) ->
  res.render 'admin/reports/index', menu: 'reports'

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
  
  res.render 'admin/reports/propertySearches', searches: searches or {}, menu: 'reports'

exports.dealRegistrations = (req,res) ->
  registrations = [
    'date':'01/10/2012'
    'user_name':'John Doe'
    'status':'Interested'
    'owl_deal_count':'34'
    'barn_deal_count':'34'
  ]
  
  res.render 'admin/reports/dealRegistrations', registrations: registrations or {}, menu: 'reports'

exports.servicesEnquiries = (req,res) ->
  enquiries = [
    'date':'01/10/2012'
    'supplier':'Company 1'
    'enquiry_count':'24'
  ]
  
  res.render 'admin/reports/servicesEnquiries', enquiries: enquiries or {}, menu: 'reports'

exports.advertisingClicks = (req,res) ->
  adverts = [
    'advertisement_id':'1'
    'created_at':'01/10/2012'
    'advertiser':'Advertiser 1'
    'ad':'ad 282'
    'clickthroughs':'34'
  ]
    
  res.render 'admin/reports/advertisingClicks', adverts: adverts or {}, menu: 'reports'