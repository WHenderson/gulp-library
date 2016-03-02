var config, lib, transpile, util;

lib = require('../../lib');

config = require('../../config');

util = require('../../util');

transpile = require('../transpile');

module.exports = util.fnOptionLazyPipe({
  isPlugin: false,
  umd: {},
  umdCoffeeScript: {},
  umdNode: {},
  umdWeb: {},
  umdUmd: {},
  transpile: {},
  uglify: {
    preserveComments: 'some'
  }
}, function(options) {
  var umd;
  umd = function() {
    return lib.pipe.mirror(module.exports.umdNode(options.umd, options.umdNode), module.exports.umdWeb(options.umd, options.umdWeb), module.exports.umdUmd(options.umd, options.umdUmd));
  };
  return lib.pipe.lazypipe().pipe(function() {
    return lib.pipe["if"](config.glob.coffeeScript, (lib.pipe.lazypipe().pipe(function() {
      return lib.pipe["if"](options.isPlugin, lib.pipe.mirror((lib.pipe.lazypipe().pipe(function() {
        return lib.metadata.rename({
          suffix: '.apply'
        });
      }).pipe(function() {
        return lib.metadata.data(function(file) {
          file.data.dependencies.shift();
          return file.data;
        });
      }))(), (lib.pipe.lazypipe().pipe(function() {
        return lib.metadata.rename({
          suffix: '.applied'
        });
      }).pipe(function() {
        return lib.metadata.data(function(file) {
          var dependency, paramName, ref;
          dependency = file.data.dependencies[0];
          paramName = (ref = dependency.param) != null ? ref : dependency.name;
          file.data.exports = file.data.exports + "(" + paramName + ")";
          file.data.namespace = paramName;
          return file.data;
        });
      }))()));
    }).pipe(function() {
      return lib.pipe.mirror(lib.util.gutil.noop(), (lib.pipe.lazypipe().pipe(function() {
        return lib.metadata.rename({
          suffix: '.node'
        });
      }).pipe(function() {
        return module.exports.umdCoffeeScript(options.umd, options.umdCoffeeScript);
      }))(), (lib.pipe.lazypipe().pipe(function() {
        return transpile(options.transpile, {
          coffeeCoverage: null
        });
      }).pipe(function() {
        return umd();
      }))(), (lib.pipe.lazypipe().pipe(function() {
        return transpile(options.transpile, {
          coffeeScript: null
        });
      }).pipe(function() {
        return lib.metadata.rename({
          suffix: '.coverage'
        });
      }).pipe(function() {
        return lib.metadata.data(function(file) {
          file.data.node = true;
          return file.data;
        });
      }).pipe(function() {
        return umd();
      }))());
    }))(), umd());
  }).pipe(function() {
    return lib.pipe["if"](config.glob.javaScript, lib.pipe.mirror(lib.util.gutil.noop(), (lib.pipe.lazypipe().pipe(function() {
      return lib.pipe.ignore(function(file) {
        return file.data.node === true;
      });
    }).pipe(function() {
      return lib.transform.uglify(options.uglify);
    }).pipe(function() {
      return lib.metadata.rename(function(pathBits) {
        pathBits.extname = '.min' + pathBits.extname;
      });
    }))()));
  });
});

module.exports.umdCoffeeScript = util.fnOptionLazyPipe({
  umd: config.umd
}, {
  umd: {
    templateSource: '<%\n  for (var i = 0; i != dependencies.length; ++i) {\n    %><%= dependencies[i].param %> = require(\'<%= dependencies[i].cjs || dependencies[i].name %>\')\n<%\n  }\n%><%= contents %>\nmodule.exports = <%= exports %>'
  }
}, function(options) {
  return lib.pipe.lazypipe().pipe(function() {
    return lib.transform.umd(options.umd);
  });
});

module.exports.umdNode = util.fnOptionLazyPipe({
  umd: config.umd
}, {
  umd: {
    templateName: 'node'
  },
  rename: {
    suffix: '.node'
  }
}, function(options) {
  return lib.pipe.lazypipe().pipe(function() {
    return lib.transform.umd(options.umd);
  }).pipe(function() {
    return lib.metadata.rename(options.rename);
  });
});

module.exports.umdWeb = util.fnOptionLazyPipe({
  umd: config.umd
}, {
  umd: {
    templateName: 'amdWeb'
  },
  rename: {
    suffix: '.web'
  }
}, function(options) {
  return lib.pipe.lazypipe().pipe(function() {
    return lib.transform.umd(options.umd);
  }).pipe(function() {
    return lib.metadata.rename(options.rename);
  });
});

module.exports.umdUmd = util.fnOptionLazyPipe({
  umd: config.umd
}, {
  umd: {
    templateName: 'amdNodeWeb'
  },
  rename: {
    suffix: '.umd'
  }
}, function(options) {
  return lib.pipe.lazypipe().pipe(function() {
    return lib.transform.umd(options.umd);
  }).pipe(function() {
    return lib.metadata.rename(options.rename);
  });
});
