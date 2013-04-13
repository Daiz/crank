/*jshint node:true */

var program = require('commander'),
    exec    = require('child_process').exec;

// platform check
var windows = (process.platform === 'win32');

// > crank init [plugin/behavior/effect]
// Initializes an addon project with the correct template files.
program
  .command('init [type]')
  .description("Initialize an addon project. Possible types: plugin, behavior, effect")
  .action(function(type) {

  });

// > crank build
// Compiles the current plugin into a .c2addon file.
program
  .command('build')
  .description("Build the current project into a .c2addon file.")
  .action(function() {

  });

// > crank watch
// Watches project files for any changes and copies them to %AppData%\Construct2\plugins\<pluginid>
// for quick previewing. Only available on Windows.
program
  .command('watch')
  .description("Watch files and update the addon in C2 on changes. Windows-only.")
  .action(function() {
    wincheck();

  });

// > crank devmode
// Toggle Construct 2 developer mode on or off. Modifies the required Windows registry value.
program
  .command('devmode')
  .description("Toggle C2 developer mode on or off. Windows-only.")
  .action(function() {
    wincheck();

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

  });

program.parse(process.argv);

function wincheck() {
  if(!windows) {
    console.log("This command is not available on non-Windows platforms.");
    process.exit(1);
  }
}