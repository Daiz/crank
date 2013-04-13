/*jshint node:true */

var program = require('commander');

// > crank init [plugin/behavior/effect]
// Initializes an addon project with the correct template files.
program
  .command('init [type]')
  .description("Initialize an addon. Possible types: plugin, behavior, effect")
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
  .description("Watch project files for changes and update the addon in Construct 2.")
  .action(function() {

  });

// > crank devmode
// Toggle Construct 2 developer mode on or off. Modifies the required Windows registry value.
program
  .command('devmode')
  .description("Toggle Construct 2 developed mode on or off.")
  .action(function() {

  });

program.parse(process.argv);