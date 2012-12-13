system = require '../../system'

async = require 'async'

helpers = mailer: system.load.mailer

News = system.models.news

exports.index = (req, res) ->
  News.all (error, news) ->
    throw error if error
    
    res.render 'admin/news/index', news: news

exports.view = (req, res) ->

exports.add = (req, res) ->
  News.new (error, post) ->
    res.render 'admin/news/add', post: post

exports.create = (req, res) ->
  req.body.id = req.user.id
  
  News.create req.body, (error, post) ->
    if error?
      console.log error
      
      req.flash 'error', 'Some unknown error occured'
      
      res.redirect 'back'
      
      return
    
    req.flash 'success', 'News post submitted'
    
    res.redirect '/admin/news'
    
    #   # Email everyone
    #   sendEmail = (user, callback) ->
    #     template = 'news'

    #     user =
    #       firstName: user.first_name
    #       email: user.email

    #     secondary =
    #       title: req.body.title
    #       summary: req.body.content
    #       link: '/news/#{results.insertId}'


    #     system.helpers.mailer template,'Newsletter', user, secondary, (results) ->
    #       callback()

    #   # Get news subscribers
    #   models.user.getSubscribers (err, users) ->
    #     # Email each user
    #     async.map users, sendEmail, (err, results) ->

    #       res.redirect '/admin/news'

exports.edit = (req, res) ->
  News.get req.params.id, (error, post) ->
    unless post?
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      
      res.redirect '/admin/news'
      
      return
    
    res.render 'admin/news/edit', post: post

exports.update = (req, res) ->
  News.update req.params.id, req.body, (error, post) ->
    if error?
      req.flash 'error', 'an error occured updating the post'
      
      res.redirect 'back'
      
      return
    
    req.flash 'success', 'news entry updated'
    
    res.redirect '/admin/news'

exports.delete = (req, res) ->
  News.get req.params.id, (error, post) ->
    if error?
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      
      res.redirect '/admin/news'
      
      return
    
    res.render 'admin/news/delete', post: post

exports.destroy = (req, res) ->
  models.news.delete req.params.id, (err, results) ->
    req.flash 'success', 'news post deleted'
    
    res.redirect '/admin/news'