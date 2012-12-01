system = require '../../system'

models = services: system.load.model 'services'

exports.index = (req, res) ->
  models.services.getAllServices (err, results) ->
    res.render 'admin/services/index', services: results or {}, menu: 'products-service-suppliers'
  
exports.view = (req, res) ->

exports.add = (req,res) ->
  models.services.getAllServiceCategories (err, categories) ->
    res.render 'admin/services/add', categories: categories or {}, menu: 'products-service-suppliers'
  
exports.create = (req, res) ->
  req.body.logo ?= ''
  req.body.visible ?= 1
  
  models.services.createService req.body, (err, results) ->
    if err then throw err
    
    res.redirect '/admin/services'

exports.edit = (req, res) ->
  models.services.getServiceById req.params.id, (err, results) ->
    models.services.getAllServiceCategories (err, categories) ->
      if results.length >= 1 then results = results.pop()
      res.render 'admin/services/edit', service: results or {}, categories: categories or {}, menu: 'products-service-suppliers'
  
exports.update = (req, res) ->
  req.body.logo ?= ''
  req.body.visible ?= 1
  
  models.services.updateService req.params.id, req.body, (err, results) ->
    if err then throw err
    
    res.redirect '/admin/services/edit/' + req.params.id

exports.delete = (req, res) ->
  models.services.deleteService req.params.id, (err, results) ->
    if err then throw err
    
    res.redirect 'back'

exports.viewCategories = (req, res) ->
  models.services.getAllServiceCategories (err, categories) ->
    if err then throw err
    res.render 'admin/services/viewCategories', categories: categories or {}, menu: 'products-service-suppliers'

exports.createCategory = (req, res) ->
  models.services.createCategory req.body, (err) ->
    if err then throw err
    
    res.redirect '/admin/services/categories'

exports.addCategory = (req, res) ->
  res.render 'admin/services/addCategory', menu: 'products-service-suppliers'

exports.editCategory = (req, res) ->
  models.services.getCategoryById req.params.id, (err, results) ->
    if results.length >= 1 then results = results.pop()
    res.render 'admin/services/editCategory', category: results or {}, menu: 'products-service-suppliers'
  
exports.updateCategory = (req, res) ->
  models.services.updateCategory req.params.id, req.body, (err, results) ->
    if err then throw err
    
    res.redirect 'back'

exports.deleteCategory = (req, res) ->
  models.services.deleteCategory req.params.id, (err, results) ->
    if err then throw err
    
    res.redirect 'back'
