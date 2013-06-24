async = require 'async'

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