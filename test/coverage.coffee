require('../index').test.coverage({
  globals: {
    library: '../build/coverage'
  }
  base: __dirname
})
