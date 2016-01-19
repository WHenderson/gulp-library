lib = require('../lib')
config = require('../config')
path = require('path')
util = require('../util')

global.assert = require('chai').assert

module.exports = util.fnOption(
  {
    name: 'coverage'
    spec: undefined
    globals: {}
    globalsDebug: {}
    base: undefined
    saveOnExit: true
  }
  (options) ->
    options.spec ?= path.join(options.name, '*.{js,coffee}')
    packageRoot = util.findPackageRoot(options.base)

    if options.saveOnExit
      require('./common/save-coverage').register(options.name)

    suite(options.name, () ->
      setup(() ->
        @timeout(25*1000)

        isDebugging = typeof v8debug == 'object'

        globals = util.mergeOptions(
          config.globals,
          options.globals
          if isDebugging then config.globalsDebug
          if isDebugging then options.globalsDebug
        )

        for own name, filePath of globals
          if not filePath?
            continue
          if (filePath[0] == '.')
            global[name] = require(path.join(packageRoot, filePath))
          else
            global[name] = require(filePath)

        return
      )

      fileNames = lib.util.glob.sync(path.join(options.base, options.spec), {})
      for fileName in fileNames
        suite(path.relative(options.base, fileName), () ->
          require(fileName)
        )

    )
)