var bits, config, isSameOrChild, lib, path;

lib = require('../../lib');

config = require('../../config');

path = require('path');

bits = function(p) {
  var basename, dirname, extname, name;
  dirname = path.dirname(p);
  basename = path.basename(p);
  extname = path.extname(basename);
  name = path.basename(basename, extname);
  return {
    path: p,
    dirname: dirname,
    basename: basename,
    extname: extname,
    name: name
  };
};

isSameOrChild = function(parent, sameOrChild) {
  parent = path.normalize(parent).split(path.sep);
  sameOrChild = path.normalize(sameOrChild).split(path.sep).slice(0, parent.length);
  return parent.join(path.sep) === sameOrChild.join(path.sep);
};

module.exports = function() {
  return lib.pipe.sort({
    comparator: function(lhs, rhs) {
      lhs = bits(lhs.path);
      rhs = bits(rhs.path);
      if (((lhs.name === 'index' || lhs.name === 'index.begin') && isSameOrChild(lhs.dirname, rhs.dirname)) || ((rhs.name === 'index.end') && isSameOrChild(rhs.dirname, lhs.dirname))) {
        return -1;
      }
      if (((rhs.name === 'index' || rhs.name === 'index.begin') && isSameOrChild(rhs.dirname, lhs.dirname)) || ((lhs.name === 'index.end') && isSameOrChild(lhs.dirname, rhs.dirname))) {
        return 1;
      }
      if (lhs.path < rhs.path) {
        return -1;
      }
      if (lhs.path > rhs.path) {
        return 1;
      }
      return 0;
    }
  });
};
