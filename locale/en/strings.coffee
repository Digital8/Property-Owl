module.exports =
  messages = 
    add:
      pass: (model) -> "#{model} successfully added!"
      fail: (model) -> "#{model} failed to add!"

    remove:
      pass: (model) -> "#{model} successfully removed!"
      fail: (model) -> "#{model} failed to be removed!"

    update:
      pass: (model) -> "#{model} successfully updated!"
      fail: (model) -> "#{model} failed to update!"