lib = require('../../lib')
config = require('../../config')
util = require('../../util')
umd = require('../umd')
sort = require('../sort')
lint = require('../lint')
path = require('path')

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

    console.assert(not options.isPlugin or (options.dependencies? and options.dependencies.length >= 1), 'Plugins libraries require dependencies')

    return lib.pipe.lazypipe()
    .pipe -> sort(options.sort)
    .pipe -> lib.pipe.concat("#{options.name}.coffee")
    .pipe -> lib.pipe.through2Map(
      {
        objectMode: true
      }
      (file) ->
        file.path = path.join(file.cwd, config.output.base, config.output.dist, path.relative(file.base, file.path))
        file.base = path.join(file.cwd, config.output.base, config.output.dist)
        return file
    )
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