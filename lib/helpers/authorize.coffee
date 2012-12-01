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
      req.flash('notice','You must be logged in to do this')
      res.render 'user/login', redirect: req.url or '/'