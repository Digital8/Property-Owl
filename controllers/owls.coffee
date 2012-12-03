system = require '../system'

Owl = system.models.owl

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'owls/index', owls: owls

exports.locate = (req, res) ->
  res.render 'owls/locate'

exports.top = (req, res) ->
  Owl.top (error, owl) ->
    res.render 'owls/show', owl: owl, bestdeal: true

exports.hot = (req, res) ->
  Owl.all (error, owls) ->
    maxPages = Math.round(owls.length / 10)
    
    if not req.query.page? then offset = 0 else offset = (parseInt(req.query.page) - 1) * 10
    if owls.length > 10
      # remove off the front so we don't display the first results if we're browsing pages
      owls.shift() for i in [0...offset]

    res.render 'owls/list', owls: owls, maxPages: maxPages, currentPage: req.query.page or 1

exports.byState = (req, res) ->
  {state} = req.params
  
  Owl.state state, (error, owls) ->
    console.log owls
    res.render 'owls/state', owls: owls, state: state

exports.show = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    res.render 'owls/show', owl: owl