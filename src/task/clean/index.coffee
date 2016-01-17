lib = require('../../lib')
config = require('../../config')
path = require('path')
util = require('../../util')

module.exports = util.fnOption(
  {
    src: undefined
    rimraf: {}
  }
  (options) ->
    src = options.src
    src ?= (path.join(config.output.base, outputPath) for own name, outputPath of config.output when name != 'base' and outputPath)

    return lib.gulp
    .src(src, { read: false })
    .pipe(lib.fs.rimraf(options.rimraf))
)


