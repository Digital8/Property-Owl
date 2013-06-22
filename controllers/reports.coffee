async = require 'async'

exports.index = (req, res) ->
  
  query = """
  SELECT
    CONCAT(
      YEAR(created_at),
      '-',
      MONTH(created_at),
      '-01'
    ) AS 'date',
    Count(*) as 'count'
  FROM registrations
  WHERE entity_type = ?
  GROUP BY
    YEAR(created_at),
    MONTH(created_at)
  """
  
  async.parallel
    barns: (callback) -> exports.db.query query, ['barn'], (error, rows) -> callback error, rows
    owls:  (callback) -> exports.db.query query, ['owl'],  (error, rows) -> callback error, rows
  , (error, results) ->
    
    return res.send 500, error if error?
    
    res.render 'admin/reports/index', results

months =
  jan: 1
  feb: 2
  mar: 3
  apr: 4
  may: 5
  jun: 6
  jul: 7
  aug: 8
  sep: 9
  oct: 10
  nov: 11
  dec: 12

exports.dealListings = (req,res) ->
  
  cred = 
    state: req.query.state or '%'
    status: req.query.status or '1'
    month: req.query.month or ''
    developer: req.query.developer or '0'
  
  if cred.state is 'all' then cred.state = '%'
  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''
  
  User.getUsersByGroup 2, (err, developers) ->
    Deal.getByMonth cred, (err, listings) ->
      if err then console.log err
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

  User.getByMonth cred, (err, results) ->
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

exports.dealRegistrations = (req, res) ->
  cred = 
    month: req.query.month or ''
  
  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''

  Registration.report cred, (err, registrations) ->
    if err then console.log err
    res.render 'admin/reports/dealRegistrations', registrations: registrations or {}, members: {}

exports.servicesEnquiries = (req, res) ->
  
  cred = 
    month: req.query.month or ''
    advertiser: req.query.advertiser or '0'
  
  if cred.month is 'all' then cred.month = '%'
  unless cred.month is '' then cred.month = months[cred.month] or ''
  
  Enquiry.report cred, (err, enquiries) ->
    if err then console.log err
    res.render 'admin/reports/servicesEnquiries', enquiries: enquiries or {}, suppliers: {}

exports.advertisingClicks = (req, res) ->
  
  Advertiser.all (err, advertisers) ->
    cred = 
      month: req.query.month or 'all'
      advertiser: req.query.advertiser or '0'
    
    if cred.month is 'all' then cred.month = '%'
    unless cred.month is '' then cred.month = months[cred.month] or ''
    
    Click.report cred, (error, clicks) ->
      
      return res.send 500, error if error?
      
      res.render 'admin/reports/advertisingClicks', {advertisers, clicks}

exports.referrals = (req, res) ->
  
  Referral.all (error, referrals) ->
    
    res.render 'admin/reports/referrals', {referrals}