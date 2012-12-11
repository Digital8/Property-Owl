system = require '../system'

Bookmark = system.models.bookmark

exports.index = (req, res) ->
  Bookmark.forUser req.user, (error, bookmarks) ->
    console.log bookmarks
    res.render 'user/bookmarks', bookmarks: bookmarks