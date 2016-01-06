all = require('./src')
fs = require('fs')
path = require('path')
process = require('process')

all.config.output.dist = 'lib'

tasks = {
  clean: () ->
    all.task.clean()

  build: () ->
    all.pipe.transpile.cson = false
    all.pipe.transpile.jade = false

    all.lib.gulp
    .src('src/**/*')
    .pipe(all.pipe.transpile())
    .pipe(all.lib.gulp.dest(all.config.output.dist))
    .on('finish', () ->
      all.pipe.transpile.cson = '*.cson'
      all.pipe.transpile.jade = '*.jade'
    )

  testCoverage: () ->
    all.task.test.coverage()

  testExamples: () ->
    all.task.test.examples()

  cleanPhantom: () ->
    all.task.clean('build/phantomjs')

  buildPhantom: () ->
    all.lib.gulp
    .src('test/phantomjs/**/*')
    .pipe(all.lib.pipe.if(all.pipe.transpile.jade, all.lib.metadata.data(
      (file, cb) ->
        dirname = path.dirname(file.path)
        filename = file.path.slice(dirname.length + 1)
        ext = path.extname(filename)
        name = filename.slice(0, filename.length - ext.length)

        console.log('jade:', file.path)
        console.log('glob:', path.join(dirname, name, '**/*.{coffee,js}'))

        all.lib.util.glob(
          path.join(dirname, name, '**/*.{coffee,js}'),
          {}
          (err, files) ->
            console.log('files:', files)

            files = for filePath in files
              filePath = filePath.slice(dirname.length + 1)
              filePath = filePath.slice(0, filePath.length - path.extname(filePath).length) + '.js'
              filePath

            console.log('testPaths:', files)

            cb(
              undefined,
              all.lib.util.extend(
                file.data or {}
                {
                  testPaths: files
                }
              )
            )
        )
    )))
    .pipe(all.pipe.transpile())
    .pipe(all.lib.gulp.dest('build/phantomjs'))

  depsPhantom: () ->
    try
      bower = JSON.parse(fs.readFileSync('test/phantomjs/bower.json', 'utf8'))
    catch ex
      bower = {}

    bower = all.lib.util.extend({}, all.config.test.bowerPhantomJs, bower)
    fs.writeFileSync('build/phantomjs/bower.json', JSON.stringify(bower, null, '  '))


    process.chdir('build/phantomjs')
    return all.lib.util.bower.commands
    .install()
    .on('end', () ->
      process.chdir('../../')
    )

  testPhantom: () ->
    all.lib.gulp
    .src('build/phantomjs/**/*.html', { read: false })
    .pipe(all.lib.test.mochaPhantomJs({
      reporter: 'spec'
    }))
}

all.task.tasks(tasks)
