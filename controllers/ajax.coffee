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
      
exports.favorite = (req, res) ->
   models.user.login req.body.e, helpers.hash(req.body.p), (err, results) ->
     if results.length is 0
       res.send status: false
     else
       results = results.pop()
       req.session.user_id = results.user_id
       res.send status: true