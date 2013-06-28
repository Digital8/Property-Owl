_ = require 'underscore'
async = require 'async'

module.exports = (db) ->
  
  adspaces = [
    {id: 1, key: 'top'}
    {id: 2, key: 'upper tower'}
    {id: 3, key: 'lower tower'}
    {id: 4, key: 'upper box'}
    {id: 5, key: 'lower box'}
  ]
  
  (req, res, next) ->
    
    # return next null unless req.method is 'get'
    
    res.locals.ads = []
    
    console.start 'ads'
    
    url = req.url.split('?')[0]
    
    # tmpUrl = url.split '/'
    # url = '/' + tmpUrl[1]
    
    # console.log tmpUrl
    
    # if tmpUrl[1] is 'owls' 
    #   if tmpUrl[2] in ['hot','top', 'locate'] then url += "/#{tmpUrl[2]}"
    
    [nil, resource, action] = url.split '/'
    
    url = "/#{resource}%"
    
    if url is '/%' then url = '/'
    
    # page
    db.query "SELECT page_id AS id FROM pages WHERE url LIKE ?", [url], (error, pages) =>
      
      return next null if error?
      
      return next null unless pages.length?
      
      async.times 5, (i, callback) ->
        Advertisement.random pages, adspaces[i], callback
      , (error, ads) ->
        
        if error?
          console.log error
          return next null
        
        res.locals.ads = ads
        
        console.stop 'ads'
        
        next? null