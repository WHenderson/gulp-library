;(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(['is-an'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require('is-an'));
  } else {
    root.dummyProject = factory(root.is-an);
  }
}(this, function(isAn) {
if (typeof _$istanbul === 'undefined') _$istanbul = {};
(function(_export) {
    if (typeof _export._$istanbul === 'undefined') {
        _export._$istanbul = _$istanbul;
    }
})(typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : this);
if (! _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"]) { _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"] = {"path":"C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee","s":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0,"13":0,"14":0,"15":0,"16":0,"17":0,"18":0},"b":{"1":[0,0],"2":[0,0],"3":[0,0],"4":[0,0]},"f":{"1":0},"fnMap":{"1":{"name":"dummyProject","line":10,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":27}}}},"statementMap":{"1":{"start":{"line":1,"column":0},"end":{"line":1,"column":4}},"2":{"start":{"line":3,"column":0},"end":{"line":8,"column":7}},"3":{"start":{"line":4,"column":2},"end":{"line":4,"column":6}},"4":{"start":{"line":5,"column":5},"end":{"line":8,"column":7}},"5":{"start":{"line":6,"column":2},"end":{"line":6,"column":6}},"6":{"start":{"line":8,"column":2},"end":{"line":8,"column":7}},"7":{"start":{"line":10,"column":0},"end":{"line":23,"column":16}},"8":{"start":{"line":11,"column":2},"end":{"line":16,"column":1}},"9":{"start":{"line":12,"column":4},"end":{"line":12,"column":20}},"10":{"start":{"line":13,"column":7},"end":{"line":16,"column":1}},"11":{"start":{"line":14,"column":4},"end":{"line":14,"column":22}},"12":{"start":{"line":16,"column":2},"end":{"line":16,"column":13}},"13":{"start":{"line":17,"column":2},"end":{"line":17,"column":35}},"14":{"start":{"line":19,"column":2},"end":{"line":19,"column":35}},"15":{"start":{"line":20,"column":2},"end":{"line":20,"column":31}},"16":{"start":{"line":21,"column":2},"end":{"line":21,"column":31}},"17":{"start":{"line":22,"column":2},"end":{"line":22,"column":33}},"18":{"start":{"line":23,"column":2},"end":{"line":23,"column":15}}},"branchMap":{"1":{"line":3,"type":"if","locations":[{"start":{"line":3,"column":0},"end":{"line":3,"column":0}},{"start":{"line":3,"column":0},"end":{"line":3,"column":0}}]},"2":{"line":5,"type":"if","locations":[{"start":{"line":5,"column":5},"end":{"line":5,"column":5}},{"start":{"line":5,"column":5},"end":{"line":5,"column":5}}]},"3":{"line":11,"type":"if","locations":[{"start":{"line":11,"column":2},"end":{"line":11,"column":2}},{"start":{"line":11,"column":2},"end":{"line":11,"column":2}}]},"4":{"line":13,"type":"if","locations":[{"start":{"line":13,"column":7},"end":{"line":13,"column":7}},{"start":{"line":13,"column":7},"end":{"line":13,"column":7}}]}}} }var dummyProject, x, y;

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[1]++;

x = 1;

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[2]++;

if (x === 1) {
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[1][0]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[3]++;
  y = 1;
} else {
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[1][1]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[4]++;
  if (x === 2) {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[2][0]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[5]++;
    y = 2;
  } else {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[2][1]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[6]++;
    y = -1;
  }
}

_$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[7]++;

dummyProject = function(ko, test) {
  var results;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].f[1]++;
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[8]++;
  if (test === 'node') {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[3][0]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[9]++;
    return 'nodeTest';
  } else {
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[3][1]++;
    _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[10]++;
    if (test === 'client') {
      _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[4][0]++;
      _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[11]++;
      return 'clientTest';
    } else {
      _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].b[4][1]++;
      void 0;
    }
  }
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[12]++;
  results = [];
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[13]++;
  results.push('index.begin.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[14]++;
  results.push('inner/index.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[15]++;
  results.push('inner/a.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[16]++;
  results.push('inner/z.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[17]++;
  results.push('index.end.coffee');
  _$istanbul["C:\\Code\\GitHub\\gulp-library\\test\\dummy-project\\dist\\dummy-project.apply.coffee"].s[18]++;
  return results;
};

return dummyProject;
}));
