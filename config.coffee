###
 * Configuration
 *
 * Application Settings
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <bscarvell@gmail.com>
 * @copyright Copyright (c) 2012 - Current
 ###
 
module.exports =
  globals:
    site:
      name: 'Property Owl'

  database:
    type    : 'mysql'
    host    : 'localhost'
    user    : 'root'
    password: ''
    name    : 'po'
    prefix  : 'po_'
  
  modules:
    login     : true
    register  : true
  
  acl:
    banned : 102
    member : 103
    expert : 104
    staff  : 105
    admin  : 106
    
  port: 8080