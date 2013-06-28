async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  async.parallel
    
    owl: (callback) -> Owl.top callback
    page: (callback) -> Page.block req.url, 'master', callback
  
  , (error, {owl, page}) ->
    
    try
      res.render 'index',
        owl: owl
        home: page.html
    
    catch {message}
      res.render 'errors/500', {message}