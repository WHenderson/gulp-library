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

module.exports = (apply, params) ->
  lib.pipe.lazypipe()
  .pipe -> lib.pipe.if(
    '*.coffee'
    (
      lib.pipe.lazypipe()
      .pipe -> lib.pipe.if(apply, lib.metadata.rename({
        suffix: '.apply'
      }))
      .pipe -> lib.pipe.mirror(
        module.exports.coffeeScript()
        (
          lib.pipe.lazypipe()
          .pipe -> transpile()
          .pipe -> module.exports(apply, params)
        )()
        (
          lib.pipe.lazypipe()
          .pipe -> lib.pipe.ignore.exclude(not apply)
          .pipe -> lib.pipe.if(apply, lib.metadata.rename({
            suffix: '.applied'
          }))
          .pipe -> lib.metadata.data((file) ->
            file.data.dependencies = (dep for dep in file.data.dependencies when params.indexOf(dep.param ? dep.name) != -1)
            return file.data
          )
          .pipe -> lib.transform.insert.transform((contents, file) ->
            contents + """

            #{file.data.exports}(#{params.join(', ')})

            """
          )
          .pipe -> module.exports(apply, params)
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

