mergeOptions = require('./merge-options')

module.exports = (options..., createLazy) ->
  return createLazy(mergeOptions(options...))()