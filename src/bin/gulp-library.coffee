argv = require('yargs')
.usage('Usage: $0 <command> [options]')
.command('preversion', 'To be run as part of your npm preversion script. Verifies that the working folder is a clean master.')
.command('version', 'To be run as part of your npm version script. Adds dist files to your version tag without contaminating your master branch. Rolls back on error.')
.demand(1)
.strict()
.help('h')
.argv

config = require('../config')

colors = require('colors')
colors.setTheme({
  command: 'cyan'
  error: 'red'
})

child_process = require('child_process')
process = require('process')
fs = require('fs')

exec = (command) ->
  console.log(colors.command("> #{command}"))

  new Promise((resolve, reject) ->
    child_process.exec(command, (err, stdout, stderr) ->
      process.stdout.write(stdout)
      process.stderr.write(stderr)

      if err?
        reject(err)
      else if stderr? and stderr != ''
        reject(new Error("stderr: #{stderr}"))
      else
        resolve(stdout)

      return
    )

    return
  )

wrap = (func) ->
  () ->
    new Promise((resolve, reject) ->
      console.log('func:', func.name, '(', arguments, ')')
      func(arguments..., (err, result) ->
        if err?
          reject(err)
        else
          resolve(result)

        return
      )
      return
    )

stat = wrap(fs.stat)
readFile = wrap(fs.readFile)
writeFile = wrap(fs.writeFile)

commands = {}

commands.preversion = () ->
  Promise.resolve()
  .then(() ->
    # Verify HEAD is master

    exec('git rev-parse --abbrev-ref HEAD')
    .then((stdout) ->
      if stdout.trim() != 'master'
        throw new Error('HEAD is not master')

      return
    )
  )
  .then(() ->
    # Verify clean working folder

    exec('git status --porcelain')
    .then((stdout) ->
      if stdout.trim() != ''
        throw new Error('Working folder is not clean')

      return
    )
  )
  .catch((error) ->
    console.error(error)
    console.log(error.stack)
    process.exit(1) # signal failure
    return
  )

commands.version = () ->
  cleanup = [
    () -> exec('git reset --hard')
    () -> exec('git clean -fd')
  ]
  pkg = undefined

  Promise.resolve()
  .then(() ->
    # Verify only expected files have been modified

    exec('git status --porcelain --untracked-files=no')
    .then((stdout) ->
      lines = stdout.split('\n').map((line) -> line.trim()).filter((line) -> line != '')
      if lines.length != 0 and lines.every((line) -> line.match(/^M\s(package|npm-shrinkwrap|bower)\.json/))
        return

      throw new Error('version not changed')
    )
    .then(() ->
      # Load package metadata

      readFile('package.json')
      .then((data) ->
        pkg = JSON.parse(data.toString())
        return
      )
    )
    .then(() ->
      # Add versioned files

      Promise.resolve()
      .then(() ->
        # package.json

        exec('git add package.json')
      )
      .then(() ->
        # npm-shrinkwrap.json

        stat('npm-shrinkwrap.json')
        .then(
          (stat) ->
            exec('git add npm-shrinkwrap.json')
          (error) ->
            if error.code == 'ENOENT'
              return

            Promise.reject(error)
        )
      )
      .then(() ->
        # bower.json

        stat('bower.json')
        .then(
          () ->
            readFile('bower.json')
            .then((data) ->
              bower = JSON.parse(data.toString())
              bower.version = pkg.version

              writeFile('bower.json', JSON.stringify(bower, null, '  '))
            )
            .then(() ->
              exec('git add bower.json')
            )
          (error) ->
            if error.code == 'ENOENT'
              return

            Promise.reject(error)
        )
      )
      .then(() ->
        # commit the version bumps

        exec("git commit -m \"v#{pkg.version}\"")
        .then(() ->
          cleanup.unshift(() ->
            return exec('git reset --hard HEAD~')
          )
        )
      )
    )
  )
  .then(() ->
    # Add dist files

    Promise.resolve()
    .then(() ->
      exec("git checkout head")
    )
    .then(() ->
      exec("git add -f \"#{config.output.dist}\"")
    )
    .then(() ->
      exec('git commit -m "distribution files"')
    )
    .then(() ->
      exec("git tag -a \"v#{pkg.version}\" -m \"v#{pkg.version} for distribution")
    )
    .then(
      () ->
        exec('git checkout master')
      (error) ->
        exec('git checkout master')

        Promise.reject(error)
    )
  )
  .then(() ->
    # push up the chain
    console.log('to propagate this release, run:')
    console.log('  > git push origin --tags')

    return
  )
  .catch((error) ->
    console.log(error)
    console.log(error.stack)

    # cleanup

    promise = Promise.resolve()
    for item in cleanup
      promise = promise.then(item)

    promise
    .then(
      () ->
        process.exit(1)
      () ->
        process.exit(-1)
    )
  )


commands[argv._[0]]()
