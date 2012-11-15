###
 * Sign Up Controller
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
  console.log 'user_id:', res.locals.objUser.id
  
  models.saveddeals.getSavedDealsByUserId res.locals.objUser.id, (err, results) ->
    if results.length is not 0
      console.log 'number of saved properties:', results.length
      
      properties = []
      
      iterator = (item, callback) ->
        models.properties.getAllPropertiesById item.deal_id, (err, results) ->
          if results.length is not 0
            properties.push results[0]
            
          callback()
      
      async.forEach results, iterator, (err) ->
        res.render 'deals/saveddeals', properties: properties or []
    
    else
      res.render 'deals/saveddeals', properties: []

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->
  
exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
