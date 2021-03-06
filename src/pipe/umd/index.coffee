lib = require('../../lib')
config = require('../../config')
util = require('../../util')
transpile = require('../transpile')


module.exports = util.fnOptionLazyPipe(
  {
    isPlugin: false
    umd: {}
    umdCoffeeScript: {}
    umdNode: {}
    umdWeb: {}
    umdUmd: {}
    transpile: {}
    uglify: {
      preserveComments: 'some'
    }
  }
  (options) ->
    umd = () ->
      lib.pipe.mirror(
        module.exports.umdNode(options.umd, options.umdNode)
        module.exports.umdWeb(options.umd, options.umdWeb)
        module.exports.umdUmd(options.umd, options.umdUmd)
      )

    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(
      config.glob.coffeeScript
      (
        lib.pipe.lazypipe()
        .pipe -> lib.pipe.if(
          options.isPlugin
          lib.pipe.mirror(
            (
              lib.pipe.lazypipe()
              .pipe -> lib.metadata.rename({
                suffix: '.apply'
              })
              .pipe -> lib.metadata.data((file) ->
                file.data.dependencies.shift()
                return file.data
              )
            )()
            (
              lib.pipe.lazypipe()
              .pipe -> lib.metadata.rename({
                suffix: '.applied'
              })
              .pipe -> lib.metadata.data((file) ->
                dependency = file.data.dependencies[0]
                paramName = dependency.param ? dependency.name
                file.data.exports = "#{file.data.exports}(#{paramName})"
                file.data.namespace = paramName
                return file.data
              )
            )()
          )
        )
        .pipe -> lib.pipe.mirror(
          lib.util.gutil.noop()
          (
            lib.pipe.lazypipe()
            .pipe -> lib.metadata.rename({
              suffix: '.node'
            })
            .pipe -> module.exports.umdCoffeeScript(options.umd, options.umdCoffeeScript)
          )()
          (
            lib.pipe.lazypipe()
            .pipe -> transpile(options.transpile, { coffeeCoverage: null })
            .pipe -> umd()
          )()
          (
            lib.pipe.lazypipe()
            .pipe -> transpile(options.transpile, { coffeeScript: null })
            .pipe -> lib.metadata.rename({
              suffix: '.coverage'
            })
            .pipe -> lib.metadata.data((file) ->
              file.data.node = true
              return file.data
            )
            .pipe -> umd()

          )()
        )
      )()
      umd()
    )
    .pipe -> lib.pipe.if(
      config.glob.javaScript,
      lib.pipe.mirror(
        lib.util.gutil.noop()
        (
          lib.pipe.lazypipe()
          .pipe -> lib.pipe.ignore((file) -> file.data.node == true)
          .pipe -> lib.transform.uglify(options.uglify)
          .pipe -> lib.metadata.rename((pathBits) ->
            pathBits.extname = '.min' + pathBits.extname
            return
          )
        )()
      )
    )
)

module.exports.umdCoffeeScript = util.fnOptionLazyPipe(
  {
    umd: config.umd
  }
  {
    umd: {
      templateSource: '''
        <%
          for (var i = 0; i != dependencies.length; ++i) {
            %><%= dependencies[i].param %> = require('<%= dependencies[i].cjs || dependencies[i].name %>')
        <%
          }
        %><%= contents %>
        module.exports = <%= exports %>
        '''
    }
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.transform.umd(options.umd)
)


module.exports.umdNode = util.fnOptionLazyPipe(
  {
    umd: config.umd
  }
  {
    umd: {
      templateName: 'node'
    }
    rename: {
      suffix: '.node'
    }
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.transform.umd(options.umd)
    .pipe -> lib.metadata.rename(options.rename)
)

module.exports.umdWeb = util.fnOptionLazyPipe(
  {
    umd: config.umd
  }
  {
    umd: {
      templateName: 'amdWeb'
    }
    rename: {
      suffix: '.web'
    }
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.transform.umd(options.umd)
    .pipe -> lib.metadata.rename(options.rename)
)

module.exports.umdUmd = util.fnOptionLazyPipe(
  {
    umd: config.umd
  }
  {
    umd: {
      templateName: 'amdNodeWeb'
    }
    rename: {
      suffix: '.umd'
    }
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.transform.umd(options.umd)
    .pipe -> lib.metadata.rename(options.rename)
)
