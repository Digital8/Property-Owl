_ = require 'underscore'

system = require '../system'
async = require 'async'
Affiliate = system.models.affiliate
Category = system.models.category

exports.index = (req, res) ->
  async.parallel
    affiliates: (callback) -> Affiliate.all callback
    categories: (callback) -> Category.for 'affiliate', callback
  , (error, {affiliates, categories}) ->
    res.render 'affiliates/index', affiliates: affiliates, categories: categories

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->