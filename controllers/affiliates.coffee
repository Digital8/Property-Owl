_ = require 'underscore'
jade = require 'jade'
system = require '../system'
async = require 'async'
Affiliate = system.models.affiliate
Category = system.models.category
Page = system.models.page

exports.index = (req, res) ->
  if req.query.category? and req.query.category.toLowerCase() != 'all'
    async.parallel
      affiliates: (callback) -> Affiliate.byCategory req.query.category, callback
      categories: (callback) -> Category.for 'affiliate', callback
      page: (callback) -> Page.findByUrl '/affiliates', callback
    , (error, {affiliates, categories, page}) ->
      try
        page = page.shift().shift()
        fn = jade.compile page.content
        cms = do fn
        res.render 'affiliates/index', affiliates: affiliates, categories: categories, id: req.query.category or 0, cms: cms
      catch e
        res.render 'errors/404'
      
  else
    async.parallel
      affiliates: (callback) -> Affiliate.all callback
      categories: (callback) -> Category.for 'affiliate', callback
      page: (callback) -> Page.findByUrl '/affiliates', callback
    , (error, {affiliates, categories, page}) ->
      try
        page = page.shift().shift()
        fn = jade.compile page.content
        cms = do fn
        res.render 'affiliates/index', affiliates: affiliates, categories: categories, id: req.query.category or 0, cms: cms
      catch e
        res.render '404'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->