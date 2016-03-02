module.exports = {
  lint: require('./lint'),
  transpile: require('./transpile'),
  umd: require('./umd'),
  sort: require('./sort'),
  coffeeCoverage: require('./coffee-coverage'),
  combineCoverage: require('./combine-coverage'),
  collectCoverage: require('./collect-coverage'),
  library: require('./library'),
  done: require('./done')
};
