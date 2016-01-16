;(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define([], factory);
  } else {
    root.dummyProject = factory();
  }
}(this, function () {
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
