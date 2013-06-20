async = require 'async'

module.exports = ->
  
  (req, res, next) ->
      
    console.start 'ads'
    
    url = req.url.split('?')[0]
    tmpUrl = url.split('/')
    url = '/' + tmpUrl[1]
    
    if tmpUrl[1] is 'owls' 
      if tmpUrl[2] in ['hot','top', 'locate'] then url += "/#{tmpUrl[2]}"
    
    url += '%'
    
    if url is '/%' then url = '/'
    
    async.parallel
      top       : (callback) -> Advertisement.random url, 'top',         callback
      upperTower: (callback) -> Advertisement.random url, 'upper tower', callback
      lowerTower: (callback) -> Advertisement.random url, 'lower tower', callback
      upperBox  : (callback) -> Advertisement.random url, 'upper box',   callback
      lowerBox  : (callback) -> Advertisement.random url, 'lower box',   callback
    , (err, results) ->
      
      res.locals.adspaceTop   = if results.top?         then results.top        else ''
      res.locals.adUpperTower = if results.upperTower?  then results.upperTower else ''
      res.locals.adLowerTower = if results.lowerTower?  then results.lowerTower else ''
      res.locals.adUpperBox   = if results.upperBox?    then results.upperBox   else ''
      res.locals.adLowerBox   = if results.lowerBox?    then results.lowerBox   else ''
      
      console.stop 'ads'
      
      next? null