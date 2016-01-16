lib = require('../../lib')
config = require('../../config')

module.exports = (src) ->
  src ?= (path for own name, path of config.output when name != 'base')

  return lib.gulp
  .src(src, { read: false })
  .pipe(lib.fs.rimraf())


