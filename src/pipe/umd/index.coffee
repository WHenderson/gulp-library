lib = require('../../lib')
config = require('../../config')
transpile = require('../transpile')

umdCoffeeScript = lib.pipe.lazypipe()
.pipe -> lib.transform.umd(lib.util.extend({}, config.transform.umd, {
  templateSource: config.transpile.umdTemplates.coffeeScript
}))

umdNode = lib.pipe.lazypipe()
.pipe -> lib.transform.umd(lib.util.extend({}, config.transform.umd, {
  templateName: 'node'
}))
.pipe -> lib.metadata.rename({
  suffix: '.node'
})

umdWeb = lib.pipe.lazypipe()
.pipe -> lib.transform.umd(lib.util.extend({}, config.transform.umd, {
  templateName: 'amdWeb'
}))
.pipe -> lib.metadata.rename({
  suffix: '.web'
})

umdUmd = lib.pipe.lazypipe()
.pipe -> lib.transform.umd(lib.util.extend({}, config.transform.umd, {
  templateName: 'amdNodeWeb'
}))
.pipe -> lib.metadata.rename({
  suffix: '.umd'
})

module.exports = (options) ->
  options ?= {}

  lib.pipe.lazypipe()
  .pipe -> lib.pipe.if(
    '*.coffee'
    (
      lib.pipe.lazypipe()
      .pipe -> lib.pipe.if(options.params?, lib.metadata.rename({
        suffix: '.apply'
      }))
      .pipe -> lib.pipe.mirror(
        module.exports.coffeeScript()
        (
          lib.pipe.lazypipe()
          .pipe -> transpile(options.transpile)
          .pipe -> module.exports(options.params)
        )()
        (
          lib.pipe.lazypipe()
          .pipe -> lib.pipe.ignore.exclude(not options.params?)
          .pipe -> lib.pipe.if(options.params?, lib.metadata.rename({
            suffix: '.applied'
          }))
          .pipe -> lib.transform.insert.transform((contents, file) ->
            contents + """

            #{file.data.exports}(#{options.params.join(', ')})

            """
          )
          .pipe -> lib.metadata.data((file) ->
            #file.data.dependencies = (dep for dep in file.data.dependencies when options.params.indexOf(dep.param ? dep.name) != -1)
            file.data.namespace = file.data.exports = options.params[0]
            return file.data
          )
          .pipe -> module.exports()
        )()
      )
    )()
    lib.pipe.mirror(
      module.exports.node()
      module.exports.web()
      module.exports.umd()
    )
  )

module.exports.coffeeScript = umdCoffeeScript
module.exports.node = umdNode
module.exports.web = umdWeb
module.exports.umd = umdUmd

