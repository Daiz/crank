/*jshint node:true */

var fs = require('fs'),
    settings = require('./settings');

var appdata = process.env.APPDATA + "\\Construct2\\";

var addon = {}, ret;

var rets = {
  normal: function(file, path) {
    return file;
  },
  write: function(file, path) {
    var targetPath = appdata + addon.type + "s";
    targetPath += (addon.type === "effect" ? "" : "\\" + addon.id + "\\");
    targetPath += path.replace(/src(\\|\/)/,'');
    fs.writeFileSync(targetPath, file);
  },
  all: function() {

  }
};

var operations = {
  file: function(path) {
    var file, text = false;

    // load the file
    if(path.match(/\.js|\.coffee|\.html?|\.css/)) {
      file = fs.readFileSync(path, "utf8");
      text = true;
    } else {
      file = fs.readFileSync(path);
    }

    // processing for special files
    if(text) {
      if(path.match(/edittime\.js/)) {
        file = settings(addon) + file;
      } else
      if(path.match(/runtime\.js/)) {
        file = file.replace(/AddonId/g,addon.id);
      }
    }

    // run the current return operation
    ret(file, path);

  }
};

module.exports = function(json, mode) {
  ret = rets[mode];
  addon = json;
  return operations;
};

