(function (isAn){
var dummyProject, x, y;

x = 1;

if (x === 1) {
  y = 1;
} else if (x === 2) {
  y = 2;
} else {
  y = -1;
}

dummyProject = function(ko, test) {
  var results;
  if (test === 'node') {
    return 'nodeTest';
  } else if (test === 'client') {
    return 'clientTest';
  }
  results = [];
  results.push('index.begin.coffee');
  results.push('inner/index.coffee');
  results.push('inner/a.coffee');
  results.push('inner/z.coffee');
  results.push('index.end.coffee');
  return results;
};

module.exports = dummyProject;
})(require('is-an'));
