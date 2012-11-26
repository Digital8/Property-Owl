async = require 'async'

system = require '../system'

models =
  adspace: system.load.model 'adspace'
  advertisement: system.load.model 'advertisement'
  page: system.load.model 'page'

helpers = {}

exports.index = (req, res) ->
  models.advertisement.all (error, results) ->
    throw error if error
    
    res.render 'administration/advertisements/index', advertisements: results

exports.add = (req, res) ->
  
  async.parallel
    adspace: (callback) -> models.adspace.all callback
    page: (callback) -> models.page.all callback
  , (error, results) ->
    
    console.dir arguments
    
    # throw error if error
    
    # res.render 'administration/advertisements/add', adspaces: results