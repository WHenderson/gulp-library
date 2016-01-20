lib = require('../lib')
config = require('../config')
path = require('path')
util = require('../util')

global.assert = require('chai').assert

module.exports = util.fnOption(
  {
    fileName: undefined
    name: undefined
    spec: undefined
    globals: {}
    globalsDebug: {}
    saveOnExit: true
  }
  (options) ->
    dirname = path.dirname(options.fileName)
    extname = path.extname(options.fileName)
    basename = path.basename(options.fileName)
    basenameNoextname = basename.slice(0, basename.length - extname.length)

    options.name ?= basenameNoextname
    options.base = dirname

    options.spec ?= '*.{js,coffee}'
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

      fileNames = lib.util.glob.sync(path.join(dirname, basenameNoextname, options.spec), {})
      for fileName in fileNames
        suite(path.relative(options.base, fileName), () ->
          require(fileName)
        )

    )
)