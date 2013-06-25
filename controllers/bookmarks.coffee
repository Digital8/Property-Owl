exports.index = (req, res, next) ->
  
  Bookmark.forUser req.user, (error, bookmarks) ->
    
    return next error if error?
    
    bookmarks = (bookmark for bookmark in bookmarks when bookmark.entity?)
    
    res.render 'user/bookmarks', {bookmarks}

exports.create = (req, res, next) ->
  
  {user, entity} = req
  
  Bookmark.forUserAndDeal user, entity, (error, bookmark) ->
    
    return next error if erorr?
    
    return next 409 if bookmark?
    
    Bookmark.create
      entity_id: entity.id
      entity_type: entity.constructor.name.toLowerCase()
      user_id: req.user.id
    , (error, bookmark) ->
      
      return next error if error?
      
      res.send {}

exports.destroy = (require '../behaviors/destroy') Bookmark, prefix: ''