gulp = require('gulp')
all = require('gulp-library')

tasks = {
  clean: () ->
    all.task.clean()

  build: () ->
    all.task.library({
      library: {
        isPlugin: true
        dependencies: [
          {
            param: 'ko'
            name: 'knockout'
          }
          {
            param: 'isAn'
            name: 'is-an'
          }
        ]
      }
    })
}

all.task.exportTasks(tasks)
