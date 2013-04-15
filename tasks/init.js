
var path   = require('path'),
    wrench = require('wrench'),
    cwd    = process.cwd();

module.exports = function(type) {

  switch(type) {
    case "plugin":
      wrench.copyDirSyncRecursive(path.resolve(__dirname, "../js/templates/plugin"), cwd);
      console.log("Initialized a new plugin project.");
      break;
    case "behavior":
      wrench.copyDirSyncRecursive(path.resolve(__dirname, "../js/templates/behavior"), cwd);
      console.log("Initialized a new behavior project.");
      break;
    case "effect":
      wrench.copyDirSyncRecursive(path.resolve(__dirname, "../js/templates/effect"), cwd);
      console.log("Initialized a new effect project.");
      break;
    default:
      console.log("Invalid or no project type was specified.");
      break;
  }

};