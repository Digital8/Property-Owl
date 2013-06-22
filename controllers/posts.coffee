exports.type = (req, res) ->
  
  Post.findByType req.type, (error, instances) ->
    
    return res.send 500, error if error?
    
    res.render 'posts/index', posts: instances or []

exports.view = (require '../behaviors/view') Post

exports.index   = (require '../behaviors/index')   Post, views: 'admin/'
exports.add     = (require '../behaviors/add')     Post, views: 'admin/'
exports.create  = (require '../behaviors/create')  Post, views: 'admin/'
exports.edit    = (require '../behaviors/edit')    Post, views: 'admin/'
exports.update  = (require '../behaviors/update')  Post, views: 'admin/'
exports.delete  = (require '../behaviors/delete')  Post, views: 'admin/'
exports.destroy = (require '../behaviors/destroy') Post, views: 'admin/'