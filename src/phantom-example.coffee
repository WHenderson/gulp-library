page = require('webpage').create()
args = require('system').args

page.onCallback = (data) ->
  if data.message?
    console.log(data.message)

  if data.exit
    if typeof data.exit == 'number'
      phantom.exit(data.exit)
    else
      phantom.exit()

  return

page.onConsoleMessage = (msg, lineNum, sourceId) ->
  console.log("CONSOLE: #{msg} (#{lineNum}:#{sourceId})")
  return

page.open(args[1], (status) ->
  if (status != 'success')
    console.error("Failed to open #{args[1]}")
    phantom.exit()
)