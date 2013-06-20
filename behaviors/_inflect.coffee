module.exports = (model, args = {}) ->
  args.singular ?= model.name.toLowerCase()
  args.plural ?= "#{model.name.toLowerCase()}s"
  return args