lib = require('../../lib')
pipeDone = require('../done')
config = require('../../config')
util = require('../../util')
combineCoverage = require('../combine-coverage')

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

    lib.pipe.lazypipe()
    .pipe -> pipeDone((done) ->
      lib.gulp
      .src(path.join(config.output.base, config.output.node, 'parts', '*.json'))
      .pipe(combineCoverage(options.combineCoverage))
      .pipe(lib.gulp.dest(path.join(config.output.base, config.output.node)))
      .pipe(lib.test.istanbulReport(options.istanbulReport))
      .pipe(all.pipe.done.sync(() ->
        done()
      ))
      return
    )
)