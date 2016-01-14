lib = require('../../lib')
config = require('../../config')
util = require('../../util')
umd = require('../umd')

formatName = (name) ->
  name.replace(/-(.)/, (match, x) -> x.toUpperCase())

module.exports = util.lazyTask(
  {
    name: undefined
    dependencies: []
    exports: undefined
    namespace: undefined
    isPlugin: undefined
    umd: {}
  }
  (options) ->
    name ?= util.loadPackageJson().name
    options.exports ?= formatName(name)
    options.namespace ?= options.exports

    return lib.pipe.lazypipe()
    .pipe -> lib.pipe.concat("#{name}.coffee")
    .pipe -> lib.metadata.data((file) ->
      file.data ?= {}
      file.data.exports = options.exports
      file.data.namespace = options.namespace
      file.data.dependencies = options.dependencies
      return file.data
    )
    .pipe -> umd({ isPlugin: options.isPlugin }, options.umd)
)