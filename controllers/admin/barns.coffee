system = require '../../system'

Barn = system.models.barn

exports.index = (req, res) ->
  Barn.all (error, barns) ->
    res.render 'admin/barns/index', barns: barns

exports.add = (req, res) ->
  res.render 'admin/barns/add'