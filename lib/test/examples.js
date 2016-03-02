var assert, config, fork, fs, lib, lookup, path, process, spawn, util;

path = require('path');

lib = require('../lib');

util = require('../util');

config = require('../config');

fork = require('child_process').fork;

spawn = require('child_process').spawn;

process = require('process');

assert = require('chai').assert;

fs = require('fs');

lookup = function(filePath, isExecutable) {
  var absPath, i, len, modulePath, ref;
  ref = module.paths;
  for (i = 0, len = ref.length; i < len; i++) {
    modulePath = ref[i];
    absPath = path.join(modulePath, filePath);
    if (isExecutable && process.platform === 'win32') {
      absPath += '.cmd';
    }
    if (fs.existsSync(absPath)) {
      return absPath;
    }
  }
};

module.exports = util.fnOption({
  spec: void 0,
  name: void 0,
  base: void 0
}, function(options) {
  var filePaths, phantomJsPath, ref, ref1, ref2, ref3, ref4, ref5;
  if (options.name == null) {
    options.name = (ref = (ref1 = config.testExamples) != null ? ref1.name : void 0) != null ? ref : 'examples';
  }
  if (options.base == null) {
    options.base = (ref2 = (ref3 = config.testExamples) != null ? ref3.base : void 0) != null ? ref2 : util.findPackageRoot();
  }
  if (options.spec == null) {
    options.spec = (ref4 = (ref5 = config.testExamples) != null ? ref5.spec : void 0) != null ? ref4 : '**/*.{js,html}';
  }
  options.base = path.resolve(options.base);
  filePaths = lib.util.glob.sync(path.join(options.base, options.name, options.spec), {}).map(function(filePath) {
    return path.resolve(filePath);
  });
  filePaths = filePaths.filter(function(filePath) {
    var parent;
    parent = filePath;
    while (parent !== options.base) {
      parent = path.dirname(parent);
      if (filePaths.indexOf(parent + '.html') !== -1) {
        return false;
      }
    }
    return true;
  });
  phantomJsPath = lookup('.bin/phantomjs', true) || lookup('phantomjs/bin/phantomjs', true);
  return suite(options.name, function() {
    var filePath, i, len, results;
    results = [];
    for (i = 0, len = filePaths.length; i < len; i++) {
      filePath = filePaths[i];
      results.push((function(filePath) {
        return test(path.relative(options.base, filePath), function(testDone) {
          var child, error, ex, expected, filePathActual, filePathExpected, isDone, output, ref6;
          try {
            filePathExpected = filePath.slice(0, -path.extname(filePath).length) + '.expected.output';
            filePathActual = filePath.slice(0, -path.extname(filePath).length) + '.actual.output';
            expected = fs.readFileSync(filePathExpected, 'utf8').replace(/\r\n|\n|\r/g, '\n');
          } catch (error) {
            ex = error;
            if (ex.code === 'ENOENT') {
              console.error("Cannot find " + filePathExpected + " to compare output");
            } else {
              throw ex;
            }
          }
          isDone = false;
          if (path.extname(filePath) === '.js') {
            child = fork(filePath, [], {
              silent: true
            });
          } else {
            this.timeout(20 * 1000);
            child = spawn(phantomJsPath, [path.join(__dirname, '../../lib/phantom-example.js'), filePath], {
              stdio: ['ignore', 'pipe', 'inherit']
            });
          }
          output = '';
          child.stdout.on('data', function(data) {
            output += data.toString();
            process.stdout.write(data);
          });
          if ((ref6 = child.stderr) != null) {
            ref6.on('data', function(data) {
              process.stderr.write(data);
            });
          }
          return child.on('exit', function(code) {
            var error1, error2, ex2;
            if (code === 0) {
              if (!isDone) {
                isDone = true;
                try {
                  assert.equal(output.replace(/\r\n|\n|\r/g, '\n'), expected, "Output does not match " + filePathExpected);
                } catch (error1) {
                  ex = error1;
                  try {
                    fs.writeFileSync(filePathActual, output, 'utf8');
                    console.error("Actual output written to " + filePathActual);
                  } catch (error2) {
                    ex2 = error2;
                  }
                }
                testDone(ex);
              }
            } else {
              if (!isDone) {
                isDone = true;
                testDone(new Error("Executing " + filePath + " exited with code " + code));
              }
            }
          }).on('error', function(err) {
            if (!isDone) {
              isDone = true;
              testDone(new Error("Error '" + err + "' executing " + filePath));
            }
          });
        });
      })(filePath));
    }
    return results;
  });
});
