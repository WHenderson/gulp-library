path = require('path')
lib = require('../lib')
util = require('../util')
config = require('../config')
fork = require('child_process').fork
spawn = require('child_process').spawn
process = require('process')
fs = require('fs')

lookup = (filePath, isExecutable) ->
  for modulePath in module.paths
    absPath = path.join(modulePath, filePath)
    if isExecutable and process.platform == 'win32'
      absPath += '.cmd'
    if fs.existsSync(absPath)
      return absPath
  return

module.exports = util.fnOption(
  {
    spec: undefined
    name: undefined
    base: undefined
  }
  (options) ->
    options.name ?= config.testExamples?.name ? 'examples'
    options.base ?= config.testExamples?.base ? util.findPackageRoot()
    options.spec ?= config.testExamples?.spec ? '**/*.{js,html}'
    options.base = path.resolve(options.base)

    filePaths = lib.util.glob.sync(path.join(options.base, options.name, options.spec), {}).map((filePath) -> path.resolve(filePath))
    filePaths = filePaths.filter((filePath) ->
      parent = filePath
      while parent != options.base
        parent = path.dirname(parent)
        if filePaths.indexOf(parent + '.html') != -1
          return false

      return true
    )

    phantomJsPath = lookup('.bin/phantomjs', true) || lookup('phantomjs/bin/phantomjs', true)

    suite(options.name, () ->
      for filePath in filePaths
        do (filePath) ->
          test(path.relative(options.base, filePath), (testDone) ->
            isDone = false
            if path.extname(filePath) == '.js'
              fork(filePath, { stdio: 'inherit' })
              .on('exit', (code) ->
                if code == 0
                  if not isDone
                    isDone = true
                    testDone()
                else
                  if not isDone
                    isDone = true
                    testDone(new Error("Executing #{filePath} exited with code #{code}"))
                return
              )
              .on('error', (err) ->
                if not isDone
                  isDone = true
                  testDone(new Error("Error '#{err}' executing #{filePath}"))
                return
              )
            else
              @timeout(20*1000)
              spawn(phantomJsPath, [path.join(__dirname, '../../lib/phantom-example.js'), filePath], { stdio: 'inherit' })
              .on('exit', (code) ->
                if code == 0
                  if not isDone
                    isDone = true
                    testDone()
                else
                  if not isDone
                    isDone = true
                    testDone(new Error("Executing #{filePath} exited with code #{code}"))
                return
              )
              .on('error', (err) ->
                if not isDone
                  isDone = true
                  testDone(new Error("Error '#{err}' executing #{filePath}"))
                return
              )
          )
    )
)
