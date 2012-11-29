###
 * News Controller
 *
 * Handles website news
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  news: system.load.model 'news'

helpers = {}

# Gets all news by type news
exports.index = (req,res) ->
  models.news.getAllNewsByType 'news', (err, results) ->
    if err then throw err
    res.render 'news/index', news: results or {}, menu: 'wise-owl'
    
exports.view = (req,res) ->
  models.news.getNewsById req.params.id, (err, results) ->
    if err then throw err
    res.render 'news/view', post: results.pop() or {}, menu: 'wise-owl'
    
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->