all = require('./src')

all.config.output.dist = 'lib'

tasks = {
  clean: () ->
    all.task.clean()
}

all.task.exportTasks(tasks)
