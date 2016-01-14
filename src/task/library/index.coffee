lib = require('../../lib')
pipe = require('../../pipe')
config = require('../../config')
util = require('../../util')

module.exports = util.fnOption(
  {
    spec: 'src/**/*.{js,coffee}'
    library: {}
  }
  (options) ->
    lib.gulp
    .src(spec)
    .pipe(pipe.library(options.library))
)