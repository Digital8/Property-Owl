module.exports = (model, args = {}) ->
  
  args.prefix ?= ''
  
  {singular, plural, prefix} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.build req, (error, instance) ->
      
      console.log error
      
      if error?
        for key, message of error.errors
          req.flash 'error', "#{key} - #{message}"
        req.session.form = req.body
        return res.redirect 'back'
      
      req.flash 'success', "#{model.name} created!"
      res.redirect "#{prefix}#{plural}"