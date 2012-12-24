async = require 'async'
jade = require 'jade'

system = require '../system'

exports.index = (req,res) ->
  Owl = system.models.owl
  Page = system.models.page
  
  async.parallel
    owl: (callback) -> Owl.top callback
    page: (callback) -> Page.findByUrl '/', callback
  , (error, {owl, page}) ->
    page = page.shift().shift()
    fn = jade.compile page.content
    home = do fn
    res.render 'index', owl: owl, home: home

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->