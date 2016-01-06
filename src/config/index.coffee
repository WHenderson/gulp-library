module.exports = {
  output: {
    dist: 'dist'
    coverage: 'coverage'
    build: 'build'
  }
  test: require('./test')
  lint: require('./lint')
  transform: require('./transform')
}