lib = require('../lib')
config = require('../config')
path = require('path')

global.assert = require('chai').assert

module.exports = (options) ->
  options ?= {}
  options.name ?= options.spec ? 'coverage'
  options.spec ?= path.join(options.name, '*.{js,coffee}')
  options.globals = lib.util.extend({}, config.test.globals, options.globals)
  options.globalsDebug = lib.util.extend({}, config.test.globalsDebug, options.globalsDebug)

  suite(options.name, () ->
    setup(() ->
      @timeout(100000)
      debugger
      includes = lib.util.extend({}, options.globals)
      if typeof v8debug == 'object'
        includes = lib.util.extend(includes, options.globalsDebug)

      for own name, filePath of includes
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