async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  async.parallel
  
    owl: (callback) -> Owl.top callback
    page: (callback) -> Page.findByUrl '/', callback
  
  , (error, {owl, page}) ->
    
    try
      res.render 'index',
        owl: owl
        home: do jade.compile page.content
    
    catch {message}
      res.render 'errors/500', {message}