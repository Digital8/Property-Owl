system = require '../system'

Category = system.models.category

# exports.index = (req, res) ->
#   Bookmark.forUser req.user, (error, bookmarks) ->
#     res.render 'user/bookmarks', bookmarks: bookmarks

exports.create = (req, res) ->
  {entity_type, key} = req.body
  
  map =
    entity_type: entity_type
    key: key
  
  Category.create map, (error, category) ->
    res.send category: category

exports.patch = (req, res) ->
  
  Category.patch req.params.id, req.body, (error, category) ->
    res.send status: 200

exports.destroy = (req, res) ->
  console.log 'deleting category with id', req.params.id or 'none'
  Category.delete req.params.id, (error, result) ->
    return res.send status: 400 if error?
    
    return res.send status: 404 unless result.affectedRows
    
    res.send status: 200

exports.add = (req, res) ->
  res.render 'admin/categories/add'

exports.dontDoNicksStupidCreate = (req,res) ->
  {entity_type, key} = req.body
  
  map =
    entity_type: entity_type
    key: key
  
  Category.create map, (error, category) ->
    req.body.key ?= ''

    req.assert('key', 'Category name is empty').len(1, 100).notEmpty()

    errors = req.validationErrors true
    
    if errors
      keys = Object.keys errors
      req.flash('error', errors[key].msg) for key in keys
      res.redirect 'back'
    else
      if error
        console.log error
        req.flash('error','An error occured: ' + error.code)
      else
        req.flash('success', 'Category created!')
        res.redirect 'admin/affiliates#categories'