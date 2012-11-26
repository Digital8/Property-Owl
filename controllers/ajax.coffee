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
  deals: system.load.model 'deals'
  media: system.load.model 'media'
  
helpers =
  hash: system.load.helper 'hash'

exports.login = (req, res) ->
  models.user.login req.body.e, helpers.hash(req.body.p), (err, results) ->
    if results.length >= 1
      results = results.pop()
      req.session.user_id = results.user_id
      res.send status: 200
    else
      res.send status: 401
      
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
        
exports.removedeal = (req, res) ->
  req.assert('id', 'Property ID Not Numeric').isInt()
  errors = req.validationErrors(true)

  if errors
    res.send status: false
  else
    models.saveddeals.removeSavedDeal req.body.id, res.locals.objUser.id, (err, results) ->
      if err?
        res.send status: false
      else
        res.send status:true

exports.addDeal = (req, res) ->
  req.body.property_id ?= req.body.pid
  req.body.created_by = res.locals.objUser.id
  
  models.deals.addDeal req.body, (err, results) ->
    if err then throw err
    res.send results

exports.delDeal = (req, res) ->
  models.deals.getDealById req.body.id, (err, results) ->
    if err then throw err
    if results.length is 1 then results = results.pop()
    models.deals.deleteDealById req.body.id, (err) ->
      res.send results
  
exports.updateHero = (req, res) ->
  models.media.clearHero req.body.pid, (err) ->
    models.media.setHero req.body.mid, (err, results) ->
      res.send results

exports.deleteMedia = (req, res) ->
  req.body.mid ?= 0
  models.media.deleteMedia req.body.mid, (err, results) ->
    if err then console.log err
    res.send results
      
  