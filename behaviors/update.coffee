module.exports = (model, args = {}) ->
  
  {singular, plural, views, prefix, hooks} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.patch req.params.id, req.body, req: req, (error, instance) ->
      
      if error?
        for key, message of error.errors
          req.flash 'error', "#{key} - #{message}"
        req.session.form = req.body
        return res.redirect 'back'
      
      return res.send 404 unless instance?
      
      hooks.tail instance, req, res, (error) ->
        
        return next error if error?
        
        req.flash 'success', "#{model.name} updated!"
        
        res.redirect args.redirect or "#{prefix}#{plural}"