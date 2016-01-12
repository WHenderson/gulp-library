lib = require('../../lib')
config = require('../../config')
util = require('../../util')


module.exports = util.lazyTask(
  {
    apply: null
    umdCoffeeScript: {}
    umdNode: {}
    umdWeb: {}
    umdUmd: {}
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(
      config.glob.coffee
      ( # coffee file
        lib.pipe.lazypipe()
        .pipe -> lib.pipe.if(
          options.apply == true
          (
            lib.pipe.lazypipe()
            lib.metadata.rename({
              suffix: '.apply'
            })
          )
        )
        .pipe -> lib.pipe.if(
          options.apply == false
          (
            lib.pipe.lazypipe()
            lib.metadata.rename({
              suffix: '.applied'
            })
            .pipe -> lib.transform.insert.transform((contents, file) ->
              contents + """
              #{file.data.exports}(#{options.params.join(', ')})
              """
            )
          )
        )
        .pipe -> lib.pipe.mirror(
          module.exports.umdCoffeeScript(options.umdCoffeeScript)
          module.exports(lib.util.extend(options, { apply: null }))
        )
      )
      ( # non coffee file
        module.exports.umdNode(options.umdNode)
        module.exports.umdWeb(options.umdWeb)
        module.exports.umdUmd(options.umdUmd)
      )
    )
)

module.exports.umdCoffeeScript = util.lazyTask(
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
        %>
        <%= contents %>
        module.exports = <%= exports %>
        '''
    }
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.transform.umd(options.umd)
)


module.exports.umdNode = util.lazyTask(
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

module.exports.umdWeb = util.lazyTask(
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

module.exports.umdUmd = util.lazyTask(
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
