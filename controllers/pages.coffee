exports.index = (req, res) ->
  
  url = req.params.pop()
  
  Page.findByUrl url, (error, page) ->
    
    return res.send 500, error if error?
    return res.send 404 unless page?
    
    unless page.enabled
      return res.render 'errors/404'
    
    res.render 'page', {page}