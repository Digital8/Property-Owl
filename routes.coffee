{acl, helpers, controllers} = require './system'

{authenticate, authorize} = helpers

module.exports = (app) ->
  app.get '/', controllers.index.index
  
  # auth
  #app.all '/login', controllers.login.index
  app.get '/sign-out', controllers.misc.logout
  app.get '/logout', controllers.misc.logout
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create
  
  app.get '/adclick/:id', controllers.adclick.index
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', authenticate, controllers.account.index
  app.post '/account', authenticate, controllers.account.update
  
  app.get '/saved', authenticate, controllers.saveddeals.index
  
  app.get '/products', authenticate, controllers.products.index
  
  owl = (method, path, middleware...) ->
    app.get "/owls#{path}", authenticate, middleware...
  
  owl 'get', '', controllers.owls.index
  owl 'get', '/:id(\\d+)', controllers.owls.show
  owl 'get', '/top', controllers.owls.top
  owl 'get', '/hot', controllers.owls.hot
  owl 'get', '/locate', controllers.owls.locate
  owl 'get', '/state/:state', controllers.owls.byState
  
  barn = (method, path, middleware...) ->
    app[method] "/barns#{path}", authenticate, middleware...
  
  barn 'get', '', controllers.barns.index
  barn 'get', "/:id(\\d+)", controllers.barns.show
  
  developer = (method, path, middleware...) ->
    app[method] "/developer#{path}", (authorize acl.developer), (authorize acl.admin), middleware...
  
  developer 'get', '/properties', controllers.dev.properties.index
  developer 'get', '/properties/add', controllers.dev.properties.add
  developer 'get', '/properties/add', controllers.dev.properties.create
  
  developer 'get', '/deals', controllers.dev.deals.index
  developer 'get', '/deals/add', controllers.dev.deals.add
  developer 'get', '/deals/add', controllers.dev.deals.create
  
  news = (method, path, middleware...) ->
    app[method] "/news#{path}", middleware...
  
  news 'get', '', controllers.news.index
  news 'get', '/:id(\\d+)', controllers.news.view
  
  research = (method, path, middleware...) ->
    app[method] "/research#{path}", authenticate, middleware...
  
  research 'get', '', controllers.research.index
  research  'get', '/:id(\\d+)', controllers.research.view
  
  ### search ###
  search = (method, path, middleware...) ->
    app[method] "/search#{path}", authenticate, middleware...
  
  search 'get', '', controllers.search.index
  
  ### admin ###
  admin = (method, path, middleware...) ->
    app[method] "/admin#{path}", (authorize acl.admin), middleware...
  
  admin 'get', '', controllers.admin.index.index
  
  # admin/advertising
  admin 'get', '/advertising', controllers.admin.advertising.index
  
  # admin/advertisers
  admin 'get', '/advertisers', controllers.admin.advertisers.index
  admin 'post', '/advertisers/add', controllers.admin.advertisers.create
  admin 'get', '/admin/advertisers/add', controllers.admin.advertisers.add
  admin 'get', '/admin/advertisers/edit/:id(\\d+)', controllers.admin.advertisers.edit
  admin 'put', '/admin/advertisers/edit/:id(\\d+)', controllers.admin.advertisers.update
  admin 'get', '/admin/advertisers/delete/:id(\\d+)', controllers.admin.advertisers.delete
  admin 'delete', '/admin/advertisers/delete/:id(\\d+)', controllers.admin.advertisers.destroy
  
  # admin/advertisements
  admin 'get', '/advertisements', controllers.admin.advertisements.index
  admin 'post', '/advertisements/add', controllers.admin.advertisements.create
  admin 'get', '/advertisements/add', controllers.admin.advertisements.add
  admin 'get', '/advertisements/edit/:id(\\d+)', controllers.admin.advertisements.edit
  admin 'put', '/advertisements/edit/:id(\\d+)', controllers.admin.advertisements.update
  admin 'get', '/advertisements/delete/:id(\\d+)', controllers.admin.advertisements.delete
  admin 'delete', '/advertisements/delete/:id(\\d+)', controllers.admin.advertisements.destroy
  
  # admin/news
  admin 'get', '/news', controllers.admin.news.index
  admin 'post', '/news/add', controllers.admin.news.create
  admin 'get', '/news/add', controllers.admin.news.add
  admin 'get', '/news/edit/:id(\\d+)', controllers.admin.news.edit
  admin 'put', '/news/edit/:id(\\d+)', controllers.admin.news.update
  admin 'get', '/news/delete/:id(\\d+)', controllers.admin.news.delete
  admin 'delete', '/news/delete/:id(\\d+)', controllers.admin.news.destroy
  
  # admin/members
  admin 'get', '/members', controllers.admin.members.index
  admin 'get', '/members/add', controllers.admin.members.add
  admin 'post', '/members/add', controllers.admin.members.create
  admin 'get', '/members/edit/:id(\\d+)', controllers.admin.members.edit
  admin 'put', '/members/edit/:id(\\d+)', controllers.admin.members.update
  
  # admin/pages
  admin 'get', '/pages', controllers.admin.pages.index
  admin 'get', '/pages/add', controllers.admin.pages.add
  admin 'get', '/pages/edit/:id(\\d+)', controllers.admin.pages.edit
  admin 'put', '/pages/edit/:id(\\d+)', controllers.admin.pages.update
  admin 'get', '/pages/delete/:id(\\d+)', controllers.admin.pages.delete
  admin 'post', '/pages/add', controllers.admin.pages.create
  admin 'delete', '/pages/delete/:id(\\d+)', controllers.admin.pages.destroy
  
  admin 'get', '/services', controllers.admin.services.index
  admin 'get', '/services/add', controllers.admin.services.add
  admin 'get', '/services/edit/:id(\\d+)', controllers.admin.services.edit
  admin 'put', '/services/edit/:id(\\d+)', controllers.admin.services.update
  admin 'get', '/services/delete/:id(\\d+)', controllers.admin.services.delete
  admin 'post', '/services/add', controllers.admin.services.create
  
  # admin/services/categories
  admin 'get', '/services/categories', controllers.admin.services.viewCategories
  admin 'get', '/services/categories/add', controllers.admin.services.addCategory
  admin 'post', '/services/categories/add', controllers.admin.services.createCategory
  admin 'get', '/services/categories/edit/:id(\\d+)', controllers.admin.services.editCategory
  admin 'put', '/services/categories/edit/:id(\\d+)', controllers.admin.services.updateCategory
  admin 'get', '/services/categories/delete/:id(\\d+)', controllers.admin.services.deleteCategory
  
  # admin/owls
  admin 'get', '/owls', controllers.admin.owls.index
  admin 'get', '/owls/add', controllers.admin.owls.add
  admin 'post', '/owls', controllers.admin.owls.create
  admin 'get', '/owls/:id(\\d+)/edit', controllers.admin.owls.edit
  admin 'put', '/owls/:id(\\d+)', controllers.admin.owls.update
  admin 'get', '/owls/:id(\\d+)/delete', controllers.admin.owls.delete
  admin 'del', '/owls/:id(\\d+)', controllers.admin.owls.destroy
  
  # admin/barn
  admin 'get', '/barns', controllers.admin.barns.index
  admin 'get', '/barns/add', controllers.admin.barns.add
  admin 'post', '/barns', controllers.admin.barns.create
  admin 'get', '/barns/:id(\\d+)/edit', controllers.admin.barns.edit
  admin 'get', '/barns/delete/:barn_id(\\d+)/:owl_id(\\d+)', controllers.admin.barns.delete
  admin 'del', '/barns/delete/:barn_id(\\d+)/:owl_id(\\d+)', controllers.admin.barns.destroy
  
  # admin/reports
  admin 'get', '/reports', controllers.admin.reports.index
  admin 'get', '/reports/dealListings', controllers.admin.reports.dealListings
  admin 'get', '/reports/websiteRegistrations', controllers.admin.reports.websiteRegistrations
  admin 'get', '/reports/propertySearches', controllers.admin.reports.propertySearches
  admin 'get', '/reports/dealRegistrations', controllers.admin.reports.dealRegistrations
  admin 'get', '/reports/servicesEnquiries', controllers.admin.reports.servicesEnquiries
  admin 'get', '/reports/advertisingClicks', controllers.admin.reports.advertisingClicks
  
  ### ajax ###
  ajax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", middleware...
  
  ajax 'post', '/login', controllers.ajax.login
  ajax 'post', '/register', controllers.ajax.register
  
  authedAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, middleware...
  
  authedAjax 'post', '/securedeal', controllers.ajax.securedeal
  authedAjax 'post', '/referfriend', controllers.ajax.referfriend
  authedAjax 'get', '/addRegistration', controllers.ajax.addRegistration
  authedAjax 'get', '/delRegistration', controllers.ajax.delRegistration
  
  adminAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, (authorize acl.admin), middleware...
  
  adminAjax 'post', '/savedeal', controllers.ajax.savedeal
  adminAjax 'post', '/removedeal', controllers.ajax.removedeal
  adminAjax 'post', '/addDeal', controllers.ajax.addDeal
  adminAjax 'del', '/deleteDeal', controllers.ajax.delDeal
  adminAjax 'put', '/updateHero', controllers.ajax.updateHero
  adminAjax 'del', '/deleteMedia', controllers.ajax.deleteMedia
  
  app.all '*', controllers.pages.index