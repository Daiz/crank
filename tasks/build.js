/*jshint node:true */

var builder = require('xmlbuilder'),
    fs      = require('fs'),
    wrench  = require('wrench'),
    zip     = new require('node-zip')();

module.exports = function(addon) {

  // build the xml from addon.json
  var xml = builder.create("c2addon", {version: "1.0", encoding: "UTF-8"});
  xml.com("One of: plugin, behavior, effect");
  xml.ele("type", addon.type);
  xml.ele("name", addon.name);
  xml.ele("version", addon.version);
  xml.ele("author", addon.author);
  xml.ele("website", addon.website);
  xml.ele("documentation", addon.documentation);
  xml.ele("description", addon.description);

  // read the contents of our src folder
  var filepaths = wrench.readdirSyncRecursive('./src');
  var filepath, write;

  // zip it up
  zip.file('info.xml', xml.end({pretty: true}));
  var folder = zip.folder('files' + (addon.type === "effect" ? '' : '/' + addon.id));
  for(var i = 0, ii = filepaths.length; i < ii; i++) {
    write = true;
    filepath = filepaths[i].replace(/\\/g,'/');
    if(!filepath.match(/\./)) {
      if(fs.lstatSync('./src/' + filepath).isDirectory()) {
        write = false;
      }
    }
    if(write) {
      folder.file(filepath, fs.readFileSync('./src/' + filepath, 'utf8'));
    }
  }
  folder.file('PluginIcon.ico', fs.readFileSync('./PluginIcon.ico', 'base64'), {base64: true});
  var data = zip.generate({base64: true, compression: 'STORE'});
  fs.writeFileSync(addon.id + '.c2addon', data, 'base64');

};