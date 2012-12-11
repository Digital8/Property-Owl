Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class AffiliateCategory extends Model
  @table = new Table
    name: 'affiliate_categories'
    key: 'affiliate_category_id'
  
  constructor: (args = {}) ->
    super