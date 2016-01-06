fs = require('fs')
path = require('path')

module.exports = (name='package.json') ->
  return JSON.parse(fs.readFileSync(name, 'utf8'))
