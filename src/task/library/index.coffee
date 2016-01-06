lib = require('../../lib')
pipe = require('../../pipe')
config = require('../../config')
util = require('../../util')

name2id = (name) ->
  name.replace(/-([a-zA-Z0-9])/g, (match, ch) -> ch.toUpperCase()).replace(/\W/g, '')

module.exports = (spec, options) ->
  options = {}

  name = util.loadPackageJson(options.packageJson)
  id = if options.apply then name2id('apply-' + name) else name2id(name)

  umdOptions = lib.util.extend(
    {}
    {
      params: options.params
      transpile: {}
    }
  )
  umdCoverageOptions = lib.util.extend(
    {}
    {
      params: options.params
      transpile: {
        coffeeCoverage: {}
      }
    }
  )

  lib.gulp
  .src(spec)
  .pipe(lib.pipe.mirror(
    (
      lib.pipe.lazypipe()
      .pipe -> lib.transform.sourceMaps.init()
      .pipe -> pipe.sort()
      .pipe -> lib.pipe.concat(name + '.coffee')
      .pipe -> lib.metadata.data((file) ->
        {
          exports: options.exports ? id
          namespace: options.namespace ? id
          dependencies: options.dependencies ? []
        }
      )
      .pipe -> pipe.lint()
      .pipe -> pipe.umd(umdOptions)
      .pipe -> gulp.dest('dist')
    )()
    (
      lib.pipe.lazypipe()
      .pipe -> lib.transform.sourceMaps.init()
      .pipe -> pipe.sort()
      .pipe -> lib.pipe.concat(name + '.coffee')
      .pipe -> lib.metadata.data((file) ->
        {
          exports: options.exports ? id
          namespace: options.namespace ? id
          dependencies: options.dependencies ? []
        }
      )
      .pipe -> pipe.lint()
      .pipe -> pipe.umd(umdCoverageOptions)
      .pipe -> gulp.dest('dist')
    )()
  ))

  
