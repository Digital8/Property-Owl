###
 * UCWords
 *
 * Uppercase Words
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
module.exports = (str) ->
  return str.replace /\w\S*/g, (txt) -> return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()