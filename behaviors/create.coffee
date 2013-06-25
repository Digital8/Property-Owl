module.exports = (model, args = {}) ->
  
  args.prefix ?= ''
  
  {singular, plural, prefix, hooks} = (require './_inflect') arguments...
  
  (req, res, next) ->
    
    model.build req, (error, instance) ->
      
      if error?
        for key, message of error.errors
          req.flash 'error', "#{key} - #{message}"
        req.session.form = req.body
        return res.redirect 'back'
      
      hooks.tail instance, req, res, (error) ->
        
        return next error if error?
        
        req.flash 'success', "#{model.name} (##{instance.id}) created!"
        
        res.redirect args.redirect or "#{prefix}#{plural}"