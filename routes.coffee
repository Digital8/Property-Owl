###
 * Routes
 *
 * Binds the website routes to specific actions in controllers
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
system = require './system'
fs = require 'fs'

# Load in the controllers
controllers = {}

fs.readdirSync("./controllers").forEach (module) -> 
  controllers[module.split('.')[0]] = require("./controllers/" + module)

# Load in the helpers
helpers =
  requireAuth: system.load.helper 'requireAuth'
  checkModule: system.load.helper 'checkModule'
  checkRights: system.load.helper 'checkRights'
  restrictTo: system.load.helper 'restrictTo'

module.exports = (app) ->
  # index
  app.get '/', controllers.index.index
  
  # Sign-Up
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', helpers.requireAuth, controllers.account.index
  app.post '/account', helpers.requireAuth, controllers.account.update
  
  app.get '/deals/state', controllers.deals_state.index
  app.get '/deals/state/:state', controllers.deals_state.view
  
  app.get '/properties/view/:id', controllers.properties.view
  
  # News
  app.get '/news', controllers.news.index
  
  # Search
  
  app.get '/search', controllers.search.index
  
  # Administration Routes
  app.get '/administration', helpers.restrictTo(system.config.acl.admin), controllers.admin_index.index
  
  app.get '/administration/news', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.index
  app.post '/administration/news/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.create
  app.get '/administration/news/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.add
  app.get '/administration/news/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.edit
  app.put '/administration/news/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.update
  app.get '/administration/news/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.delete
  app.delete '/administration/news/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.destroy
  
  app.get '/administration/members', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.index
  app.get '/administration/members/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.add
  app.post '/administration/members/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.create
  app.get '/administration/members/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.edit
  app.put '/administration/members/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.update
  
  # Misc Routes
  app.get '/login', controllers.misc.login
  app.get '/logout', controllers.misc.logout
  app.post '/ajax/login', controllers.ajax.login
  