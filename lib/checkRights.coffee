###
 * CheckRights Helper
 *
 * Helper to restrict a page to specific ACL
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (code) ->
  (req,res,next) ->
    if res.locals.objUser.checkRights(code)
      next()
    else
      res.render 'errors/404'