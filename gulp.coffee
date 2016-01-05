all = require('./src')

all.config.output.dist = 'lib'
all.task.transpile.cson = false

tasks = {
  clean: () ->
    all.task.clean()

  transpile: () ->
    all.lib.gulp
    .src('src/**/*')
    .pipe(all.task.transpile())
    .pipe(all.lib.gulp.dest(all.config.output.dist))

  testCoverage: () ->
    all.task.test.coverage()

  testExamples: () ->
    all.task.test.examples()

}

all.task.tasks(tasks)
