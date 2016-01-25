var async, config, path, process, spawn, util;

async = require('async');

spawn = require('child_process').spawn;

process = require('process');

path = require('path');

config = require('../../../config');

util = require('../../../util');

module.exports = util.fnOption({
  output: {},
  extras: ['bower.json']
}, function(options) {
  var exec;
  options.output = util.mergeOptions(config.output, options.output);
  exec = function(cmd, args, options, cbDone, cbError) {
    var child, err, escapeArg;
    if (typeof options !== object) {
      cbError = cbDone;
      cbDone = options;
      options = {};
    }
    options = util.mergeOptions({
      stdio: 'inherit'
    }, options);
    err = void 0;
    escapeArg = function(arg) {
      if (!arg.match(/\\|"/g) && arg.match(/\s/g)) {
        return '"' + arg + '"';
      } else {
        return arg.replace(/\\|\s|"/g, '\\$0');
      }
    };
    console.log("> " + cmd + " " + (args.map(escapeArg).join(' ')));
    child = spawn(cmd, args, options);
    child.on('error', function(err) {
      err = new Error(err);
      if (child.pid == null) {
        if (cbError != null) {
          cbError(err, function(err) {
            cbDone(err);
          });
        } else {
          cbDone(err);
        }
      }
    }).on('exit', function(code) {
      if (code !== 0) {
        err = new Error(cmd + " exited with non-zero code " + code);
        err.innerError = err;
      }
      if ((err != null) && (cbError != null)) {
        return cbError(err, function(err) {
          cbDone(err);
        });
      } else {
        return cbDone(err);
      }
    });
    return child;
  };
  return function(doneAll) {
    var cfgNpm;
    cfgNpm = util.loadPackageJson();
    return async.series([
      function(done) {
        var abort;
        abort = false;
        exec('git', ['status', '--porcelain'], {
          stdio: [process.stdin, 'pipe', process.stderr]
        }, function(err) {
          if ((err == null) && abort) {
            err = new Error('Changes detected. Please ensure the staging area is clean before running');
          }
          if (err != null) {
            console.error(err);
          }
          done(err);
        }).on('data', function(data) {
          abort = true;
          process.stdout.write(data);
        });
      }, function(done) {
        var name;
        name = '';
        exec('git', ['status', '--porcelain'], {
          stdio: [process.stdin, 'pipe', process.stderr]
        }, function(err) {
          if ((err == null) && name !== 'master') {
            err = new Error('Current branch is not master. Please only distribute from master.');
          }
          if (err != null) {
            console.error(err);
          }
          done(err);
        }).on('data', function(data) {
          name += data.toString();
          process.stdout.write(data);
        });
      }, function(done) {
        if (options.extras.length !== 0) {
          exec('git', ['add'].concat(options.extras), done);
        } else {
          done();
        }
      }, function(done) {
        if (options.output.dist != null) {
          exec('git', ['add', '-f', path.join(options.output.base, options.output.dist)], done);
        } else {
          done();
        }
      }, function(done) {
        exec('git', ['checkout', 'head'], done);
      }, function(done) {
        exec('git', ['commit', '-m', "Version " + cfgNpm.version + " for distribution"], done);
      }, function(done) {
        exec('git', ['tag', '-a', "v" + cfgNpm.version, '-m', "Add tag " + cfgNpm.version], done);
      }, function(done) {
        exec('npm', ['publish'], function(err, done) {
          if (err != null) {
            console.error(err);
            console.error('RESETTING');
            return exec('git', ['reset'], function() {
              return done(err);
            });
          } else {
            return done(err);
          }
        });
      }, function(done) {
        exec('git', ['checkout', 'master'], done);
      }, function(done) {
        exec('git', ['push', 'origin', '--tags'], done);
      }
    ], doneAll);
  };
});
