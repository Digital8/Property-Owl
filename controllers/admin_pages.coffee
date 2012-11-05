###
 * Admin Pages Controller
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  pages: system.load.model('pages')

helpers = {}
 
exports.index = (req,res) ->
  models.pages.getAllPages (err, results) ->
    if err then throw err
    res.render 'administration/pages/index', pages: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  res.render 'administration/pages/add'
  
exports.create = (req,res) ->
  req.body.url ?= ''
  req.body.header ?= ''
  req.body.content ?= ''
  req.body.enabled ?= 1
  

  req.assert('url', 'Please enter a URL for page').len(1,100).notEmpty()
  req.assert('header', 'Page title is empty').len(1,100).notEmpty()
  
  if req.body.enabled != '1' then req.body.enabled = '0'

  errors = req.validationErrors(true)
  if errors
    keys = Object.keys(errors)
  
    req.flash('error', errors[key].msg) for key in keys 

    res.redirect 'back'
  else
    models.pages.getPageByUrl req.body.url, (err, results) ->
      if err then throw err
      if results.length >= 1
        req.flash('error','Sorry, page URL is already in use')
      else
        req.body.content = req.body.content.replace(/\r\n/g, "<p>&nbsp;</p>")
        models.pages.createPage req.body, (err, results) ->
          if err then throw err
          req.flash('success','Page created')
          res.redirect 'back'
          

exports.edit = (req,res) ->
  models.pages.getPageById req.params.id, (err, results) ->
    if err then throw err
    if results.length is 0
      req.flash('error','Page not found')
      res.redirect 'back'
    else
      res.render 'administration/pages/edit', page: results.pop()
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->