;(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define([], factory);
  } else {
    root.dummyProject = factory();
  }
}(this, function () {
if (typeof _$istanbul === 'undefined') _$istanbul = {};
(function(_export) {
    if (typeof _export._$istanbul === 'undefined') {
        _export._$istanbul = _$istanbul;
    }
})(typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : this);
if (! _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"]) { _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"] = {"path":"c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee","s":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0},"b":{},"f":{"1":0},"fnMap":{"1":{"name":"dummyProject","line":1,"loc":{"start":{"line":1,"column":0},"end":{"line":1,"column":27}}}},"statementMap":{"1":{"start":{"line":1,"column":0},"end":{"line":9,"column":16}},"2":{"start":{"line":2,"column":2},"end":{"line":2,"column":13}},"3":{"start":{"line":3,"column":2},"end":{"line":3,"column":35}},"4":{"start":{"line":5,"column":2},"end":{"line":5,"column":35}},"5":{"start":{"line":6,"column":2},"end":{"line":6,"column":31}},"6":{"start":{"line":7,"column":2},"end":{"line":7,"column":31}},"7":{"start":{"line":8,"column":2},"end":{"line":8,"column":33}},"8":{"start":{"line":9,"column":2},"end":{"line":9,"column":15}}},"branchMap":{}} }var dummyProject;

_$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[1]++;

dummyProject = function(ko, isAn) {
  var results;
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].f[1]++;
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[2]++;
  results = [];
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[3]++;
  results.push('index.begin.coffee');
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[4]++;
  results.push('inner/index.coffee');
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[5]++;
  results.push('inner/a.coffee');
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[6]++;
  results.push('inner/z.coffee');
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[7]++;
  results.push('index.end.coffee');
  _$istanbul["c:\\Code\\OwnGitHub\\gulp-library\\test\\dummy-project\\src\\dummy-project.coffee"].s[8]++;
  return results;
};

return dummyProject;
}));
