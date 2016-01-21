path = require('path')
lib = require('../lib')
util = require('../util')
fork = require('child_process').fork
spawn = require('child_process').spawn

module.exports = util.fnOption(
  {
    spec: undefined
    name: 'examples'
    base: undefined
  }
  (options) ->
    options.base ?= util.findPackageRoot()
    options.base = path.resolve(options.base)
    options.spec ?= path.join(options.base, options.name, '**/*.{js,html}')

    filePaths = lib.util.glob.sync(options.spec, {}).map((filePath) -> path.resolve(filePath))
    filePaths = filePaths.filter((filePath) ->
      parent = filePath
      while parent != options.base
        parent = path.dirname(parent)
        if filePaths.indexOf(parent + '.html') != -1
          return false

      return true
    )

    phantomJsPath = lookup('.bin/phantomjs', true) || lookup('phantomjs/bin/phantomjs', true)

    suite(name, () ->
      for filePath in filePaths
        do (filePath) ->
          test(path.relative(options.base, fileName), (testDone) ->
            isDone = false
            if path.extname(filePath) == '.js'
              fork(filePath)
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
              spawn(phantomJsPath, [path.join(__dirname, '../phantom-example.js'), filePath])
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
