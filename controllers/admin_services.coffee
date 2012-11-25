###
 * Admin Pages Controller
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  services: system.load.model('services')

helpers = {}
 
exports.index = (req, res) ->
  models.services.getAllServices (err, results) ->
    res.render 'administration/services/index', services: results or {}
  
exports.view = (req, res) ->
  
exports.add = (req,res) ->
  models.services.getAllServiceCategories (err, categories) ->
    res.render 'administration/services/add', categories: categories or {}
  
exports.create = (req, res) ->
  req.body.logo ?= ''
  req.body.visible ?= 1
  models.services.createService req.body, (err, results) ->
    if err then throw err
    res.redirect '/administration/services'
          
exports.edit = (req, res) ->
  
exports.update = (req, res) ->
  
exports.destroy = (req, res) ->
  
# Cateogries section

exports.viewCategories = (req, res) ->
  models.services.getAllServiceCategories (err, categories) ->
    if err then throw err
    res.render 'administration/services/viewCategories', categories: categories or {}

exports.createCategory = (req, res) ->
  models.services.createCategory req.body, (err) ->
    if err then throw err
    res.redirect '/administration/services/categories'

exports.addCategory = (req, res) ->
  res.render 'administration/services/addCategory'