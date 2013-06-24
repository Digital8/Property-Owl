exports.index = (req, res, next) ->
  
  Bookmark.forUser req.user, (error, bookmarks) ->
    
    return next error if error?
    
    bookmarks = bookmark for bookmark in bookmarks when bookmark.entity?
    
    res.render 'user/bookmarks', {bookmarks}

exports.create = (req, res, next) ->
  
  Bookmark.create
    entity_id: req.body.id
    entity_type: req.body.type
    user_id: req.user.id
  , (error, bookmark) ->
    
    return next error if error?
    
    res.send {}

exports.destroy = (require '../behaviors/destroy') Bookmark, prefix: ''