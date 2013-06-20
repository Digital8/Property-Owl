exports.index = (req, res) ->
  Bookmark.forUser req.user, (error, bookmarks) ->
    return res.send 500, error if error?
    console.log bookmarks
    res.render 'user/bookmarks', {bookmarks}

exports.create = (req, res) ->
  
  map =
    entity_id: req.body.id
    type: req.body.type
    user_id: req.user.id
  
  Bookmark.create map, (error, bookmark) ->
    res.send 200

exports.destroy = (require '../behaviors/destroy') Bookmark, prefix: ''