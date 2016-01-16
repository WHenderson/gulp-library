;(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['knockout', 'is-an'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require('knockout'), require('is-an'));
  } else {
    root.dummyProject = factory(root.knockout, root.is-an);
  }
}(this, function(ko, isAn) {
var dummyProject;

dummyProject = function(ko, isAn) {
  var results;
  results = [];
  results.push('index.begin.coffee');
  results.push('inner/index.coffee');
  results.push('inner/a.coffee');
  results.push('inner/z.coffee');
  results.push('index.end.coffee');
  return results;
};

return dummyProject;
}));
