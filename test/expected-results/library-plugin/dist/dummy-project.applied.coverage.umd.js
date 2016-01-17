;(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['knockout', 'is-an'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require('knockout'), require('is-an'));
  } else {
    root.ko = factory(root.knockout, root.is-an);
  }
}(this, function(ko, isAn) {
if (typeof _$istanbul === 'undefined') _$istanbul = {};
(function(_export) {
    if (typeof _export._$istanbul === 'undefined') {
        _export._$istanbul = _$istanbul;
    }
})(typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : this);
if (! _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"]) { _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"] = {"path":"C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee","s":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0},"b":{},"f":{"1":0},"fnMap":{"1":{"name":"dummyProject","line":1,"loc":{"start":{"line":1,"column":0},"end":{"line":1,"column":27}}}},"statementMap":{"1":{"start":{"line":1,"column":0},"end":{"line":9,"column":16}},"2":{"start":{"line":2,"column":2},"end":{"line":2,"column":13}},"3":{"start":{"line":3,"column":2},"end":{"line":3,"column":35}},"4":{"start":{"line":5,"column":2},"end":{"line":5,"column":35}},"5":{"start":{"line":6,"column":2},"end":{"line":6,"column":31}},"6":{"start":{"line":7,"column":2},"end":{"line":7,"column":31}},"7":{"start":{"line":8,"column":2},"end":{"line":8,"column":33}},"8":{"start":{"line":9,"column":2},"end":{"line":9,"column":15}}},"branchMap":{}} }var dummyProject;

_$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[1]++;

dummyProject = function(ko, isAn) {
  var results;
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].f[1]++;
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[2]++;
  results = [];
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[3]++;
  results.push('index.begin.coffee');
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[4]++;
  results.push('inner/index.coffee');
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[5]++;
  results.push('inner/a.coffee');
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[6]++;
  results.push('inner/z.coffee');
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[7]++;
  results.push('index.end.coffee');
  _$istanbul["C:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.applied.coffee"].s[8]++;
  return results;
};

return dummyProject(ko, isAn);
}));
