lib = require('../lib')
config = require('../config')
path = require('path')

module.exports = (base, spec, name) ->
  if not name?
    name = spec ? 'coverage'
    spec ?= path.join(name, '*.{js,coffee}')

  suite(name, () ->
    setup(() ->
      @timeout(10000)

      includes = lib.util.extend({}, config.test.globals)
      if typeof v8debug == 'object'
        includes = lib.util.extend(includes, config.test.globalsDebug)

      for own name, filePath of includes
        if (filePath[0] == '.')
          global[name] = require(path.join(__dirname, '../', filePath))
        else
          global[name] = require(filePath)

      return
    )

    fileNames = lib.util.glob.sync(path.join(base, spec), {})
    for fileName in fileNames
      console.log(fileName)
      suite(path.relative(base, fileName), () ->
        require(fileName)
      )

  )