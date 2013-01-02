async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Click extends Model
  @table = new Table
    name: 'clicks'
    key: 'click_id'
  
  @field 'resource_id'
  @field 'user_id'
  @field 'type'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    super callback

  @report: (cred, callback) ->
    query = "SELECT A.name as advertiser, ADV.description, ADV.start, count(C.click_id) AS click_count, C.click_id, C.created_at FROM po_advertisers as A INNER JOIN po_advertisements as ADV on A.advertiser_id = ADV.advertiser_id INNER JOIN clicks AS C ON C.resource_id = ADV.advertisement_id AND C.type = 'ad' WHERE"
    vals = []

    if cred.month != ''
      console.log cred
      query += ' MONTH(C.created_at) = ? AND'
      vals.push(cred.month)

    vals.push(cred.state)

    if (cred.advertiser != '0')
      query += ' A.advertiser_id = ? AND'
      vals.push(cred.advertiser)

    #query += ' GROUP BY U.user_id, O.approved'
    query += ' 1=1'
    @db.query query, vals, callback