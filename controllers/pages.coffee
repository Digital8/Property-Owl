###
 * Custom Pages Controller
 *
 * Controller for custom pages
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

helpers = 
  hash: system.load.helper 'hash'

models =
  page: system.load.model 'page'
  user: system.load.model 'user'

# GET
exports.index = (req,res) ->
  url = req.params.pop()
  
  models.page.findByUrl url, (err, results) ->
    if err then throw err
    
    if results.length is 0 
      res.render 'errors/404'
    else
      page = results.pop();
      if page.enabled is 0 then res.render 'errors/404' else res.render 'page', page: page
  

# GET    
exports.view = (req,res) ->

# GET
exports.add = (req,res) ->

# PUT
exports.create = (req,res) ->

# GET
exports.edit = (req,res) ->

# POST
exports.update = (req,res) ->

# GET
exports.delete = (req, res) ->
  

# DEL
exports.destroy = (req,res) ->

