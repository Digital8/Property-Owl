system = require '../system'

Bookmark = system.models.bookmark

exports.index = (req, res) ->
  Bookmark.forUser req.user, (error, bookmarks) ->
    res.render 'user/bookmarks', bookmarks: bookmarks

exports.create = (req, res) ->
  {type, id} = req.body
  
  user = res.locals.objUser
  
  row =
    entity_id: id
    type: type
    user_id: user.id
    created_at: new Date
  
  system.db.query "INSERT INTO bookmarks SET ?", row, ->
    res.send status: 200

exports.destroy = (req, res) ->
  system.db.query "DELETE FROM bookmarks WHERE bookmark_id = ?", req.params.id, (error, result) ->
    return res.send status: 400 if error?
    
    return res.send status: 404 unless result.affectedRows
    
    res.send status: 200