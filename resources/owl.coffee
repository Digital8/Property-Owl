Resource = require '../lib/resource'

module.exports = class Owl extends Resource
  @model require '../models/owl'
  
  @scope 'top',
    query:
      select: [
        'SUM(deals.value) AS deal'
        'SUM(deals.value) / price AS ratio'
      ],
      join: "LEFT JOIN deals ON (deals.entity_id = owls.owl_id AND deals.type = 'owl')"