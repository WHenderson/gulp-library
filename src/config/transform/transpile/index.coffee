fs = require('fs')
path = require('path')

module.exports = {
  coffeeScript: {
    bare: true
  }
  jade: {
    pretty: true
    data: {
      jadeMochaTemplate: path.join(__dirname, '../../task/test/templates/mocha.jade')
    }
  }
  cson: {

  }
}