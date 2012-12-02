async = require 'async'

system = require '../../system'

models = {}

helpers = {}

exports.index = (req,res) ->
  res.render 'admin/reports/index', menu: 'reports'

exports.dealListings = (req,res) ->
  res.render 'admin/reports/dealListings', menu: 'reports'

exports.websiteRegistrations = (req,res) ->
  res.render 'admin/reports/websiteRegistrations', menu: 'reports'

exports.propertySearches = (req,res) ->
  res.render 'admin/reports/propertySearches', menu: 'reports'

exports.dealRegistrations = (req,res) ->
  res.render 'admin/reports/dealRegistrations', menu: 'reports'

exports.servicesEnquiries = (req,res) ->
  res.render 'admin/reports/servicesEnquiries', menu: 'reports'

exports.advertisingClicks = (req,res) ->
  adverts = [
    'advertisement_id':'1'
    'created_at':'01/10/2012'
    'advertiser':'Advertiser 1'
    'ad':'ad 282'
    'clickthroughs':'34'
  ]
    
  res.render 'admin/reports/advertisingClicks', adverts: adverts or {}, menu: 'reports'