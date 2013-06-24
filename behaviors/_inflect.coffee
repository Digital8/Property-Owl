module.exports = (model, args = {}) ->
  args.singular ?= model.name.toLowerCase()
  args.plural ?= model.table.name
  args.prefix ?= ''
  args.views ?= ''
  return args