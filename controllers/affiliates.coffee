async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
    
    async.parallel
      
      affiliates: (callback) ->
        if req.query.category
          Affiliate.byCategory req.query.category, callback
        unless req.query.category
          Affiliate.all callback
      
      categories: (callback) -> Category.for 'affiliate', callback
      
      page: (callback) -> Page.findByUrl '/affiliates', callback
    
    , (error, {affiliates, categories, page}) ->
      
      try
        
        res.render 'affiliates/index',
          affiliates: affiliates
          categories: categories
          id: req.query.category or 0
          cms: do jade.compile page.content
      
      catch e
        
        res.render 'errors/404'