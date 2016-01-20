module.exports = {
  afterEnd: (runner) ->
    fs = require('fs')

    config = runner.page.evaluate(() ->
      window._$config
    )
    coverage = runner.page.evaluate(() ->
      JSON.stringify(window[window._$config.coffeeCoverage.coverageVar])
    )

    if (coverage)
      filePath = config.output.base
      if filePath
        filePath += '/'
      filePath += config.output.coverage + '/parts/client-' + config.testName + '.json'

      console.log('Writing coverage to', filePath)
      fs.write(filePath, coverage, 'w')
    else
      console.log('No coverage data generated')

    return
}