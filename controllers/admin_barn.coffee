###
 * Admin Barn Controller
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  properties: system.load.model('properties')
  users: system.load.model('user')

helpers = {}
 
exports.index = (req, res) ->
  models.properties.getPropertiesByDealType 'barn', true, (err, results) ->
    barn_results = []
    for i in [0...results.length]
      if results[i].deal_of is 0 then barn_results.push(results[i])
    
    models.users.getUsersByGroup 2, (err, developers) ->      
      res.render 'administration/barn/index', barn_deals: barn_results or {}, developers: developers or {}
  
exports.view = (req, res) ->
  
exports.add = (req,res) ->
  if req.query.pid?
    
    models.properties.addBarnDeal req.params.id, req.query.pid, (err, results) ->
      req.flash('success','Property added')
      res.redirect 'back'
  else
    models.properties.getAllPropertiesById req.params.id, (err, results) ->
      if results.length is 0
        req.flash('error','Barn deal not found')
        res.redirect 'back'
      else
        barn = results.pop()
        if (barn.deal_type != 'barn' or barn.deal_type != 'all') and barn.deal_of != 0
          req.flash('error','Barn deal not found')
          res.redirect 'back'
        else
          models.properties.getAllProperties (err, properties) ->
            res.render 'administration/barn/add', barn: barn or {}, properties: properties
  
exports.create = (req, res) ->
  
          
exports.edit = (req, res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    if results.length is 0
      req.flash('error','Barn deal not found')
      res.redirect 'back'
    else
      barn = results.pop()
      if (barn.deal_type != 'barn' or barn.deal_type != 'all') and barn.deal_of != 0
        req.flash('error','Barn deal not found')
        res.redirect 'back'
      else
        models.properties.getPropertiesOfBarnDeal req.params.id, (err, properties) ->
          res.render 'administration/barn/edit', barn: barn or {}, properties: properties or {}

      
  
exports.update = (req, res) ->

exports.delete = (req, res) ->
  barn_id = req.params.barn_id
  property_id = req.params.property_id
  models.properties.getAllPropertiesById barn_id, (err, results) ->
     if results.length is 0
       req.flash('error','Barn deal not found')
       res.redirect 'back'
     else
       barn = results.pop()
       if (barn.deal_type != 'barn' or barn.deal_type != 'all') and barn.deal_of != 0
         req.flash('error','Barn deal not found')
         res.redirect 'back'
       else
         models.properties.getAllPropertiesById property_id, (err, properties) ->
           if properties.length >= 1 then property = properties.pop()
           res.render 'administration/barn/delete', barn: barn or {}, property: property or {}
  
  
exports.destroy = (req,  res) ->
  barn_id = req.params.barn_id
  property_id = req.params.property_id
  models.properties.removeBarnDeal property_id, (err, results) ->
    if err then throw err
    req.flash('success', 'Property removed from barn deal')
    res.redirect '/administration/barn/edit/' + barn_id