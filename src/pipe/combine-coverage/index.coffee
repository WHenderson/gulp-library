lib = require('../../lib')
util = require('../../util')

fs = require('fs')
path = require('path')

Report = require('istanbul').Report
Collector = require('istanbul').Collector

module.exports = util.fnOptionLazyPipe(
  {
    base: undefined
    cwd: undefined
    path: 'coverage.json'
  }
  (options) ->

    collector = new Collector()

    captureFile = (file, enc, cb) ->
      if file.isNull()
        cb()
        return

      if file.isStream()
        @emit('error', new lub.util.gutil.PluginError('coverage', 'Streaming not supported'))
        cb()
        return

      coverage = JSON.parse(file.contents.toString())
      collector.add(coverage)

      cb()
      return

    captureFinish = (cb) ->
      coverage = collector.getFinalCoverage()

      file = new lib.util.gutil.File({
        cwd: options.cwd
        base: options.base
        path: options.path
        contents: new Buffer(JSON.stringify(coverage))
      })

      @push(file)
      cb()

    lib.pipe.lazypipe()
    .pipe -> lib.pipe.through2.obj(captureFile, captureFinish)
)
