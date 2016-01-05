lib = require('../../lib')
config = require('../../config')
path = require('path')

module.exports = (src, dest) ->
  switch {}.toString.call(src)
    when '[object Object]'
      return lib.pipe.sequence((module.exports(srcPath, path.join(dest, srcName)) for own srcName, srcPath of src)...)

    else
      return lib.gulp
      .src(src)
      .pipe(dest)
