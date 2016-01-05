all = require('./src')

all.config.output.dist = 'lib'
all.pipe.transpile.cson = false

tasks = {
  clean: () ->
    all.task.clean()

  transpile: () ->
    all.lib.gulp
    .src('src/**/*')
    .pipe(all.pipe.transpile())
    .pipe(all.lib.gulp.dest(all.config.output.dist))

  testCoverage: () ->
    all.task.test.coverage()

  testExamples: () ->
    all.task.test.examples()

}

all.task.tasks(tasks)
