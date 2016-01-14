path = require('path')
lib = require('../lib')

module.exports = util.fnOption(
  {
    spec: undefined
    name: 'examples'
    base: undefined
  }
  (options) ->
    options.base ?= util.findPackageRoot()
    options.spec ?= path.join(options.base, options.name, '**/*.{js,coffee}')

    fileNames = lib.util.glob.sync(options.spec, {})

    isRedundant = (fileName) ->
      ext = path.extname(fileName)
      coffeeName = fileName.slice(0, fileName.length - ext.length) + '.coffee'
      if ext == '.js' and fileNames.indexOf(coffeeName) != -1
        return true
      return false

    suite(name, () ->
      for fileName in fileNames when not isRedundant(fileName)
        test(path.relative(options.base, fileName), () ->
          require(fileName)
        )
    )
)
