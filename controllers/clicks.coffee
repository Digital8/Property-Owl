system = require '../system'

Click = system.models.click

exports.create = (req, res) ->
  req.body.user_id = req.user.id
  
  Click.create req.body, (error, click) ->
    console.log arguments
    
    res.send status: 200