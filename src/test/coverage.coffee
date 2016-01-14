lib = require('../lib')
config = require('../config')
path = require('path')
util = require('../util')

global.assert = require('chai').assert

module.exports = util.fnOption(
  {
    name: 'coverage'
    spec: undefined
    globals: config.globals
    globalsDebug: config.globalsDebug
  }
  (options) ->
    options.spec ?= path.join(options.name, '*.{js,coffee}')

    suite(options.name, () ->
      setup(() ->
        @timeout(25*1000)
        globals = lib.util.extend({}, options.globals)
        if typeof v8debug == 'object'
          globals = lib.util.extend(globals, options.globalsDebug)

        for own name, filePath of globals
          if not filePath?
            continue
          if (filePath[0] == '.')
            global[name] = require(path.join(options.base, filePath))
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