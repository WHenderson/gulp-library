lib = require('../lib')

module.exports = (options...) ->
  lib.util.extend(true, {}, options...)