var argv, child_process, colors, commands, config, exec, fs, process, readFile, stat, wrap, writeFile,
  slice = [].slice;

argv = require('yargs').usage('Usage: $0 <command> [options]').command('preversion', 'To be run as part of your npm preversion script. Verifies that the working folder is a clean master.').command('version', 'To be run as part of your npm version script. Adds dist files to your version tag without contaminating your master branch. Rolls back on error.').demand(1).strict().help('h').argv;

config = require('../config');

colors = require('colors');

colors.setTheme({
  command: 'cyan',
  error: 'red'
});

child_process = require('child_process');

process = require('process');

fs = require('fs');

exec = function(command) {
  console.log(colors.command("> " + command));
  return new Promise(function(resolve, reject) {
    child_process.exec(command, function(err, stdout, stderr) {
      process.stdout.write(stdout);
      process.stderr.write(stderr);
      if (err != null) {
        reject(err);
      } else {
        resolve(stdout);
      }
    });
  });
};

wrap = function(func) {
  return function() {
    var args;
    args = arguments;
    return new Promise(function(resolve, reject) {
      func.apply(null, slice.call(args).concat([function(err, result) {
        if (err != null) {
          reject(err);
        } else {
          resolve(result);
        }
      }]));
    });
  };
};

stat = wrap(fs.stat);

readFile = wrap(fs.readFile);

writeFile = wrap(fs.writeFile);

commands = {};

commands.preversion = function() {
  return Promise.resolve().then(function() {
    return exec('git rev-parse --abbrev-ref HEAD').then(function(stdout) {
      if (stdout.trim() !== 'master') {
        throw new Error('HEAD is not master');
      }
    });
  }).then(function() {
    return exec('git status --porcelain').then(function(stdout) {
      if (stdout.trim() !== '') {
        throw new Error('Working folder is not clean');
      }
    });
  })["catch"](function(error) {
    console.error(error);
    console.log(error.stack);
    process.exit(1);
  });
};

commands.version = function() {
  var cleanup, pkg;
  cleanup = [
    function() {
      return exec('git reset --hard');
    }, function() {
      return exec('git clean -fd');
    }
  ];
  pkg = void 0;
  return Promise.resolve().then(function() {
    return exec('git status --porcelain --untracked-files=no').then(function(stdout) {
      var lines;
      lines = stdout.split('\n').map(function(line) {
        return line.trim();
      }).filter(function(line) {
        return line !== '';
      });
      if (lines.length !== 0 && lines.every(function(line) {
        return line.match(/^M\s(package|npm-shrinkwrap|bower)\.json/);
      })) {
        return;
      }
      throw new Error('version not changed');
    }).then(function() {
      return readFile('package.json').then(function(data) {
        pkg = JSON.parse(data.toString());
      });
    }).then(function() {
      return Promise.resolve().then(function() {
        return exec('git add package.json');
      }).then(function() {
        return stat('npm-shrinkwrap.json').then(function(stat) {
          return exec('git add npm-shrinkwrap.json');
        }, function(error) {
          if (error.code === 'ENOENT') {
            return;
          }
          return Promise.reject(error);
        });
      }).then(function() {
        return stat('bower.json').then(function() {
          return readFile('bower.json').then(function(data) {
            var bower;
            bower = JSON.parse(data.toString());
            bower.version = pkg.version;
            return writeFile('bower.json', JSON.stringify(bower, null, '  '));
          }).then(function() {
            return exec('git add bower.json');
          });
        }, function(error) {
          if (error.code === 'ENOENT') {
            return;
          }
          return Promise.reject(error);
        });
      }).then(function() {
        return exec("git commit -m \"v" + pkg.version + "\"").then(function() {
          return cleanup.unshift(function() {
            return exec('git reset --hard HEAD~');
          });
        });
      });
    });
  }).then(function() {
    return Promise.resolve().then(function() {
      return exec("git checkout head");
    }).then(function() {
      return exec("git add -f \"" + config.output.dist + "\"");
    }).then(function() {
      return exec('git commit -m "distribution files"');
    }).then(function() {
      return exec("git tag -a \"v" + pkg.version + "\" -m \"v" + pkg.version + " for distribution");
    }).then(function() {
      return exec('git checkout master');
    }, function(error) {
      exec('git checkout master');
      return Promise.reject(error);
    });
  }).then(function() {
    console.log('to propagate this release, run:');
    console.log('  > git push origin --tags');
  })["catch"](function(error) {
    var i, item, len, promise;
    console.log(error);
    console.log(error.stack);
    promise = Promise.resolve();
    for (i = 0, len = cleanup.length; i < len; i++) {
      item = cleanup[i];
      promise = promise.then(item);
    }
    return promise.then(function() {
      return process.exit(1);
    }, function() {
      return process.exit(-1);
    });
  });
};

commands[argv._[0]]();
