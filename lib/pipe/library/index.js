var config, formatName, lib, lint, path, sort, umd, util;

lib = require('../../lib');

config = require('../../config');

util = require('../../util');

umd = require('../umd');

sort = require('../sort');

lint = require('../lint');

path = require('path');

formatName = function(name) {
  return name.replace(/-([a-zA-Z0-9])/g, function(match, ch) {
    return ch.toUpperCase();
  }).replace(/\W/g, '');
};

module.exports = util.fnOptionLazyPipe({
  base: void 0,
  name: void 0,
  dependencies: [],
  exports: void 0,
  namespace: void 0,
  isPlugin: void 0,
  umd: {},
  sort: {},
  lint: {}
}, function(options) {
  if (options.base == null) {
    options.base = util.findPackageRoot();
  }
  if (options.name == null) {
    options.name = util.loadPackageJson(options.base).name;
  }
  if (options.exports == null) {
    options.exports = formatName(options.name);
  }
  if (options.namespace == null) {
    options.namespace = options.exports;
  }
  console.assert(!options.isPlugin || ((options.dependencies != null) && options.dependencies.length >= 1), 'Plugins libraries require dependencies');
  return lib.pipe.lazypipe().pipe(function() {
    return sort(options.sort);
  }).pipe(function() {
    return lib.pipe.concat(options.name + ".coffee");
  }).pipe(function() {
    return lib.pipe.through2Map({
      objectMode: true
    }, function(file) {
      file.path = path.join(file.cwd, config.output.base, config.output.dist, path.relative(file.base, file.path));
      file.base = path.join(file.cwd, config.output.base, config.output.dist);
      return file;
    });
  }).pipe(function() {
    return lint(options.lint);
  }).pipe(function() {
    return lib.metadata.data(function(file) {
      if (file.data == null) {
        file.data = {};
      }
      file.data.exports = options.exports;
      file.data.namespace = options.namespace;
      file.data.dependencies = options.dependencies;
      return file.data;
    });
  }).pipe(function() {
    return umd({
      isPlugin: options.isPlugin
    }, options.umd);
  });
});
