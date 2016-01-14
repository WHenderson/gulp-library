mergeOptions = require('./merge-options')

module.exports = (options..., create) ->
  (overrides...) ->
    return create(mergeOptions(options...))