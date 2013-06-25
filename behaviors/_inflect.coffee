module.exports = (model, args = {}) ->
  args.singular ?= model.name.toLowerCase()
  args.plural ?= model.table.name
  args.prefix ?= ''
  args.views ?= ''
  args.hooks ?= {}
  args.hooks.head ?= (args, req, res, next) -> next null
  args.hooks.tail ?= (args, req, res, next) -> next null
  return args