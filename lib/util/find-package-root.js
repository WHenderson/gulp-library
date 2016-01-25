var fs, path, process;

fs = require('fs');

path = require('path');

process = require('process');

module.exports = function(base, name) {
  var next;
  if (name == null) {
    name = 'package.json';
  }
  if (base == null) {
    base = process.cwd();
  }
  while (true) {
    if (fs.existsSync(path.join(base, name))) {
      return base;
    }
    next = path.resolve(base, '..');
    if (next === base) {
      return void 0;
    }
    base = next;
  }
};
