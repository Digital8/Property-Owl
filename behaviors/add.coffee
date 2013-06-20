module.exports = (model, args = {}) ->
  
  {singular, plural} = (require './_inflect') arguments...
  
  (req, res) ->
    
    model.new req.session.form, (error, instance) ->
      
      res.locals[singular] = instance
      
      (require './_all') req, res, args.all, (error) ->
        
        res.render "admin/#{plural}/add"
        
        delete req.session.form