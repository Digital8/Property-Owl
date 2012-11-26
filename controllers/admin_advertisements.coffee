system = require '../system'

models =
  adspace: system.load.model 'adspace'
  advertisement: system.load.model 'advertisement'

helpers = {}

exports.index = (req, res) ->
  models.advertisement.all (error, results) ->
    throw error if error
    
    res.render 'administration/advertisements/index', advertisements: results

exports.add = (req, res) ->
  models.adspace.all (error, results) ->
    throw error if error
    
    res.render 'administration/advertisements/add', adspaces: results