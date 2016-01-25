var config, formatName, hasPrefix, lib, lpadd, path,
  hasProp = {}.hasOwnProperty;

lib = require('../../lib');

config = require('../../config');

path = require('path');

formatName = function(name) {
  return name.replace(/([a-z0-9])([A-Z])/g, function(match, p1, p2) {
    return p1 + '-' + p2.toLowerCase();
  });
};

hasPrefix = function(name, prefix) {
  if (name.slice(0, prefix.length) !== prefix) {
    return false;
  }
  if (name.charAt(prefix.length).match(/^[a-z]/)) {
    return false;
  }
  return true;
};

lpadd = function(str, len, padding) {
  if (padding == null) {
    padding = '00000000000000';
  }
  while (str.length < len) {
    str = (str + padding).slice(0, len);
  }
  return str;
};

module.exports = function(tasks, arg) {
  var excludes, from, group, groupDetails, i, includes, k, len1, name, noted, ref, ref1, ref2, ref3, state, taskName, to;
  ref = arg != null ? arg : {}, includes = ref.includes, excludes = ref.excludes;
  if (excludes == null) {
    excludes = [];
  }
  if (includes == null) {
    includes = (function() {
      var i, len1, ref1, results;
      ref1 = Object.keys(tasks);
      results = [];
      for (i = 0, len1 = ref1.length; i < len1; i++) {
        k = ref1[i];
        if (k[0] !== '_' && excludes.indexOf(k) === -1) {
          results.push(k);
        }
      }
      return results;
    })();
  }
  state = {
    'discrete': {
      index: 0
    },
    'chained': {
      index: 0,
      dep: [],
      skip: ['dist']
    },
    'test': {
      index: 0,
      prefix: 'test',
      dep: []
    },
    'build': {
      index: 0,
      prefix: 'build',
      dep: []
    },
    'dist': {
      index: 0,
      prefix: 'dist',
      dep: []
    }
  };
  for (i = 0, len1 = includes.length; i < len1; i++) {
    name = includes[i];
    for (group in state) {
      if (!hasProp.call(state, group)) continue;
      groupDetails = state[group];
      if ((ref1 = groupDetails.skip) != null ? typeof ref1.some === "function" ? ref1.some(function(prefix) {
        return hasPrefix(name, prefix);
      }) : void 0 : void 0) {
        continue;
      }
      taskName = '';
      if (groupDetails.dep != null) {
        taskName += 'chained-';
      } else {
        taskName += 'discrete-';
      }
      if (groupDetails.prefix != null) {
        if (!hasPrefix(name, groupDetails.prefix)) {
          continue;
        }
        taskName += groupDetails.prefix + '-';
      }
      if (groupDetails.index != null) {
        taskName += lpadd(groupDetails.index.toString(), includes.length < 10 ? 1 : 2) + '-';
        ++groupDetails.index;
      }
      taskName += formatName(name);
      if (groupDetails.dep) {
        lib.gulp.task(taskName, groupDetails.dep, tasks[name]);
        groupDetails.dep = [taskName];
      } else {
        lib.gulp.task(taskName, tasks[name]);
      }
    }
  }
  noted = {
    'chained': 'default',
    'test': 'test',
    'build': 'build',
    'dist': 'dist'
  };
  for (from in noted) {
    if (!hasProp.call(noted, from)) continue;
    to = noted[from];
    if (((ref2 = state[from]) != null ? (ref3 = ref2.dep) != null ? ref3.length : void 0 : void 0) > 0) {
      lib.gulp.task(to, state[from].dep, function() {});
    } else {
      noted[from] = null;
    }
  }
  if (noted['chained'] != null) {
    lib.gulp.task('watch', state['chained'].dep, function() {
      return lib.gulp.watch('src/**/*.{js,coffee}', [noted['chained']]);
    });
  }
  if (noted['build'] != null) {
    lib.gulp.task('watch-build', state['build'].dep, function() {
      return lib.gulp.watch('src/**/*.{js,coffee}', [noted['build']]);
    });
  }
  if (noted['test'] != null) {
    lib.gulp.task('watch-test', state['test'].dep, function() {
      return lib.gulp.watch(path.join(config.output.base, config.output.dist, '**/*'), [noted['test']]);
    });
  }
};
