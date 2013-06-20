uuid = require 'node-uuid'

exports.index = (req,res) ->
  
  if not req.query.email or not req.query.code
    res.render 'user/forgot_pwd'
  else
    email = req.query.email

    models.recovery.check req.query, (err, results) ->
      if results.length > 0
        # Generate a new random password
        pwd = (helpers.hash(uuid() + req.body.email)).substr(0,8)

        # Get the user details by email
        models.user.getUserByEmail email, (error, userInfo) ->
          if userInfo.length > 0 then userInfo = userInfo.pop()
          
          # Update their password
          models.user.updatePassword {password: helpers.hash(pwd), id: userInfo.user_id}, (err, results) ->
             # Add emailer code here
            template = 'password-reset'

            user =
              email: email

            secondary = 
              contactName: userInfo.first_name
              code: pwd or ''

            system.helpers.mailer template,'Password Recovery', user, secondary, (results) ->
              models.recovery.delete email, ->
                req.flash('success','Your new password has been emailed to you.')
                res.redirect '/account/recover'
      else
        res.redirect '/'

exports.create = (req,res) ->
  email = req.body.email or ''

  models.user.getUserByEmail email, (error, userInfo) ->
    if userInfo? and userInfo.length > 0
      userInfo = userInfo.pop()
      code = (helpers.hash(uuid() + req.body.email)).substr(0,25)
      models.recovery.delete email, (err, results) ->
        if err then console.log err
        models.recovery.add {email: email, code: code}, (err, results) ->
          if err
            req.flash('error','DB error occured: ' + err.code)
          else
            # Add emailer code here
            template = 'forgot-password'

            user =
              email: email

            secondary = 
              contactName: userInfo.first_name
              code: code or ''

            system.helpers.mailer template,'Password Recovery', user, secondary, (results) ->
              req.flash('success','An email has been sent with reset instructions')
              res.redirect 'back'
    else
      req.flash('error','Unable to find a user with that email address')
      res.redirect '/account/recover'