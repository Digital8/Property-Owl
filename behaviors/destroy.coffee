module.exports = (model, args = {}) ->
  
  args.prefix ?= 'admin'
  
  {singular, plural, prefix} = (require './_inflect') arguments...
  
  (req, res, next) ->
    
    model.delete req.params.id, (error, instance) ->
      
      return next error if error?
      return next 404 unless instance?
      
      req.flash 'success', "#{model.name} destroyed!"
      
      if req.xhr
        res.send {}
      else
        res.redirect args.redirect or "#{prefix}/#{plural}"