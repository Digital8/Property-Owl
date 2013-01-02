async = require 'async'

system = require '../../system'
db = system.db

models =
  users: system.load.model 'user'
  advertisers: system.load.model 'advertiser'

Deal = system.models.deal

helpers = {}

exports.index = (req,res) ->
  db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['barn'], (err, barns) ->
    db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['owl'], (err, owls) ->
      res.render 'admin/reports/index', barns: barns or {}, owls: owls or {}

months = [
  'jan' : 1
  'feb' : 2
  'mar' : 3
  'apr' : 4
  'may' : 5
  'jun' : 6
  'jul' : 7
  'aug' : 8
  'sep' : 9
  'oct' : 10
  'nov' : 11
  'dec' : 12
]

exports.dealListings = (req,res) ->
  listings = [
    'created_at':'01/10/2012'
    'developer':'Developer 1'
    'status':'current'
    'owl_deal_count':'12'
    'barn_deal_count':'14'
  ]

  cred = 
    state: req.query.state or '%'
    month: req.query.month or ''

  if cred.state is 'all' then cred.state = '%'

  unless cred.month is '' then cred.month = months[cred.month] or ''
  
  models.users.getUsersByGroup 2, (err, developers) ->
    Deal.getByMonth cred, (err, results) ->
      if err then console.log err
      res.render 'admin/reports/dealListings', listings: listings or {}, developers: developers or {}

exports.websiteRegistrations = (req,res) ->
  
  cred = 
    state: req.query.state or '%'
    month: req.query.month or ''

  if cred.state is 'all' then cred.state = '%'

  unless cred.month is '' then cred.month = months[cred.month] or ''

  models.users.getByMonth cred, (err, results) ->
    if err then console.log err
    
    res.render 'admin/reports/websiteRegistrations', members: results or {}

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
  
  res.render 'admin/reports/propertySearches', searches: searches or {}, propertyTypes: {}

exports.dealRegistrations = (req,res) ->
  registrations = [
    'date':'01/10/2012'
    'user_name':'John Doe'
    'status':'Interested'
    'owl_deal_count':'34'
    'barn_deal_count':'34'
  ]
  
  res.render 'admin/reports/dealRegistrations', registrations: registrations or {}, members: members or {}

exports.servicesEnquiries = (req,res) ->
  enquiries = [
    'date':'01/10/2012'
    'supplier':'Company 1'
    'enquiry_count':'24'
  ]

  res.render 'admin/reports/servicesEnquiries', enquiries: enquiries or {}, suppliers: suppliers or {}

exports.advertisingClicks = (req,res) ->
  adverts = [
    'advertisement_id':'1'
    'created_at':'01/10/2012'
    'advertiser':'Advertiser 1'
    'ad':'ad 282'
    'clickthroughs':'34'
  ]
  
  res.render 'admin/reports/advertisingClicks', adverts: adverts or {}, advertisers: advertisers or {}
