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
    adspace: (callback) -> models.adspace.all (error, results) -> callback error, results
    page: (callback) -> models.page.all (error, results) -> callback error, results
  , (error, results) ->
    throw error if error
    
    res.render 'administration/advertisements/add',
      adspaces: results.adspace
      pages: results.page

exports.create = (req, res) ->
  console.dir files: req.files