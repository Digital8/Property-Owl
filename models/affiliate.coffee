_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Affiliate extends Model
  @table = new Table
    name: 'affiliates'
    key: 'affiliate_id'
  
  @field 'title'