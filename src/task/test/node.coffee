lib = require('../../lib')
config = require('../../config')
util = require('../../util')
pipe = require('../../pipe')
YAML = require('yamljs')
fs = require('fs')
path = require('path')

module.exports = util.fnOption(
  {
    spec: 'test/node.coffee'
    mocha: {
      compilers: 'coffee:coffee-script/register'
      istanbul: false
    }
    collectCoverage: {}
  }
  (options) ->
    options.mocha = util.mergeOptions(config.mocha, options.mocha)

    lib.gulp
    .src(options.spec, { read: false })
    .pipe(lib.test.mocha(options.mocha))
    .pipe(pipe.collectCoverage(options.collectCoverage))
)
