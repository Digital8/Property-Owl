utils  = require 'util'
system = require '../system'

models = 
  advertisement: system.load.model('advertisement')
  adclick: system.load.model('adclick')

helpers = {}

exports.index = (req,res) ->
  models.advertisement.find req.params.id, (err, results) ->
    if err then console.log err
    if results.length is 0
      res.redirect '/'
    else
      ad = results.pop()

      data =
        id: req.params.id
        ip: req.ip
        referer: req.header('Referer') or ''
        browser: req.header('user-agent') or ''
        user_id: res.locals.objUser.id or 0
        req: utils.inspect(req)

      models.adclick.add data, (err, results) ->
        res.redirect ad.hyperlink

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->