lib = require('../../lib')
config = require('../../config')
util = require('../../util')
path = require('path')

module.exports = util.fnOption(
  {
    mocha: {
      compilers: 'coffee:coffee-script/register'
      istanbul: false
    }
  }
  (options) ->
    options.mocha = util.mergeOptions(config.mocha, options.mocha)

    lib.gulp
    .src(path.resolve(__dirname, '../../mocha-examples.{js,coffee}'), { read: false })
    .pipe(lib.test.mocha(options.mocha))
)

