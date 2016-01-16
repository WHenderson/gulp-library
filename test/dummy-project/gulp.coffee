all = require('../../src')

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
