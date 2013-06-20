exports.index = (req, res) ->
  
  Post.findByType req.type, (error, instances) ->
    
    return res.send 500, error if error?
    
    res.render 'posts/index', posts: instances or []

exports.view = (require '../behaviors/view') Post