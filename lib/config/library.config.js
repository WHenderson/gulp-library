var cson, path;

cson = require('cson');

path = require('path');

module.exports = {
  output: {
    dist: 'dist',
    build: 'build',
    testing: 'testing',
    coverage: 'coverage',
    base: ''
  },
  glob: {
    coffeeScript: '*.coffee',
    jade: '*.jade',
    javaScript: '*.js',
    cson: '*.cson'
  },
  nodeGlobals: {},
  nodeGlobalsDebug: {},
  webGlobals: {},
  mocha: {
    debugBrk: false,
    R: 'spec',
    u: 'tdd',
    istanbul: false
  },
  istanbulConfig: {
    verbose: true,
    instrumentation: {
      variable: '_$istanbul'
    }
  },
  lintCoffeeScript: cson.load(path.join(__dirname, './coffee-script.cson')),
  umd: {
    templateName: void 0,
    templateSource: void 0,
    exports: function(file) {
      return file.data.exports;
    },
    namespace: function(file) {
      return file.data.namespace;
    },
    dependencies: function(file) {
      return file.data.dependencies;
    }
  },
  coffeeScript: {
    bare: true
  },
  coffeeCoverage: {
    instrumentor: 'istanbul',
    coverageVar: '_$istanbul'
  },
  jade: {
    pretty: true,
    data: {
      jadeMochaTemplate: path.join(__dirname, '../../task/test/templates/mocha.jade')
    }
  },
  cson: {}
};
