/*jshint node:true */

var exec = require('child_process').exec;

module.exports = function() {

  if(process.platform !== "win32") {
    console.log("This command is not available on non-Windows platforms.");
    process.exit(1);
  }
  
  var regpath = "HKEY_CURRENT_USER\\Software\\Scirra\\Construct2\\html5",
      newmode;

  exec('reg query "'+regpath+'" /v "devmode"', function(err, stdout, stderr) {
    if(err) {
      console.log("Error while executing command: " + err);
    }
   
    var strerr = ''+stderr,
        strout = ''+stdout;
    if(strerr.match("unable to find")) {
      newmode = 1;
    }

    if(strout.match("REG_DWORD")) {
      newmode = strout.match("0x1") ? 0 : 1;
    }

    if(newmode !== null) {
      exec('reg add "'+regpath+'" /v "devmode" /t REG_DWORD /d '+newmode+' /f', function(err, stdout, stderr) {
        if(err) {
          console.log("Error while executing command: " + err);
        }
        if(!stderr) {
          console.log("The developer mode is now " + (newmode ? "on." : "off."));
        }
      });
    }
  });
};