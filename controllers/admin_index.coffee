###
 * Skeleton Controller
 *
 * Controller Template
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

async = require 'async'

system = require '../system'

models =
  admin: system.load.model 'admin'
  advertisement: system.load.model 'advertisement'

helpers = {}
 
exports.index = (req,res) ->
  async.parallel
    pages: (callback) -> models.admin.getAdminPages callback
    activeAdvertisementCount: (callback) -> models.advertisement.countActive callback
  , (error, results) ->
    res.render 'administration/index', results
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->