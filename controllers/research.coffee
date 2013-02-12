system = require '../system'

models = news: system.models.news
News = system.models.news

exports.index = (req,res) ->
  models.news.findByType 'research', (err, results) ->
    if err then throw err
    res.render 'research/index', news: results or {}

exports.view = (req,res) ->
  News.get req.params.id, (err, results) ->
    if err then throw err
    res.render 'research/view', post: results or {}

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->