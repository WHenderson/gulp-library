var args, page;

page = require('webpage').create();

args = require('system').args;

page.onCallback = function(data) {
  if (data == null) {
    data = {};
  } else if (typeof data === 'string') {
    data = {
      message: data
    };
  }
  if (data.message != null) {
    console.log("MESSAGE: " + data.message);
  }
  if (typeof data.exit === 'number') {
    phantom.exit(data.exit);
  } else if (data.exit !== false) {
    phantom.exit();
  }
};

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

page.open(args[1], function(status) {
  if (status !== 'success') {
    console.error("Failed to open " + args[1]);
    return phantom.exit();
  }
});
