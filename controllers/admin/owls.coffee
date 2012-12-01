system = require '../../system'

Owl = system.models.owl

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'admin/owls/index', owls: owls