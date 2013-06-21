async = require 'async'

exports.login = (req, res) ->
  
  email = req.body.e
  password = req.body.p
  
  digest = (require '../lib/hash') password
  
  User.byEmail email, (error, user) ->
    
    return res.send 500, error if error?
    
    unless user?
      res.send status: 401
      return
    
    # TODO timing attacks [@pyro]
    unless user.password is digest
      res.send status: 401
      return
    
    req.session.user_id = user.id
    
    if req.body.r?.toLowerCase() is 'checked'
      res.cookie 'pouser', user.id, maxAge: 604800000
      res.cookie 'popwd', user.password, maxAge: 604800000
    
    res.send status: 200

exports.registerStatus = (req, res) ->
  req.body.id ?= 0
  req.body.val ?= 0

  if req.user?.isDeveloper()
    Registration.changeStatus req.body, (err,results) ->
      if err
        res.send status: 500
      else
        res.send status: 200
  else
    res.send status: 403

exports.search = (req, res) ->
  
  {address, suburb} = req.query
  
  exports.db.query """
  SELECT * FROM owls
  WHERE
    address SOUNDS LIKE ?
      AND
    suburb SOUNDS LIKE ?
  """, [address, suburb], (error, rows) ->
    
    models = ((new Owl row) for row in rows)
    
    async.forEach models, (model, callback) =>
      model.hydrate callback
    , (error) ->
      res.send [null, models]