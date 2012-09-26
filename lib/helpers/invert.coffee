###
 * Invert Helper
 *
 * Helper to quickly invert an object keys & values
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (obj) ->
  newObject = {}
  keys = Object.keys(obj)
  
  for key in keys
    newObject[obj[key]] = key
  

  return newObject