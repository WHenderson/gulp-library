fs = require('fs')
path = require('path')

module.exports = {
  transpile: require('./transpile')

  umd: {
    templateName: undefined
    templateSource: undefined

    exports: (file) ->
      file.data.exports
    namespace: (file) ->
      file.data.namespace
    dependencies: (file) ->
      file.data.dependencies
  }
  umdTemplates: {
    coffeeScript: fs.readFileSync(path.join(__dirname, 'umd-templates/coffee-script.template')).toString()
  }

}