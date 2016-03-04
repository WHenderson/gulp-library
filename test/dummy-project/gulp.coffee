require('../../src/task/defaults')
.options({
  buildLibrary: {
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
})
.export()
