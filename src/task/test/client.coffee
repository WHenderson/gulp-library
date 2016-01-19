lib = require('../../lib')
pipe = require('../../pipe')
util = require('../../util')
config = require('../../config')
path = require('path')

module.exports = util.fnOption(
  {
    spec: 'test/*.jade'
    base: 'test'
  }
  (options) ->
    lib.gulp
    .src(options.spec, { base: options.base })
    .pipe(lib.metadata.data((file, cb) ->
      filePaths = lib.util.glob.sync(path.join(path.dirname(file.path), path.basename(file.path).slice(0, -path.extname(file.path).length), '**/*.{js,coffee}'))
      filePaths = filePaths
      .filter((filePath) ->
        extname = path.extname(filePath)
        srcname = filePath.slice(0, filePath.length - extname.length) + '.coffee'

        return extname == '.coffee' or filePaths.indexOf(srcname) == -1
      )
      .map((filePath) ->
        return path.relative('.', filePath)
      )

      lib.gulp
      .src(filePaths, { base: options.base })
      .pipe(pipe.transpile(options.transpile, { coffeeScript: null }))
      .pipe(lib.gulp.dest(config.output.testing))
      .on('end', () ->
        filePaths = filePaths.map((filePath) ->
          # rename file
          filePath = filePath.slice(0, filePath.length - path.extname(filePath).length) + '.js'

          # make relative to html file
          filePath = path.relative(path.dirname(file.path), filePath)

          # replace \ with /

          filePath = filePath.replace(/\\/g, '/')

          return filePath
        )

        bower = path.relative(path.dirname(file.path), path.resolve(__dirname, '../../../bower_components')).replace(/\\/g, '/')

        data = util.mergeOptions(
          {
            config: {
              paths: {
                mocha: bower + '/mocha'
                chai: bower + '/chai'
              }
            }
          }
          {
            config: config
          },
          {
            config: {
              paths: {
                tests: filePaths
              }
            }
          }
        )
        cb(undefined, data)
      )

      return
    ))
    .pipe(pipe.transpile(options.transpile))
    .pipe(lib.gulp.dest(config.output.testing))
)
