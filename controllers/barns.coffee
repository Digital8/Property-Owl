system = require '../system'

Barn = system.models.barn

exports.index = (req, res) ->
  Barn.all (error, barns) ->
    res.render 'barns/index', barns: barns

# exports.locate = (req, res) ->
#   res.render 'owls/locate'

# exports.top = (req, res) ->
#   Owl.top (error, owl) ->
#     res.render 'owls/show', owl: owl

# exports.hot = (req, res) ->
#   Owl.all (error, owls) ->
#     res.render 'owls/list', owls: owls

# exports.byState = (req, res) ->
#   {state} = req.params
  
#   Owl.state state, (error, owls) ->
#     console.log owls
#     res.render 'owls/state', owls: owls, state: state

# exports.show = (req, res) ->
#   {id} = req.params
  
#   Owl.get id, (error, owl) ->
#     res.render 'owls/show', owl: owl