(function (ko, isAn){
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

module.exports = dummyProject(ko, isAn);
})(require('knockout'), require('is-an'));
