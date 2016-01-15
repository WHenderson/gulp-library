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
}

all.task.exportTasks(tasks)
