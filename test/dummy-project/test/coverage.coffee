all = require('../../../src')

# relative to package root
all.config.globals.dummyProject = '../../build/test/library/dist/dummy-project.coffee'

all.test.coverage({ base: __dirname })