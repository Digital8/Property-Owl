system = require '../system'

models = user: system.load.model 'user'

helpers = hash: system.load.helper 'hash'

exports.index = (req,res) ->
  
  if req.body.email? and req.body.password?
    
    email = req.body.email
    password = helpers.hash req.body.password
    
    models.user.login email, password, (err, results) ->
      
      if err then throw err
      
      if results.length is 0
        req.flash 'error', 'Invalid login details'
        
        res.render 'user/login'
      else
        results = results.pop()
        
        req.session.user_id = results.user_id
        
        # if req.body.redirect?
        #   console.log 'req.body.redirect', req.body.redirect
        #   res.redirect req.body.redirect
        # else
        console.log 'req.session.redirect_to', req.session.redirect_to
        res.redirect req.session.redirect_to or '/'
  
  else
    res.render 'user/login', modal: on

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->