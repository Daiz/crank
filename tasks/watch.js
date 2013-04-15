/*jshint node:true */

var fs       = require('fs'),
    wrench   = require('wrench'),
    chokidar = require('chokidar'),
    builder  = require('xmlbuilder'),
    genset   = require('../lib/settings');

module.exports = function(addon, dir) {

  if(process.platform !== "win32") {
    console.log("This command is not available on non-Windows platforms.");
    process.exit(1);
  }

  // set the target directory
  dir += "Construct2\\"+ addon.type + "s";

  if(addon.type !== "effect") {
    dir += "\\" + addon.id;
  }

  // create plugin directory if it doesn't exist
  if(!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }

  // copy our files over to appdata
  //wrench.copyDirSyncRecursive('./src', dir);

  // function to run on file addition / change
  function action(path) {
    var targetPath = path.replace(/src(\/|\\)/,'');
    var file = fs.readFileSync(path, "utf8");
    var restart = false;

    if(path.match("edittime.js")) {
      file = genset(addon) + file;
      restart = true;
    } else
    if(path.match("runtime.js")) {
      file = fs.readFileSync(path, "utf8");
      file = file.replace(/AddonId/g,addon.id);
    } else
    if(path.match("common.js")) {
      restart = true;
    }
    fs.writeFileSync(dir + "\\" + targetPath, file);

    if(restart) {
      console.log(path, "has been updated. Restart Construct 2 for changes to take effect.");
    } else {
      console.log(path, "has been updated.");
    }
  }

  // create our file watcher and make it do its thing
  var watcher = chokidar.watch('./src', {persistent: true});

  watcher.on('add', action);
  watcher.on('change', action);

  console.log("Waiting for changes. Press Ctrl+C to stop.");
  watcher.close();

};