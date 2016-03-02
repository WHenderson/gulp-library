var config, lib, path, util,
  hasProp = {}.hasOwnProperty;

lib = require('../lib');

config = require('../config');

path = require('path');

util = require('../util');

global.assert = require('chai').assert;

module.exports = util.fnOption({
  fileName: void 0,
  name: void 0,
  spec: void 0,
  globals: {},
  globalsDebug: {},
  saveOnExit: true
}, function(options) {
  var basename, basenameNoextname, dirname, extname, packageRoot;
  dirname = path.dirname(options.fileName);
  extname = path.extname(options.fileName);
  basename = path.basename(options.fileName);
  basenameNoextname = basename.slice(0, basename.length - extname.length);
  if (options.name == null) {
    options.name = basenameNoextname;
  }
  options.base = dirname;
  if (options.spec == null) {
    options.spec = '*.{js,coffee}';
  }
  packageRoot = util.findPackageRoot(options.base);
  if (options.saveOnExit) {
    require('./common/save-coverage').register(options.name);
  }
  return suite(options.name, function() {
    var fileName, fileNames, i, len, results;
    setup(function() {
      var filePath, globals, isDebugging, name;
      this.timeout(25 * 1000);
      isDebugging = typeof v8debug === 'object';
      globals = util.mergeOptions(config.nodeGlobals, options.globals, isDebugging ? config.nodeGlobalsDebug : void 0, isDebugging ? options.globalsDebug : void 0);
      for (name in globals) {
        if (!hasProp.call(globals, name)) continue;
        filePath = globals[name];
        if (filePath == null) {
          continue;
        }
        if (filePath[0] === '.') {
          global[name] = require(path.join(packageRoot, filePath));
        } else {
          global[name] = require(filePath);
        }
      }
    });
    fileNames = lib.util.glob.sync(path.join(dirname, basenameNoextname, options.spec), {});
    results = [];
    for (i = 0, len = fileNames.length; i < len; i++) {
      fileName = fileNames[i];
      results.push(suite(path.relative(options.base, fileName), function() {
        return require(fileName);
      }));
    }
    return results;
  });
});
