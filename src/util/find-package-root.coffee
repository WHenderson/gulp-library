fs = require('fs')
path = require('path')
process = require('process')

module.exports = (base, name = 'package.json') ->
  base ?= process.cwd()
  while true
    if fs.existsSync(path.join(base, name))
      return base

    next = path.resolve(base, '..')
    if next == base
      return undefined
    base = next