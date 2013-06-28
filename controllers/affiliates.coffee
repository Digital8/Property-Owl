exports.index   = (require '../behaviors/index')   Affiliate, views: 'admin/', all: [Category]
exports.add     = (require '../behaviors/add')     Affiliate, views: 'admin/', all: [Category]
exports.create  = (require '../behaviors/create')  Affiliate, views: 'admin/'
exports.edit    = (require '../behaviors/edit')    Affiliate, views: 'admin/', all: [Category]
exports.update  = (require '../behaviors/update')  Affiliate, views: 'admin/', all: [Category]
exports.delete  = (require '../behaviors/delete')  Affiliate, views: 'admin/', all: [Category]
exports.destroy = (require '../behaviors/destroy') Affiliate, views: 'admin/', all: [Category]
exports.view    = (require '../behaviors/view')    Affiliate, views: 'admin/'

async = require 'async'

exports.browse = (req, res) ->
    
    async.parallel
      
      affiliates: (callback) ->
        if req.query.category
          Affiliate.byCategory req.query.category, callback
        unless req.query.category
          Affiliate.all callback
      
      categories: (callback) -> Category.for 'affiliate', callback
      
      page: (callback) -> Page.block '/affiliates', 'master', callback
    
    , (error, {affiliates, categories, page}) ->
      
      try
        
        res.render 'affiliates/index',
          affiliates: affiliates
          categories: categories
          id: req.query.category or 0
          cms: page.html
      
      catch e
        
        res.render 'errors/404'