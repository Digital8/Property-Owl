async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  async.parallel
    affiliates: (callback) -> Affiliate.all callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliates, categories}) ->
    res.render 'admin/affiliates/index', {affiliates, categories}

exports.view = (req, res) ->
  Affiliate.get req.params.id, (error, affiliate) ->
    res.render 'admin/affiliates/view', {affiliate}

exports.edit = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.get req.params.id, callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliate, categories}) ->
    if error then throw error
  
    res.render 'admin/affiliates/edit', {affiliate, categories}

exports.add = (req, res) ->
  async.parallel
    affiliate: (callback) -> Affiliate.new {}, callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliate, categories}) ->
    res.render 'admin/affiliates/add', {affiliate, categories}

exports.create = (req, res) ->
  Affiliate.create req.body, (error, affiliate) ->

    affiliate.upload req, ->
      res.redirect '/affiliates'

exports.update = (req, res) ->
  
  req.body.visible ?= no
  
  Affiliate.update req.params.id, req.body, (error, affiliate) ->
    console.log 'update', arguments
    
    affiliate.upload req, ->
      res.redirect '/affiliates'

exports.delete = (req, res) ->
  Affiliate.get req.params.id, (error, affiliate) ->
    res.render 'admin/affiliates/delete', affiliate: affiliate

exports.destroy = (req, res) ->
  Affiliate.delete req.params.id, (error) ->
    req.flash 'success', 'affiliate deleted'
    
    res.redirect '/affiliates'

exports.browse = (req, res) ->
    
    async.parallel
      
      affiliates: (callback) ->
        if req.query.category
          Affiliate.byCategory req.query.category, callback
        unless req.query.category
          Affiliate.all callback
      
      categories: (callback) -> Category.for 'affiliate', callback
      
      page: (callback) -> Page.findByUrl '/affiliates', callback
    
    , (error, {affiliates, categories, page}) ->
      
      try
        
        res.render 'affiliates/index',
          affiliates: affiliates
          categories: categories
          id: req.query.category or 0
          cms: do jade.compile page.content
      
      catch e
        
        res.render 'errors/404'