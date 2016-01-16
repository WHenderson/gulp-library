cson = require('cson')
path = require('path')

module.exports = {
  output: {
    dist: 'dist'
    build: 'build'
    coverage: 'coverage'
    base: ''
  }

  glob: {
    coffeeScript: '*.coffee'
    jade: '*.jade'
    javaScript: '*.js'
    cson: '*.cson'
  }

  globals: {
  }
  nodeGlobals: {
  }
  webGlobals: {
  }

  globalsDebug: {
  }
  nodeGlobalsDebug: {
  }
  webGlobalsDebug: {
  }

  mocha: {
    debugBrk: false
    R: 'spec'
    u: 'tdd'
    istanbul: false
  }

  lintCoffeeScript: cson.load(path.join(__dirname, './coffee-script.cson'))

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

  coffeeScript: {
    bare: true
  }

  coffeeCoverage: {
    instrumentor: 'istanbul'
  }

  jade: {
    pretty: true
    data: {
      jadeMochaTemplate: path.join(__dirname, '../../task/test/templates/mocha.jade')
    }
  }

  cson: {

  }
}

# /dist/package-name.apply.*
# /dist/package-name.applied.*
# /dist/package-name.coverage.*
# /test/node/**/*.{coffee,js}
# /test/web/name/index.{jade|html}
# /test/web/name/**/*.[coffee,js}

# built tests...

# /build/web/...
