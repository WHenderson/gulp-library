module.exports = {
  afterEnd: (runner) ->
    fs = require('fs')

    config = runner.page.evaluate(() ->
      window._$config
    )
    coverage = runner.page.evaluate(() ->
      JSON.stringify(window[config.coffeeCoverage.coverageVar])
    )

    filePath = config.output.base
    if filePath
      filePath += '/'
    filePath += config.output.coverage + '/parts/client-' + config.testName + '.json'

    if (coverage)
      console.log('Writing coverage to coverage/coverage.json')
      fs.write(filePath, coverage, 'w')
    else
      console.log('No coverage data generated')

    return
}