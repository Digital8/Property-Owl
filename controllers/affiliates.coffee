_ = require 'underscore'

system = require '../system'
async = require 'async'
Affiliate = system.models.affiliate
Category = system.models.category

exports.index = (req, res) ->
  if req.query.category? and req.query.category.toLowerCase() != 'all'
    async.parallel
      affiliates: (callback) -> Affiliate.byCategory req.query.category, callback
      categories: (callback) -> Category.for 'affiliate', callback
    , (error, {affiliates, categories}) ->
      res.render 'affiliates/index', affiliates: affiliates, categories: categories, id: req.query.category or 0
  else
    async.parallel
      affiliates: (callback) -> Affiliate.all callback
      categories: (callback) -> Category.for 'affiliate', callback
    , (error, {affiliates, categories}) ->
      console.log(categories)
      res.render 'affiliates/index', affiliates: affiliates, categories: categories, id: req.query.category or 0

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->