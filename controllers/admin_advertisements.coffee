fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

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
  fs.readFile req.files.image.path, (error, data) ->
    id = uuid()
    
    path = "#{system.bucket}/#{id}"
    
    fs.writeFile path, data, (error) ->
      
      req.assert('description', 'Please enter a description').notEmpty()
      
      errors = req.validationErrors true
      if errors
        keys = Object.keys errors
        
        req.flash('error', errors[key].msg) for key in keys 
        
        res.redirect 'back'
      
      res.redirect '/administration/advertisements'