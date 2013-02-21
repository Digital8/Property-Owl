###
 * RestrictTo Helper
 *
 * Helper to restrict a page to specific ACL
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (acl) ->
  (req,res,next) ->
    console.log(res.locals.objUser.level)
    if (res.locals.objUser.level == acl) or res.locals.objUser.isAdmin()
      next()
    else
      #res.render 'errors/404'
      if req.url.indexOf('?login=1') is -1 
        res.redirect req.url + '?login=1'
      else
        if not res.locals.objUser.isAuthed() 
          res.render 'user/login', redirect: req.url or '/', modal: true
        else
          res.render 'errors/404'