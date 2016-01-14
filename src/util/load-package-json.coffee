fs = require('fs')
path = require('path')

findPackageRoot = require('./find-package-root')

module.exports = (base = __dirname, name = 'package.json') ->
  return JSON.parse(fs.readFileSync(path.join(findPackageRoot(base, name), name), 'utf8'))
