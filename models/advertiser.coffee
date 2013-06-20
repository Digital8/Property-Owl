Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Advertiser extends Model
  
  @table = new Table
    name: 'advertisers'
    key: 'advertiser_id'
  
  @field 'name', type: String, required: yes
  @field 'description', type: String, required: yes
  @field 'contactee', type: String, required: yes
  @field 'email', type: String, required: yes
  @field 'phone', type: String, required: yes
  @field 'address', type: String, required: yes
  @field 'suburb', type: String, required: yes
  @field 'state', type: String, required: yes
  @field 'postcode', type: String, required: yes
  @field 'created_at'
  @field 'updated_at'