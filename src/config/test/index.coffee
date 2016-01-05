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

}