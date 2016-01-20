require('../../../src').test.node({
  fileName: __filename
  globals: {
    dummyProject: './dist/dummy-project.coverage.node.js'
  }
})