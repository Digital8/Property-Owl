_ = require 'underscore'

exports.click = (req, res) ->
  
  Advertisement.get req.params.id, (error, advertisement) ->
    
    return res.redirect '/' if error?
    return res.redirect '/' unless advertisement?
    
    Click.create
      entity_id: advertisement.id
      ip: req.ip
      user_id: req.session.user_id
      headers: JSON.stringify req.headers
      type: 'advertisement'
    , (error, click) ->
      res.redirect advertisement.hyperlink