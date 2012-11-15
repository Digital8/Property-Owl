###
 * Saved Deals Controller
 *
 * Controller for homepage of website
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'
async = require 'async'

helpers = {}
  
models =
  properties: system.load.model 'properties'
  saveddeals: system.load.model 'saveddeals'

exports.index = (req,res) ->
  models.saveddeals.getSavedDealsByUserId res.locals.objUser.id, (err, results) ->
    if err then throw err
    res.render 'deals/saveddeals', properties: results or {}

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->
  
exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
