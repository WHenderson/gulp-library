path = require('path')

module.exports = {
  globals: {
  }
  globalsDebug: {
  }

  mocha: {
    debugBrk: false
    R: 'spec'
    u: 'tdd'
    istanbul: false
  }

  mochaCoverage: {
    r: path.join(__dirname, '../../task/test/setup/coverage-setup.js')
    istanbul: {}
  }

  mochaExamples: {
    r: path.join(__dirname, '../../task/test/setup/examples-setup.js')
    istanbul: false
  }

  bowerPhantomJs: {
    name: 'test-phantomjs'
    dependencies: {
      mocha: "~2.3.4"
      chai: "~3.4.2"
    }
  }
}