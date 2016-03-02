var config, lib, path, pipe, util;

lib = require('../../lib');

pipe = require('../../pipe');

util = require('../../util');

config = require('../../config');

path = require('path');

module.exports = util.fnOption({
  spec: 'test/*.jade',
  base: 'test',
  globals: {}
}, function(options) {
  return lib.gulp.src(options.spec, {
    base: options.base
  }).pipe(lib.metadata.data(function(file, cb) {
    var basename, basenameNoextname, dirname, extname, filePaths;
    dirname = path.dirname(file.path);
    extname = path.extname(file.path);
    basename = path.basename(file.path);
    basenameNoextname = basename.slice(0, basename.length - extname.length);
    filePaths = [];
    lib.gulp.src(path.join(dirname, basenameNoextname, '**/*'), {
      base: options.base
    }).pipe(lib.pipe.sort()).pipe(lib.pipe.mirror(lib.util.gutil.noop(), pipe.transpile(options.transpile, {
      coffeeCoverage: null
    }))).pipe(lib.pipe["if"](config.glob.javaScript, lib.pipe.through2Map.obj(function(file) {
      filePaths.push(file.path);
      return file;
    }))).pipe(lib.gulp.dest(config.output.testing)).on('end', function() {
      var bower, data;
      filePaths = filePaths.map(function(filePath) {
        filePath = filePath.slice(0, filePath.length - path.extname(filePath).length) + '.js';
        filePath = path.relative(path.dirname(file.path), filePath);
        filePath = filePath.replace(/\\/g, '/');
        return filePath;
      });
      bower = path.relative(path.dirname(file.path), path.resolve(__dirname, '../../../bower_components')).replace(/\\/g, '/');
      data = util.mergeOptions({
        config: {
          paths: {
            mocha: bower + '/mocha',
            chai: bower + '/chai'
          }
        }
      }, {
        config: config
      }, {
        config: {
          paths: {
            tests: filePaths
          },
          webGlobals: options.globals,
          testName: basenameNoextname
        }
      });
      return cb(void 0, data);
    });
  })).pipe(pipe.transpile(options.transpile)).pipe(lib.gulp.dest(config.output.testing)).pipe(lib.pipe.through2Map.obj(function(file) {
    file.path = path.resolve(config.output.testing, path.relative(file.base, file.path));
    return file;
  })).pipe(lib.test.mochaPhantomJs({
    phantomjs: {
      hooks: path.join(__dirname, '../../../lib/hooks.js')
    }
  })).pipe(pipe.collectCoverage(options.collectCoverage));
});
