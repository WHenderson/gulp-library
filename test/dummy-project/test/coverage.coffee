all = require('../../../src')

# relative to package root
all.config.globals.dummyProject = '../../build/test/library/dist/dummy-project.coverage.node.js'

all.test.coverage({ base: __dirname })