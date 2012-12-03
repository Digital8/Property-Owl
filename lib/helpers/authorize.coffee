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
    if res.locals.objUser.level is acl or res.locals.objUser.isAdmin()
      next()
    else
      #res.render 'errors/404'
      if req.url.indexOf('?login=1') is -1 
        res.redirect req.url + '?login=1'
      else
        res.render 'user/login', redirect: req.url or '/', modal: true