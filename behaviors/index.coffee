module.exports = (model, args = {}) ->
  
  {singular, plural, views, prefix} = (require './_inflect') arguments...
  
  (req, res) ->
  
    model.all (error, instances) ->
      
      return res.send 500, error if error?
      
      res.locals[plural] = instances
      
      (require './_all') req, res, args.all, ->
        
        res.render "#{views}#{plural}/index"