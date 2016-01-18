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
      console.log('collecting coverage...', path.resolve(config.output.base, config.output.coverage, 'parts', '*.json'))
      combine = (done) ->
        console.log('combining?', path.resolve(config.output.base, config.output.coverage, 'parts', '*.json'))
        lib.gulp
        .src(path.join(config.output.base, config.output.coverage, 'parts', '*.json'))
        .pipe(lib.debug.debug({ title: 'coverage files' }))
        .pipe(combineCoverage(options.combineCoverage))
        .pipe(lib.debug.debug({ title: 'coverage' }))
        .pipe(lib.gulp.dest(path.join(config.output.base, config.output.coverage)))
        .pipe(lib.test.istanbulReport(options.istanbulReport))
        .on('end', () ->
          console.log('end stream')
          done()
        )
        return

      deasync(combine)()

      console.log('done collecting?')
    ).resume()

    lib.pipe.lazypipe()
    .pipe -> collect
)