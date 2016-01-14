fs = require('fs')
path = require('path')

module.exports = (base = __dirname, name = 'package.json') ->
  while true
    if fs.existsSync(path.join(base, name))
      return base

    next = path.resolve(base, '..')
    if next == base
      return undefined
    base = next