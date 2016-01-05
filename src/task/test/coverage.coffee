lib = require('../../lib')
config = require('../../config')

module.exports = (spec='test/coverage.coffee') ->
  lib.gulp
  .src(spec, { read: false })
  .pipe(lib.test.mocha(config.test.mocha))
