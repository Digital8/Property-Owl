module.exports = (model, args = {}) ->
  
  args.prefix ?= 'admin'
  
  {singular, plural, prefix} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.delete req.params.id, (error, instance) ->
      
      return res.send 500, error if error?
      return res.send 404 unless instance?
      
      req.flash 'success', "#{model.name} destroyed!"
      res.redirect "#{prefix}/#{plural}"