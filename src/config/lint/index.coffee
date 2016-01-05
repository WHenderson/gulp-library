cson = require('cson')
path = require('path')

module.exports = {
  coffeeScript: cson.load(path.join(__dirname, './coffee-script.cson'))
}