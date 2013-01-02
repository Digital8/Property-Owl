fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Affiliate = system.models.affiliate
AffiliateCategories = system.models.affiliate_category

exports.index = (req, res) ->
  Affiliate.all (error, affiliates) ->
    res.render 'admin/affiliates/index', affiliates: affiliates

exports.view = (req, res) ->
  Affiliate.get req.params.id, (error, affiliate) ->
    res.render 'admin/affiliates/view', affiliate: affiliate

exports.edit = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.get req.params.id, callback
    affiliateCategories: (callback) -> AffiliateCategories.all callback
  , (error, {affiliate, affiliateCategories}) ->
    res.render 'admin/affiliates/edit', affiliate: affiliate, affiliateCategories: affiliateCategories

exports.add = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.new callback
    affiliateCategories: (callback) -> AffiliateCategories.all callback
  , (error, {affiliate, affiliateCategories}) ->
    res.render 'admin/affiliates/add', affiliate: affiliate, affiliateCategories: affiliateCategories

exports.create = (req, res) ->
  Affiliate.create req.body, (error, affiliate) ->

    affiliate.upload req, ->
      console.log 'create', arguments
      
      template = 'listing-confirmation'
      
      user =
        contactName: res.locals.objUser.firstName
        email: res.locals.objUser.email
      
      secondary = 
        dealLink: '/admin/affiliates/#{affiliate.insertId}/edit'
      
      system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
        if results is true
          affiliate.upload req, ->
            res.redirect '/admin/affiliates'
        else
          res.redirect '/admin/affiliates'

exports.update = (req, res) ->
  req.body.visible ?= no
  
  console.log req.body
  
  Affiliate.update req.params.id, req.body, (error, affiliate) ->
    console.log 'update', arguments
    
    affiliate.upload req, ->
      res.redirect '/admin/affiliates'

exports.delete = (req, res) ->
  Affiliate.get req.params.id, (error, affiliate) ->
    res.render 'admin/affiliates/delete', affiliate: affiliate

exports.destroy = (req, res) ->
  Affiliate.delete req.params.id, (error) ->
    req.flash 'success', 'affiliate deleted'
    
    res.redirect '/admin/affiliates'

