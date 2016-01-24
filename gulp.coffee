all = require('./src')

all.config.output.dist = 'lib'

tasks = {
  clean: () ->
    all.task.clean()

  build: () ->
    all.lib.gulp
    .src('src/**/*')
    .pipe(all.pipe.transpile({
      coffeeCoverage: null
      jade: null
      cson: null
    }))
    .pipe(all.lib.gulp.dest('lib'))

  testCoverage: () ->
    all.lib.gulp
    .src('test/coverage.coffee', { read: false })
    .pipe(all.lib.test.mocha({
      debugBrk: false
      r: 'test/coverage-setup.js'
      R: 'spec'
      u: 'tdd'
      istanbul: {}
    }))

  distNpm: all.task.dist.npm()
}

all.task.exportTasks(tasks)
