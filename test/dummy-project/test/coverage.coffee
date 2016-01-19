require('../../../src').test.coverage({
  base: __dirname
  globals: {
    dummyProject: './dist/dummy-project.coverage.node.js'
  }
})