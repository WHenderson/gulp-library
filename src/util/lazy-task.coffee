mergeOptions = require('./merge-options')

module.exports = (options..., createLazy) ->
  (overrides...) ->
    return createLazy(mergeOptions(options...))()