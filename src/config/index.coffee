module.exports = {
  output: {
    dist: 'dist'
    coverage: 'coverage'
  }
  test: require('./test')
  lint: require('./lint')
  transform: require('./transform')
}