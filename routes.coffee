{acl, helpers, controllers} = require './system'

{authenticate, authorize} = helpers

module.exports = (app) ->
  app._all = app.all
  app.all = (path, middleware...) ->
    console.log "[route] [all] #{path}"
    app._all arguments...

  app._get = app.get
  app.get = (path, middleware...) ->
    console.log "[route] [get] #{path}"
    app._get arguments...

  app._put = app.put
  app.put = (path, middleware...) ->
    console.log "[route] [put] #{path}"
    app._put arguments...

  app._post = app.post
  app.post = (path, middleware...) ->
    console.log "[route] [post] #{path}"
    app._post arguments...

  app._delete = app.delete
  app.delete = (path, middleware...) ->
    console.log "[route] [delete] #{path}"
    app._delete arguments...
  
  app.get '/', controllers.index.index
  
  # auth
  app.all '/login', controllers.login.index
  app.get '/sign-out', controllers.signout.index
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create

  app.get '/adclick/:id', controllers.adclick.index
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', authenticate, controllers.account.index
  app.post '/account', authenticate, controllers.account.update
  
  app.get '/best-deal', authenticate, controllers.best_deal.index
  
  app.get '/saved', authenticate, controllers.saveddeals.index
  
  app.get '/products', authenticate, controllers.products.index
  
  # properties (owl deals)
  app.get '/properties', authenticate, controllers.properties.index
  app.get '/properties/state/:state', authenticate, controllers.properties.view
  app.get '/properties/:id', authenticate, controllers.properties.view
  
  # packages (barn deals)
  app.get '/packages', authenticate, controllers.packages.index
  app.get '/packages/:id', authenticate, controllers.packages.view
  
  #####
  # developer
  #####
  app.get '/developer/properties', (authorize acl.developer), (authorize acl.admin), controllers.dev.properties.index
  app.get '/developer/properties/add', (authorize acl.developer), (authorize acl.admin), controllers.dev.properties.add
  app.post '/developer/properties/add', (authorize acl.developer), (authorize acl.admin), controllers.dev.properties.create
  
  app.get '/developer/deals', (authorize acl.developer), (authorize acl.admin), controllers.dev.deals.index
  app.get '/developer/deals/add', (authorize acl.developer), (authorize acl.admin), controllers.dev.deals.add
  app.post '/developer/deals/add', (authorize acl.developer), (authorize acl.admin), controllers.dev.deals.create
  
  # news
  app.get '/news', authenticate, controllers.news.index
  app.get '/news/:id', authenticate, controllers.news.view
  
  # research
  app.get '/research', authenticate, controllers.research.index
  app.get '/research/:id', authenticate, controllers.research.view
  
  # search
  app.get '/search', authenticate, controllers.search.index
  
  #####
  # admin
  #####
  app.get '/admin', (authorize acl.admin), controllers.admin.index.index
  
  # advertising
  app.get '/admin/advertising', (authorize acl.admin), controllers.admin.advertising.index
  
  # advertisers
  app.get '/admin/advertisers', (authorize acl.admin), controllers.admin.advertisers.index
  app.post '/admin/advertisers/add', (authorize acl.admin), controllers.admin.advertisers.create
  app.get '/admin/advertisers/add', (authorize acl.admin), controllers.admin.advertisers.add
  app.get '/admin/advertisers/edit/:id', (authorize acl.admin), controllers.admin.advertisers.edit
  app.put '/admin/advertisers/edit/:id', (authorize acl.admin), controllers.admin.advertisers.update
  app.get '/admin/advertisers/delete/:id', (authorize acl.admin), controllers.admin.advertisers.delete
  app.delete '/admin/advertisers/delete/:id', (authorize acl.admin), controllers.admin.advertisers.destroy
  
  # advertisements
  app.get '/admin/advertisements', (authorize acl.admin), controllers.admin.advertisements.index
  app.post '/admin/advertisements/add', (authorize acl.admin), controllers.admin.advertisements.create
  app.get '/admin/advertisements/add', (authorize acl.admin), controllers.admin.advertisements.add
  app.get '/admin/advertisements/edit/:id', (authorize acl.admin), controllers.admin.advertisements.edit
  app.put '/admin/advertisements/edit/:id', (authorize acl.admin), controllers.admin.advertisements.update
  app.get '/admin/advertisements/delete/:id', (authorize acl.admin), controllers.admin.advertisements.delete
  app.delete '/admin/advertisements/delete/:id', (authorize acl.admin), controllers.admin.advertisements.destroy
  
  # news
  app.get '/admin/news', (authorize acl.admin), controllers.admin.news.index
  app.post '/admin/news/add', (authorize acl.admin), controllers.admin.news.create
  app.get '/admin/news/add', (authorize acl.admin), controllers.admin.news.add
  app.get '/admin/news/edit/:id', (authorize acl.admin), controllers.admin.news.edit
  app.put '/admin/news/edit/:id', (authorize acl.admin), controllers.admin.news.update
  app.get '/admin/news/delete/:id', (authorize acl.admin), controllers.admin.news.delete
  app.delete '/admin/news/delete/:id', (authorize acl.admin), controllers.admin.news.destroy
  
  # members
  app.get '/admin/members', (authorize acl.admin), controllers.admin.members.index
  app.get '/admin/members/add', (authorize acl.admin), controllers.admin.members.add
  app.post '/admin/members/add', (authorize acl.admin), controllers.admin.members.create
  app.get '/admin/members/edit/:id', (authorize acl.admin), controllers.admin.members.edit
  app.put '/admin/members/edit/:id', (authorize acl.admin), controllers.admin.members.update
  
  # pages
  app.get '/admin/pages', (authorize acl.admin), controllers.admin.pages.index
  app.get '/admin/pages/add', (authorize acl.admin), controllers.admin.pages.add
  app.get '/admin/pages/edit/:id', (authorize acl.admin), controllers.admin.pages.edit
  app.put '/admin/pages/edit/:id', (authorize acl.admin), controllers.admin.pages.update
  app.get '/admin/pages/delete/:id', (authorize acl.admin), controllers.admin.pages.delete
  app.post '/admin/pages/add', (authorize acl.admin), controllers.admin.pages.create
  app.delete '/admin/pages/delete/:id', (authorize acl.admin), controllers.admin.pages.destroy
  
  app.get '/admin/services', (authorize acl.admin), controllers.admin.services.index
  app.get '/admin/services/add', (authorize acl.admin), controllers.admin.services.add
  app.get '/admin/services/edit/:id', (authorize acl.admin), controllers.admin.services.edit
  app.put '/admin/services/edit/:id', (authorize acl.admin), controllers.admin.services.update
  app.get '/admin/services/delete/:id', (authorize acl.admin), controllers.admin.services.delete
  app.post '/admin/services/add', (authorize acl.admin), controllers.admin.services.create
  
  # TODO
  app.get '/admin/services/categories', (authorize acl.admin), controllers.admin.services.viewCategories
  app.get '/admin/services/categories/add', (authorize acl.admin), controllers.admin.services.addCategory
  app.post '/admin/services/categories/add', (authorize acl.admin), controllers.admin.services.createCategory
  app.get '/admin/services/categories/edit/:id', (authorize acl.admin), controllers.admin.services.editCategory
  app.put '/admin/services/categories/edit/:id', (authorize acl.admin), controllers.admin.services.updateCategory
  app.get '/admin/services/categories/delete/:id', (authorize acl.admin), controllers.admin.services.deleteCategory
  
  # barn
  app.get '/admin/barn', (authorize acl.admin), controllers.admin.barn.index
  app.get '/admin/barn/edit/:id', (authorize acl.admin), controllers.admin.barn.edit
  app.get '/admin/barn/add', (authorize acl.admin), controllers.admin.barn.add
  app.post '/admin/barn/add', (authorize acl.admin), controllers.admin.barn.create
  app.get '/admin/barn/delete/:barn_id/:property_id', (authorize acl.admin), controllers.admin.barn.delete
  app.del '/admin/barn/delete/:barn_id/:property_id', (authorize acl.admin), controllers.admin.barn.destroy
  
  # properties
  app.get '/admin/properties', (authorize acl.admin), controllers.admin.properties.index
  app.get '/admin/properties/add', (authorize acl.admin), controllers.admin.properties.add
  app.post '/admin/properties/add', (authorize acl.admin), controllers.admin.properties.create
  app.get '/admin/properties/edit/:id', (authorize acl.admin), controllers.admin.properties.edit
  app.put '/admin/properties/add', (authorize acl.admin), controllers.admin.properties.update
  
  #####
  # ajax
  #####
  app.post '/ajax/login', controllers.ajax.login
  app.post '/ajax/savedeal', authenticate, (authorize acl.admin), controllers.ajax.savedeal
  app.post '/ajax/removedeal', authenticate, (authorize acl.admin), controllers.ajax.removedeal
  app.post '/ajax/addDeal', authenticate, (authorize acl.admin), controllers.ajax.addDeal
  app.del '/ajax/deleteDeal', authenticate, (authorize acl.admin), controllers.ajax.delDeal
  app.put '/ajax/updateHero', authenticate, (authorize acl.admin), controllers.ajax.updateHero
  app.del '/ajax/deleteMedia', authenticate, (authorize acl.admin), controllers.ajax.deleteMedia
  app.get '/ajax/addRegistration', authenticate, controllers.ajax.addRegistration
  app.get '/ajax/delRegistration', authenticate, controllers.ajax.delRegistration

  app.all '*', controllers.pages.index