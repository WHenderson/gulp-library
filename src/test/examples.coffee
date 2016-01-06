path = require('path')
lib = require('../lib')

module.exports = (base, spec, name) ->
  if not name?
    name = spec ? 'examples'
    spec ?= path.join('../', name, '**/*.{js,coffee}')

  fileNames = lib.util.glob.sync(path.join(base, spec), {})

  isRedundant = (fileName) ->
    ext = path.extname(fileName)
    coffeeName = fileName.slice(fileName.length = ext.length) + '.coffee'
    if ext == '.js' and fileNames.indexOf(coffeeName) != -1
      return true
    return false

  suite(name, () ->
    for fileName in fileNames when not isRedundant(fileName)
      test(path.relative(base, fileName), () ->
        require(fileName)
      )
  )

