###
 * Administration News
 *
 * Controller Template
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
    res.render 'administration/news/index', news: results
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  res.render 'administration/news/add'

exports.create = (req,res) ->
  req.body.id = res.locals.objUser.id
  
  models.news.insert req.body, (err, results) ->
    if err
      req.flash 'error','Some unknown error occured'
      res.redirect 'back'
    else
      req.flash 'success','News post submitted'
      res.redirect '/administration/news'

exports.edit = (req,res) ->
  models.news.getNewsById req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      res.redirect '/administration/news'
    else
      res.render 'administration/news/edit', news: results.pop() or {}
  
exports.update = (req, res) ->
  req.body.title ?= ''
  req.body.content ?= ''
  req.body.id = req.params.id
  
  models.news.update req.body, (err, results) ->
    if err
      req.flash 'error', 'an error occured updating the post'
      res.redirect 'back'
    else
      req.flash 'success', 'news entry updated'
      res.redirect '/administration/news'
  
exports.delete = (req, res) ->
  models.news.getNewsById req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      res.redirect '/administration/news'
    else
      res.render 'administration/news/delete', news: results.pop() or {}
  
exports.destroy = (req,res) ->
  models.news.delete req.params.id, (err, results) ->
    req.flash 'success', 'news post deleted'
    res.redirect '/administration/news'