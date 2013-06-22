exports.index   = (require '../behaviors/index')   Advertisement, views: 'admin/'
exports.add     = (require '../behaviors/add')     Advertisement, views: 'admin/', all: [Adspace, Page, Advertiser]
exports.create  = (require '../behaviors/create')  Advertisement, views: 'admin/'
exports.edit    = (require '../behaviors/edit')    Advertisement, views: 'admin/', all: [Adspace, Page, Advertiser]
exports.update  = (require '../behaviors/update')  Advertisement, views: 'admin/'
exports.delete  = (require '../behaviors/delete')  Advertisement, views: 'admin/'
exports.destroy = (require '../behaviors/destroy') Advertisement, views: 'admin/'

exports.click = (req, res) ->
  
  Advertisement.get req.params.id, (error, advertisement) ->
    
    return res.redirect '/' if error?
    return res.redirect '/' unless advertisement?
    
    Click.create
      entity_id: advertisement.id
      ip: req.ip
      user_id: req.session.user_id
      headers: JSON.stringify req.headers
      type: 'advertisement'
    , (error, click) ->
      res.redirect advertisement.hyperlink