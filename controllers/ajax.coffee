###
 * Ajax Controller
 *
 * Controller for ajax activity
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

models = 
  user: system.load.model 'user'
  saveddeals: system.load.model 'saveddeals'
  
helpers =
  hash: system.load.helper 'hash'

exports.login = (req, res) ->
  models.user.login req.body.e, helpers.hash(req.body.p), (err, results) ->
    if results.length is 0
      res.send status: false
    else
      results = results.pop()
      req.session.user_id = results.user_id
      res.send status: true
      
exports.savedeal = (req, res) ->
  req.assert('id', 'Property ID Not Numeric').isInt()
  errors = req.validationErrors(true)

  if errors
    res.send status: false
  else
    models.saveddeals.checkDeal req.body.id, res.locals.objUser.id, (err, results) ->
      if results.length is 0
        models.saveddeals.saveDeal req.body.id, res.locals.objUser.id, (err, results) ->
          if err?
            res.send status: false
          else
            res.send status: true
      else
        res.send status: true