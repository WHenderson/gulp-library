var config, fs, mkdirp, path, process;

config = require('../../config');

fs = require('fs');

path = require('path');

process = require('process');

mkdirp = require('mkdirp');

module.exports = function(name, reason) {
  var coverage, coverageBase, coveragePath, error, ex;
  if (name == null) {
    name = 'coverage';
  }
  coverage = global[config.coffeeCoverage.coverageVar];
  coverageBase = path.resolve(config.output.base, config.output.coverage, 'parts');
  coveragePath = path.resolve(coverageBase, name + '.json');
  if (coverage == null) {
    console.error('No coverage collected');
    return;
  }
  try {
    mkdirp.sync(coverageBase);
    fs.writeFileSync(coveragePath, JSON.stringify(coverage));
  } catch (error) {
    ex = error;
    console.error('Error saving coverage:', ex);
  }
};

module.exports.register = function(name) {
  process.on('exit', module.exports.bind(null, name, 'exit'));
  process.on('SIGINT', module.exports.bind(null, name, 'SIGINT'));
  process.on('uncaughtException', module.exports.bind(null, name, 'uncaughtException'));
};
