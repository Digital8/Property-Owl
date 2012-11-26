fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../system'

models =
  adspace: system.load.model 'adspace'
  advertisement: system.load.model 'advertisement'
  advertiser: system.load.model 'advertiser'
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
    advertiser: (callback) -> models.advertiser.all (error, results) -> callback error, results
  , (error, results) ->
    throw error if error
    
    console.dir results
    
    res.render 'administration/advertisements/add',
      adspaces: results.adspace
      pages: results.page
      advertisers: results.advertiser

exports.create = (req, res) ->
  fs.readFile req.files.image.path, (error, data) ->
    req.body.image_id = uuid()
    
    path = "#{system.bucket}/#{req.body.image_id}"
    
    fs.writeFile path, data, (error) ->
      req.assert('description', 'Please enter a description').notEmpty()
      
      req.sanitize('visible').toBoolean()
      
      errors = req.validationErrors true
      if errors
        keys = Object.keys errors
        
        req.flash('error', errors[key].msg) for key in keys 
        
        res.redirect 'back'
      else
        req.body.page_id = req.body.page
        req.body.advertiser_id = req.body.advertiser
        req.body.adspace_id = req.body.adspace
        
        models.advertisement.create req.body, (err, results) ->
          throw err if err
          res.redirect '/administration/advertisements'

exports.edit = (req, res) ->
  async.parallel
    adspace: (callback) -> models.adspace.all (error, results) -> callback error, results
    page: (callback) -> models.page.all (error, results) -> callback error, results
    advertiser: (callback) -> models.advertiser.all (error, results) -> callback error, results
    advertisement: (callback) -> models.advertisement.find req.params.id, (error, results) -> callback error, results.pop()
  , (error, results) ->
    throw error if error
    
    res.render 'administration/advertisements/edit',
      adspaces: results.adspace
      pages: results.page
      advertisers: results.advertiser
      advertisement: results.advertisement

exports.update = (req, res) ->
  req.body.id = req.params.id
  req.body.page_id = req.body.page
  req.body.advertiser_id = req.body.advertiser
  req.body.adspace_id = req.body.adspace
  
  models.advertisement.update req.body, (err, results) ->
    if err
      req.flash 'error', 'an error occured updating the advertisement'
      res.redirect 'back'
    else
      req.flash 'success', 'advertisement updated'
      res.redirect '/administration/advertisements'

exports.delete = (req, res) ->
  models.advertisement.find req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that advertisement doesn't exist."
      res.redirect '/administration/advertisements'
    else
      res.render 'administration/advertisements/delete', advertisement: results.pop() or {}

exports.destroy = (req, res) ->
  models.advertisement.delete req.params.id, (err, results) ->
    req.flash 'success','advertisement deleted'
    
    res.redirect '/administration/advertisements'