_s = require 'underscore.string'

exports.index = (req,res) ->
  
  callback = (err, results) ->
    if err then throw err
    res.render 'admin/users/index', users: results, search: req.query.name or ''
  
  if req.query.name?
    User.search '%'+req.query.name+'%', callback
  else
    User.all callback

exports.add = (req, res, next) ->
  
  User.groups (error, groups) ->
    
    return next error if error?
    
    user = req.session.users or {}
    delete req.session.users
    
    menu = 'users'
    
    res.render 'admin/users/add', {user, groups, menu}

exports.create = (req,res) ->
  
  email = req.email
  
  User.byEmail email, (error, user) ->
    
    return next error if error?
    
    if email?.length and user?
      req._validationErrors ?= []
      req._validationErrors.push
        param: 'email'
        msg: 'already in use'
        value: user.email
    else
      req.assert('email', 'invalid').isEmail()
    
    req.assert('password', 'too short (6 characters minimum)').len 6
    if req.body.password?.length
      req.assert('confirm', '').equals req.body.password
    
    req.assert('first_name', 'invalid').len 2 # regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    req.assert('last_name', 'invalid').len 2 # regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    
    req.assert('postcode', 'invalid').regex /[0-9]{4}/i
    
    errors = req.validationErrors()
    
    if errors
      for error in errors
        req.flash 'error', (_s.humanize "#{error.param} - #{error.msg}")
      req.session.users = req.body
      res.render 'back'
      return
    
    req.body.password ?= ''
    req.body.password = (require '../lib/hash') req.body.password
    
    User.create req.body, (error, user) ->
      
      if error?
        req.session.users = req.body
        res.render 'back'
      
      req.flash 'success', 'User created!'
      
      res.redirect '/users'

exports.edit = (req, res, next) ->
  
  User.get req.params.id, (error, user) ->
    
    return next error if error?
    
    unless user?
      req.flash 'error', 'User not found'
      res.status = 404
      res.redirect 'back'
      return
    
    user.set req.session.users
    delete req.session.users
    
    User.groups (error, groups) ->
      
      return next error if error?
      
      res.render 'admin/users/edit', {user, groups}

exports.update = (req, res, next) ->
  
  email = req.email
  
  User.byEmail email, (error, user) ->
    
    return next error if error?
    
    if email?.length and user? and (user.id isnt req.params.id)
      req._validationErrors ?= []
      req._validationErrors.push
        param: 'email'
        msg: 'already in use'
        value: user.email
    else
      req.assert('email', 'invalid').isEmail()
    
    if req.body.password?.length
      req.assert('password', 'too short (6 characters minimum)').len(6, 32).notEmpty()
      req.assert('confirm', '').equals req.body.password
    
    req.assert('first_name', 'invalid').isAlpha().notEmpty()
    req.assert('last_name', 'invalid').isAlpha().notEmpty()
    
    req.assert('postcode', 'invalid').regex /[0-9]{4}/i
    
    errors = req.validationErrors()
    
    if errors
      for error in errors
        req.flash 'error', (_s.humanize "#{error.param} - #{error.msg}")
      req.session.users = req.body
      res.render 'back'
      return
    
    if req.body.password?
      req.body.password = (require '../lib/hash') req.body.password
    
    User.patch req.params.id, req.body, (error, user) ->
      
      return next error if error?
      return next 404 unless user?
      
      req.flash 'success', 'User updated!'
      res.redirect "/users/#{user.id}/edit"

exports.delete = (req, res) ->
  
  res.send 500

exports.destroy = (req, res) ->
  
  User.delete req.params.id, (err, results) ->
    if err 
      res.send status: 500
    else
      res.send status: 200