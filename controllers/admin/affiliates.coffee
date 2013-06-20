async = require 'async'

exports.index = (req, res) ->
  async.parallel
    affiliates: (callback) -> Affiliate.all callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliates, categories}) ->
    console.log arguments...
    res.render 'admin/affiliates/index', affiliates: affiliates, categories: categories

exports.view = (req, res) ->
  Affiliate.get req.params.id, (error, affiliate) ->
    res.render 'admin/affiliates/view', affiliate: affiliate

exports.edit = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.get req.params.id, callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliate, categories}) ->
    if error then throw error
  
    res.render 'admin/affiliates/edit', affiliate: affiliate, categories: categories

exports.add = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.new callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliate, categories}) ->
    res.render 'admin/affiliates/add', affiliate: affiliate, categories: categories

exports.create = (req, res) ->
  Affiliate.create req.body, (error, affiliate) ->

    affiliate.upload req, ->
      res.redirect '/admin/affiliates'

exports.update = (req, res) ->
  req.body.visible ?= no
  
  console.log 'do we have an update'
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