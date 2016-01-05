path = require('path')

module.exports = {
  globals: {
  }
  globalsDebug: {
  }

  mocha: {
    debugBrk: false
    r: path.join(__dirname, '../../task/test/setup/coverage-setup.js')
    R: 'spec'
    u: 'tdd'
    istanbul: {
    }
  }
}