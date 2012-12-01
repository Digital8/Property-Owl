system = require '../system'

models =
  page: system.load.model 'page'
  user: system.load.model 'user'

exports.index = (req,res) ->
  url = req.params.pop()
  
  models.page.findByUrl url, (err, results) ->
    if err then throw err
    
    if results.length is 0 
      res.render 'errors/404'
    else
      page = results.pop();
      if page.enabled is 0 then res.render 'errors/404' else res.render 'page', page: page

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.delete = (req, res) ->

exports.destroy = (req,res) ->

