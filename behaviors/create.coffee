module.exports = (model, args = {}) ->
  
  args.prefix ?= ''
  
  {singular, plural, prefix} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.build req, (error, instance) ->
      
      if error?
        for key, message of error.errors
          req.flash 'error', "#{key} - #{message}"
        req.session.form = req.body
        return res.redirect 'back'
      
      req.flash 'success', "#{model.name} (##{model.id}) created!"
      
      res.redirect args.redirect or "#{prefix}#{plural}"