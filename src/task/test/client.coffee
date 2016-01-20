lib = require('../../lib')
pipe = require('../../pipe')
util = require('../../util')
config = require('../../config')
path = require('path')

module.exports = util.fnOption(
  {
    spec: 'test/*.jade'
    base: 'test'
    globals: {}
  }
  (options) ->
    lib.gulp
    .src(options.spec, { base: options.base })
    .pipe(lib.metadata.data((file, cb) ->
      dirname = path.dirname(file.path)
      extname = path.extname(file.path)
      basename = path.basename(file.path)
      basenameNoextname = basename.slice(0, basename.length - extname.length)

      filePaths = []

      lib.gulp
      .src(path.join(dirname, basenameNoextname, '**/*'), { base: options.base })
      .pipe(lib.pipe.sort())
      .pipe(lib.pipe.mirror(
        lib.util.gutil.noop()
        pipe.transpile(options.transpile, { coffeeCoverage: null })
      ))
      .pipe(lib.pipe.if(config.glob.javaScript, lib.pipe.through2Map.obj((file) ->
        filePaths.push(file.path)
        return file
      )))
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
              webGlobals: options.globals
            }
          }
        )
        console.log('options:', options)
        console.log('data   :', data)

        cb(undefined, data)
      )

      return
    ))
    .pipe(pipe.transpile(options.transpile))
    .pipe(lib.gulp.dest(config.output.testing))
)
