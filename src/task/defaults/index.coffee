lib = require('../../lib')

module.exports = {
  _cleanOptions: {}
  clean: () ->
    require('../clean')(@_cleanOptions)

  _buildLibraryOptions: {}
  buildLibrary: () ->
    require('../library')(@_buildLibraryOptions)

  _testNodeOptions: {}
  testNode: () ->
    require('../test').node(_testNodeOptions)

  _testClientOptions: {}
  testClient: () ->
    require('../test').client(_testClientOptions)

  _testExamplesOptions: {}
  testExamples: () ->
    require('../test').examples(_testExamplesOptions)

  export: (options) ->
    options = lib.util.extend({}, options)
    options.excludes = lib.util.extend([], options.excludes ? [])
    options.excludes.push('export')
    require('../export-tasks')(@, options)
}