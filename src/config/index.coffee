extend = require('extend')
config = require('./library.config.coffee')
cson = require('cson')
coffeeScript = require('coffee-script')
path = require('path')
fs = require('fs')

override = do ->
  findPackageRoot = require('../util/find-package-root')
  root = findPackageRoot()

  exists = (fn) ->
    try
      fs.statSync(fn)
      return true
    catch ex
      if ex.code == 'ENOENT'
        return false
      throw ex

  if exists(path.join(root, 'library.config.coffee'))
    # note that coffee-script must have been registered for this to work
    try
      global.config = config
      return require(path.join(root, 'library.config.coffee'))
    finally
      delete global.config
  else if exists(path.join(root, 'library.config.cson'))
    return cson.parse(fs.readFileSync(path.join(root, 'library.config.cson'), 'utf8'))
  else if exists(path.join(root, 'library.config.json'))
    return JSON.parse(fs.readFileSync(path.join(root, 'library.config.json'), 'utf8'))
  else
    return {}

module.exports = extend(true, config, override)



