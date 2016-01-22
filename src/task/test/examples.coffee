lib = require('../../lib')
config = require('../../config')
util = require('../../util')
path = require('path')

module.exports = util.fnOption(
  {
    mocha: {
      compilers: ' '
      istanbul: false
    }
  }
  (options) ->
    lib.gulp
    .src(path.resolve(__dirname, '../../mocha-examples.{js,coffee}'), { read: false, base: require('process').cwd() })
    .pipe(lib.pipe.through2Map.obj((file) ->
      debugger
      return file
    ))
    .pipe(lib.debug.debug({ title: 'testing' }))
    .pipe(lib.test.mocha(options.mocha))
)

