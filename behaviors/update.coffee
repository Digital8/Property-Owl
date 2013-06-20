module.exports = (model, args = {}) ->
  
  {singular, plural} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.patch req.params.id, req.body, (error, instance) ->
      
      return res.send 500, error if error?
      return res.send 404 unless instance?
      
      req.flash 'success', "#{model.name} updated!"
      res.redirect "admin/#{plural}"