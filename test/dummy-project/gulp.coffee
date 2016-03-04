tasks = require('../../src/task/defaults')

tasks._buildLibraryOptions = {
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
}
tasks.export()

###
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

  testNode: () ->
    all.task.test.node()

  testClient: () ->
    all.task.test.client()

  testExamples: () ->
    all.task.test.examples()
}

all.task.exportTasks(tasks)
###