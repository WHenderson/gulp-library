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

  tasks: (tasks) ->
    lib.util.extend(@, tasks)

    return @

  options: ({
    clean,
    buildLibrary,
    testNode,
    testClient,
    testExamples
  } = options) ->
    lib.util.extend(@_cleanOptions, clean)
    lib.util.extend(@_buildLibraryOptions, buildLibrary)
    lib.util.extend(@_testNodeOptions, testNode)
    lib.util.extend(@_testClientOptions, testClient)
    lib.util.extend(@_testExamplesOptions, testExamples)

    return @


  export: (options) ->
    options = lib.util.extend({}, options)
    options.excludes = lib.util.extend([], options.excludes ? [])
    options.excludes.push('tasks')
    options.excludes.push('options')
    options.excludes.push('export')

    return require('../export-tasks')(@, options)
}