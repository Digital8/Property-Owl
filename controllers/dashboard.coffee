exports.index = (req,res) ->
  
  if res.locals.objUser.isAuthed()
    res.redirect '/dashboard'
  else
    res.render 'index'