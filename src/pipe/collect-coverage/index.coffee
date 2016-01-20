lib = require('../../lib')
config = require('../../config')
util = require('../../util')
combineCoverage = require('../combine-coverage')

deasync = require('deasync')
path = require('path')

module.exports = util.fnOptionLazyPipe(
  {
    istanbulReport: {
      reporters: [
        'text-summary' # outputs summary to stdout, uses default options
        'lcov'
        'text'
        'json'
      ]
    }
  }
  (options) ->

    collect = lib.pipe.through()

    collect.on('end', () ->
      combine = (done) ->
        lib.gulp
        .src(path.join(config.output.base, config.output.node, 'parts', '*.json'))
        .pipe(combineCoverage(options.combineCoverage))
        .pipe(lib.gulp.dest(path.join(config.output.base, config.output.node)))
        .pipe(lib.test.istanbulReport(options.istanbulReport))
        .on('end', () ->
          console.log('end stream')
          done()
        )
        return

      deasync(combine)()
    ).resume()

    lib.pipe.lazypipe()
    .pipe -> collect
)