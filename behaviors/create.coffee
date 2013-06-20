module.exports = (model, args = {}) ->
  
  {singular, plural} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.create req.body, (error, instance) ->
      
      if error?
        for key, message of error.errors
          req.flash 'error', "#{key} - #{message}"
        req.session.form = req.body
        return res.redirect 'back'
      
      req.flash 'success', "#{model.name} created!"
      res.redirect "admin/#{plural}"