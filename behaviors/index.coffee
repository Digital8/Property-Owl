module.exports = (model, args = {}) ->
  
  {singular, plural} = (require './_inflect') arguments...
  
  (req, res) ->
  
    model.all (error, instances) ->
      
      return res.send 500, error if error?
      
      res.locals[plural] = instances
      
      res.render "admin/#{plural}/index"