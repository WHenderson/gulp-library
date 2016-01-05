module.exports = {
  output: {
    dist: 'dist'
    coverage: 'coverage'
  }
  lint: require('./lint')
  transform: require('./transform')
}