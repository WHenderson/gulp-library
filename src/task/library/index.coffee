lib = require('../../lib')
pipe = require('../../pipe')
config = require('../../config')
util = require('../../util')
path = require('path')

module.exports = util.fnOption(
  {
    base: undefined
    spec: 'src/**/*.{js,coffee}'
    library: {}
  }
  (options) ->
    options.base ?= util.findPackageRoot()

    if typeof options.spec == 'string'
      options.spec = [options.spec]

    options.spec = (path.join(options.base, spec) for spec in options.spec)

    lib.gulp
    .src(options.spec)
    .pipe(pipe.library(
      { base: options.base }
      options.library
    ))
    .pipe(lib.gulp.dest(path.join(options.base, config.output.dist)))
)