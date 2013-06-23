module.exports = (model, args = {}) ->
  
  {singular, plural} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.get req.params.id, (error, instance) ->
      
      return res.send 500, error if error?
      
      return res.send 404 unless instance?
      
      res.locals[singular] = instance
      
      (require './_all') req, res, args.all, ->
      
        res.render "admin/#{plural}/edit"