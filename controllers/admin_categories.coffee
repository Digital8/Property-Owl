system = require '../system'

models = category: system.load.model 'category'

helpers = {}

exports.index = (req, res) ->
  models.category.all (err, categories) ->
    if err then throw err
    
    res.render 'administration/categories/index', categories: categories or {}

exports.create = (req, res) ->
  models.category.create req.body, (err) ->
    if err then throw err
    
    res.redirect '/administration/category/categories'

exports.add = (req, res) ->
  res.render 'administration/category/addCategory'

exports.edit = (req, res) ->
  models.category.getCategoryById req.params.id, (err, results) ->
    if results.length >= 1 then results = results.pop()
    
    res.render 'administration/category/editCategory', category: results or {}

exports.update = (req, res) ->
  models.category.updateCategory req.params.id, req.body, (err, results) ->
    if err then throw err
    
    res.redirect 'back'

exports.delete = (req, res) ->
  models.category.delete req.params.id, (err, results) ->
    if err then throw err
    
    res.redirect 'back'