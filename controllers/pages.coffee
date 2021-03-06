jade = require 'jade'

exports.index   = (require '../behaviors/index')   Page, views: 'admin/'
exports.add     = (require '../behaviors/add')     Page, views: 'admin/'
exports.create  = (require '../behaviors/create')  Page, views: 'admin/'
exports.edit    = (require '../behaviors/edit')    Page, views: 'admin/'
exports.update  = (require '../behaviors/update')  Page, views: 'admin/'
exports.delete  = (require '../behaviors/delete')  Page, views: 'admin/'
exports.destroy = (require '../behaviors/destroy') Page, views: 'admin/'

exports.serve = (req, res, next) ->
  
  url = req.params.pop()
  
  Page.cms url, (error, page) ->
    
    return res.send 500, error if error?
    return res.send 404 unless page?
    
    unless page.enabled
      
      return res.render 'errors/404'
    
    try
      page.req = req
      res.render 'page', {page}
    catch error
      next error