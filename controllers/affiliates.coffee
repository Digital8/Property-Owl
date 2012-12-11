_ = require 'underscore'

system = require '../system'
async = require 'async'
Affiliate = system.models.affiliate

exports.index = (req, res) ->
  Affiliate.all (error, affiliates) ->
    res.render 'affiliates', affiliates: affiliates

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->