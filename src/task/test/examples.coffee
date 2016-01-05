lib = require('../../lib')
config = require('../../config')

module.exports = (spec='test/examples.coffee') ->
  lib.gulp
  .src(spec, { read: false })
  .pipe(lib.test.mocha(lib.util.extend({}, config.test.mocha, config.test.mochaExamples)))
