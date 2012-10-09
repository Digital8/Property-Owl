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
 
exports.index = (req,res) ->
  models.news.getAllNews (err, results) ->
    if err then throw err
    
    console.log results
    res.render 'news/index', news: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->