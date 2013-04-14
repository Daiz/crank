/*jshint node:true */

var fs       = require('fs-extra'),
    wrench   = require('wrench'),
    chokidar = require('chokidar');

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
  wrench.copyDirSyncRecursive('./src', dir);
  console.log("Your addon files have been updated. Waiting for changes. Press Ctrl+C to stop.");

  // function to run on file addition / change
  function action(path) {
    targetPath = path.replace(/src(\/|\\)/,'');

    // closure to make sure we get the correct path
    (function(path) {
      fs.copy(path, dir + "\\" + targetPath, function(err) {
        if(err) {
          console.error(err);
        } else {
          if(path.match(/common\.js|edittime\.js/)) {
            console.log(path, "has been updated. Restart Construct 2 for changes to take effect.");
          } else {
            console.log(path, "has been updated.");
          }
        }
      });
    })(path);
  }

  // create our file watcher and make it do its thing
  var watcher = chokidar.watch('./src', {persistent: true, ignoreInitial: true});

  watcher.on('add', action);
  watcher.on('change', action);

  watcher.close();

};