page = require('webpage').create()
args = require('system').args

page.onCallback = (data) ->
  if not data?
    data = {}
  else if typeof data == 'string'
    data = { message: data }

  if data.message?
    console.log("MESSAGE: #{data.message}")

  if typeof data.exit == 'number'
    phantom.exit(data.exit)
  else if data.exit != false
    phantom.exit()

  return

page.onConsoleMessage = (msg) ->
  console.log(msg)
  return

page.open(args[1], (status) ->
  if (status != 'success')
    console.error("Failed to open #{args[1]}")
    phantom.exit()
)