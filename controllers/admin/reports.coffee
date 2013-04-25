async = require 'async'

system = require '../../system'
db = system.db

models =
  users: system.load.model 'user'
  advertisers: system.load.model 'advertiser'
  registrations: system.load.model 'registrations'

Deal = system.models.deal
AdClicks = system.models.click
Enquriy = system.models.enquiry
Search = system.models.search

helpers = {}

exports.index = (req,res) ->
  db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['barn'], (err, barns) ->
    db.query "SELECT CONCAT(YEAR(registered_at),'-',MONTH(registered_at),'-01') AS 'date', Count(*) as 'count' FROM po_registrations WHERE type = ? GROUP BY YEAR(registered_at), MONTH(registered_at)", ['owl'], (err, owls) ->
      res.render 'admin/reports/index', barns: barns or {}, owls: owls or {}

months =
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

exports.dealListings = (req,res) ->

  cred = 
    state: req.query.state or '%'
    status: req.query.status or '1'
    month: req.query.month or ''
    developer: req.query.developer or '0'

  if cred.state is 'all' then cred.state = '%'
  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''

  models.users.getUsersByGroup 2, (err, developers) ->
    Deal.getByMonth cred, (err, listings) ->
      if err then console.log err
      #remove epic spam
      #console.log listings
      Deal.getByUser cred, (err, dev_count) ->
        if err then console.log err
        res.render 'admin/reports/dealListings', listings: listings or {}, developers: developers or {}, dev_count: dev_count or {}

exports.websiteRegistrations = (req,res) ->
  
  cred = 
    state: req.query.state or '%'
    month: req.query.month or ''

  if cred.state is 'all' then cred.state = '%'
  if cred.month is 'all' then cred.month = '%'

  unless cred.month is '' then cred.month = months[cred.month] or ''

  models.users.getByMonth cred, (err, results) ->
    if err then console.log err
    
    res.render 'admin/reports/websiteRegistrations', members: results or {}

exports.propertySearches = (req,res) ->
  cred = 
    state: req.query.state or ''
    month: req.query.month or ''

  if cred.state is 'all' then cred.state = '%'
  if cred.month is 'all' then cred.month = '%'

  unless cred.month is '' then cred.month = months[cred.month] or ''

  Search.report cred, (err, searches) ->
    if err then console.log err
    res.render 'admin/reports/propertySearches', searches: searches or {}, propertyTypes: {}

exports.dealRegistrations = (req,res) ->
  cred = 
    month: req.query.month or ''

  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''

  models.registrations.report cred, (err, registrations) ->
    if err then console.log err
    res.render 'admin/reports/dealRegistrations', registrations: registrations or {}, members: {}

exports.servicesEnquiries = (req,res) ->
  cred = 
    month: req.query.month or ''
    advertiser: req.query.advertiser or '0'

  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''

  Enquriy.report cred, (err, enquiries) ->
    if err then console.log err
    res.render 'admin/reports/servicesEnquiries', enquiries: enquiries or {}, suppliers: {}

exports.advertisingClicks = (req,res) ->

  models.advertisers.all (err, advertisers) ->
    cred = 
      month: req.query.month or 'all'
      advertiser: req.query.advertiser or '0'

    if cred.month is 'all' then cred.month = '%'
    unless cred.month is '' then cred.month = months[cred.month] or ''

    AdClicks.report cred, (err, clicks) ->
      if err then console.log err
      
      res.render 'admin/reports/advertisingClicks', advertisers: advertisers or {}, clicks: clicks or {}
