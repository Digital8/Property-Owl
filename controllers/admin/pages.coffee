system = require '../../system'

models = page: system.load.model 'page'

exports.index = (req,res) ->
  models.page.all (error, results) ->
    if error then throw error
    
    res.render 'admin/pages/index', pages: results or {}

exports.view = (req,res) ->

exports.add = (req,res) ->
  res.render 'admin/pages/add'
  
exports.create = (req, res) ->
  req.body.url ?= ''
  req.body.header ?= ''
  req.body.content ?= ''
  req.body.enabled ?= 1
  req.body.static ?= 1
  
  req.assert('url', 'Please enter a URL for page').len(1, 100).notEmpty()
  req.assert('header', 'Page title is empty').len(1, 100).notEmpty()
  
  if req.body.enabled != '1' then req.body.enabled = '0'

  errors = req.validationErrors true
  
  if errors
    keys = Object.keys errors
    req.flash('error', errors[key].msg) for key in keys
    res.redirect 'back'
  
  else
    models.page.findByUrl req.body.url, (err, results) ->
      if err then throw err
      
      if results.length >= 1
        req.flash 'error', 'Sorry, page URL is already in use'
      else
        models.page.create req.body, (err, results) ->
          if err then throw err
          req.flash 'success', 'Page created'
          res.redirect '/admin/pages'

exports.edit = (req,res) ->
  models.page.find req.params.id, (err, results) ->
    if err then throw err
    
    if results.length is 0
      req.flash 'error', 'Page not found'
      res.redirect 'back'
    
    else
      res.render 'admin/pages/edit', page: results.pop()
  
exports.update = (req,res) ->
  models.page.find req.params.id, (err, results) ->
    if err then throw err
    
    if results.length is 0
      req.flash 'error', 'Page not found'
      res.redirect 'back'
    
    else
      req.body.id = req.params.id
      
      models.page.update req.body, (err, results) ->
        if err then throw err
        
        req.flash 'success', 'Page updated successfully!'
        
        res.redirect '/admin/pages'

exports.delete = (req, res) ->
  models.page.find req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that page doesn't exist."
      res.redirect '/admin/pages'
    
    else
      res.render 'admin/pages/delete', page: results.pop() or {}

exports.destroy = (req, res) ->
  models.page.delete req.params.id, (err, results) ->
    req.flash 'success', 'page deleted'
    
    res.redirect '/admin/pages'