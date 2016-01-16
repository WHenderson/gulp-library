lib = require('../../lib')
pipe = require('../../pipe')
config = require('../../config')
util = require('../../util')
path = require('path')

module.exports = util.fnOption(
  {
    spec: 'src/**/*.{js,coffee}'
  }
  (options) ->
    lib.gulp
    .src(options.spec)
    .pipe(pipe.library(options))
    .pipe(lib.gulp.dest(path.join(config.output.base, config.output.dist)))
)