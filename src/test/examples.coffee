path = require('path')
lib = require('../lib')
util = require('../util')
config = require('../config')
fork = require('child_process').fork
spawn = require('child_process').spawn
process = require('process')
assert = require('chai').assert
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

            try
              filePathExpected = filePath.slice(0, -path.extname(filePath).length) + '.expected.output'
              filePathActual = filePath.slice(0, -path.extname(filePath).length) + '.actual.output'
              expected = fs.readFileSync(filePathExpected, 'utf8').replace(/\r\n|\n|\r/g, '\n')
            catch ex
              if ex.code == 'ENOENT'
                console.error("Cannot find #{filePathExpected} to compare output")
              else
                throw ex

            isDone = false
            if path.extname(filePath) == '.js'
              child = fork(filePath, [], { silent: true })
            else
              @timeout(20*1000)
              child = spawn(phantomJsPath, [path.join(__dirname, '../../lib/phantom-example.js'), filePath], { stdio: ['ignore', 'pipe', 'inherit'] })

            output = ''
            child.stdout.on('data', (data) ->
              output += data.toString()
              process.stdout.write(data)
              return
            )
            child.stderr?.on('data', (data) ->
              process.stderr.write(data)
              return
            )

            child
            .on('exit', (code) ->
              if code == 0
                if not isDone
                  isDone = true

                  try
                    assert.equal(output.replace(/\r\n|\n|\r/g, '\n'), expected, "Output does not match #{filePathExpected}")
                  catch ex
                    try
                      fs.writeFileSync(filePathActual, output,'utf8')
                      console.error("Actual output written to #{filePathActual}")
                    catch ex2

                  testDone(ex)
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
