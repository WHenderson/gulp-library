lib = require('../../lib')
config = require('../../config')
util = require('../../util')
umd = require('../umd')
sort = require('../sort')
lint = require('../lint')

formatName = (name) ->
  name.replace(/-([a-zA-Z0-9])/g, (match, ch) -> ch.toUpperCase()).replace(/\W/g, '')

module.exports = util.fnOptionLazyPipe(
  {
    base: undefined
    name: undefined
    dependencies: []
    exports: undefined
    namespace: undefined
    isPlugin: undefined
    umd: {}
    sort: {}
    lint: {}
  }
  (options) ->
    options.base ?= util.findPackageRoot()
    options.name ?= util.loadPackageJson(options.base).name
    options.exports ?= formatName(options.name)
    options.namespace ?= options.exports

    return lib.pipe.lazypipe()
    .pipe -> sort(options.sort)
    .pipe -> lib.pipe.concat("#{options.name}.coffee")
    .pipe -> lint(options.lint)
    .pipe -> lib.metadata.data((file) ->
      file.data ?= {}
      file.data.exports = options.exports
      file.data.namespace = options.namespace
      file.data.dependencies = options.dependencies
      return file.data
    )
    .pipe -> umd({ isPlugin: options.isPlugin }, options.umd)
)