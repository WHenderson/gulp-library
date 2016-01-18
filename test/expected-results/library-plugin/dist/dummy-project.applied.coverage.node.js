(function (ko, isAn){
if (typeof _$istanbul === 'undefined') _$istanbul = {};
(function(_export) {
    if (typeof _export._$istanbul === 'undefined') {
        _export._$istanbul = _$istanbul;
    }
})(typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : this);
if (! _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"]) { _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"] = {"path":"C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee","s":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0,"13":0,"14":0},"b":{"1":[0,0],"2":[0,0]},"f":{"1":0},"fnMap":{"1":{"name":"dummyProject","line":10,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":27}}}},"statementMap":{"1":{"start":{"line":1,"column":0},"end":{"line":1,"column":4}},"2":{"start":{"line":3,"column":0},"end":{"line":8,"column":7}},"3":{"start":{"line":4,"column":2},"end":{"line":4,"column":6}},"4":{"start":{"line":5,"column":5},"end":{"line":8,"column":7}},"5":{"start":{"line":6,"column":2},"end":{"line":6,"column":6}},"6":{"start":{"line":8,"column":2},"end":{"line":8,"column":7}},"7":{"start":{"line":10,"column":0},"end":{"line":18,"column":16}},"8":{"start":{"line":11,"column":2},"end":{"line":11,"column":13}},"9":{"start":{"line":12,"column":2},"end":{"line":12,"column":35}},"10":{"start":{"line":14,"column":2},"end":{"line":14,"column":35}},"11":{"start":{"line":15,"column":2},"end":{"line":15,"column":31}},"12":{"start":{"line":16,"column":2},"end":{"line":16,"column":31}},"13":{"start":{"line":17,"column":2},"end":{"line":17,"column":33}},"14":{"start":{"line":18,"column":2},"end":{"line":18,"column":15}}},"branchMap":{"1":{"line":3,"type":"if","locations":[{"start":{"line":3,"column":0},"end":{"line":3,"column":0}},{"start":{"line":3,"column":0},"end":{"line":3,"column":0}}]},"2":{"line":5,"type":"if","locations":[{"start":{"line":5,"column":5},"end":{"line":5,"column":5}},{"start":{"line":5,"column":5},"end":{"line":5,"column":5}}]}}} }var dummyProject, x, y;

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[1]++;

x = 1;

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[2]++;

if (x === 1) {
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].b[1][0]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[3]++;
  y = 1;
} else {
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].b[1][1]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[4]++;
  if (x === 2) {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].b[2][0]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[5]++;
    y = 2;
  } else {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].b[2][1]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[6]++;
    y = -1;
  }
}

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[7]++;

dummyProject = function(ko, isAn) {
  var results;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].f[1]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[8]++;
  results = [];
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[9]++;
  results.push('index.begin.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[10]++;
  results.push('inner/index.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[11]++;
  results.push('inner/a.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[12]++;
  results.push('inner/z.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[13]++;
  results.push('index.end.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.applied.coffee"].s[14]++;
  return results;
};

module.exports = dummyProject(ko, isAn);
})(require('knockout'), require('is-an'));
