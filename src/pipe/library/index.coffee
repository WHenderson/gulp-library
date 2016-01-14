lib = require('../../lib')
config = require('../../config')
util = require('../../util')
umd = require('../umd')
sort = require('../sort')

formatName = (name) ->
  name.replace(/-([a-zA-Z0-9])/g, (match, ch) -> ch.toUpperCase()).replace(/\W/g, '')

module.exports = util.fnOptionLazyPipe(
  {
    name: undefined
    dependencies: []
    exports: undefined
    namespace: undefined
    isPlugin: undefined
    umd: {}
    sort: {}
  }
  (options) ->
    name ?= util.loadPackageJson().name
    options.exports ?= formatName(name)
    options.namespace ?= options.exports

    return lib.pipe.lazypipe()
    .pipe -> sort(options.sort)
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