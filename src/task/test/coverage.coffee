lib = require('../../lib')
config = require('../../config')
util = require('../../util')

module.exports = util.fnOption(
  {
    spec: 'test/coverage.coffee'
    mocha: {}
  }
  (options) ->
    options.mocha = util.mergeOptions(config.mocha, options.mocha)

    lib.gulp
    .src(options.spec, { read: false })
    .pipe(lib.test.mocha(options.mocha))
)
