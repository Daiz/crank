/*jshint node:true */

// load npm modules
var program = require('commander'),
    fs      = require('fs');

// load our own modules
var init    = require('./tasks/init'),
    build   = require('./tasks/build'),
    watch   = require('./tasks/watch'),
    devmode = require('./tasks/devmode');

// set some shortcut variables
var cwd     = process.cwd(),
    appdata = process.env.APPDATA + "\\";

// relevant paths to check
var dir = [
  appdata + "Construct2",
  appdata + "Construct2\\plugins",
  appdata + "Construct2\\behaviors",
  appdata + "Construct2\\effects"
];

// platform check
var windows = (process.platform === 'win32');

// check if appdata folders exist and make them if not
if(windows) {
  for(var i = 0; i < 4; i++) {
    if(!fs.existsSync(dir[i])) {
      fs.mkdirSync(dir[i]);
    }
  }
}

// check for addon.json and load it if found
var addon;
if(fs.existsSync(cwd + '/addon.json')) {
  addon = require(cwd + '/addon.json');
}

// > crank init [plugin/behavior/effect]
// Initializes an addon project with the correct template files.
program
  .command('init [type]')
  .description("Initialize an addon project. Possible types: plugin, behavior, effect")
  .action(function(type) {
    if(addon && addon.type) {
      console.log("A project already exists in the current directory!");
      process.exit(1);
    } else {
      init(type);
    }
  });

// > crank build
// Compiles the current plugin into a .c2addon file.
program
  .command('build')
  .description("Build the current project into a .c2addon file.")
  .action(function() {
    if(!addon) {
      console.log("No project found. Aborting.");
      process.exit(1);
    } else {
      build(addon);
    }
  });

// > crank watch
// Watches project files for any changes and copies them to %AppData%\Construct2\plugins\<pluginid>
// for quick previewing. Only available on Windows.
program
  .command('watch')
  .description("Watch files and update the addon in C2 on changes. Windows-only.")
  .action(function() {
    if(!addon) {
      console.log("No project found. Aborting.");
      process.exit(1);
    } else {
      watch(addon, appdata);
    }

  });

// > crank devmode
// Toggle Construct 2 developer mode on or off. Modifies the required Windows registry value.
program
  .command('devmode')
  .description("Toggle C2 developer mode on or off. Windows-only.")
  .action(devmode);

program.parse(process.argv);