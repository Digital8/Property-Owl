system = require '../system'

News = system.models.news

exports.index = (req,res) ->
  News.all (error, news) ->
    throw error if error
    
    res.render 'news/index', news: news

exports.view = (req,res) ->
  News.get req.params.id, (error, news) ->
    throw error if error
    
    res.render 'news/view', post: news

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->