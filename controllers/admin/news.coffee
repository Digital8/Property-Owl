system = require '../../system'
async = require 'async'


models = 
  news: system.load.model 'news'
  user: system.load.model 'user'

helpers = mailer: system.load.mailer

exports.index = (req,res) ->
  models.news.getAllNews (err, results) ->
    if err then throw err
    
    res.render 'admin/news/index', news: results

exports.view = (req,res) ->

exports.add = (req,res) -> res.render 'admin/news/add'

exports.create = (req,res) ->
  req.body.id = res.locals.objUser.id
  
  models.news.insert req.body, (err, results) ->
    if err
      req.flash 'error','Some unknown error occured'
      
      res.redirect 'back'
    else
      req.flash 'success','News post submitted'
      # Email everyone
      sendEmail = (user, callback) ->
        template = 'news'

        user =
          firstName: user.first_name
          email: user.email

        secondary =
          title: req.body.title
          summary: req.body.content
          link: '/news/#{results.insertId}'


        system.helpers.mailer template,'Newsletter', user, secondary, (results) ->
          callback()

      # Get news subscribers
      models.user.getSubscribers (err, users) ->
        # Email each user
        async.map users, sendEmail, (err, results) ->

          res.redirect '/admin/news'

exports.edit = (req,res) ->
  models.news.getNewsById req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      
      res.redirect '/admin/news'
    else
      res.render 'admin/news/edit', news: results.pop() or {}

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
      
      res.redirect '/admin/news'

exports.delete = (req, res) ->
  models.news.getNewsById req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      res.redirect '/admin/news'
    
    else
      res.render 'admin/news/delete', news: results.pop() or {}

exports.destroy = (req,res) ->
  models.news.delete req.params.id, (err, results) ->
    req.flash 'success', 'news post deleted'
    
    res.redirect '/admin/news'