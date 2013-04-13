/*jshint node:true */

var builder = require('xmlbuilder'),
    AdmZip  = require('adm-zip');


module.exports = function(addon) {
  
  // build the xml from addon.json
  var xml = builder.create("c2addon", {encoding: "UTF-8"});
  xml.com("One of: plugin, behavior, effect");
  xml.ele("type", addon.type);
  xml.ele("name", addon.name);
  xml.ele("version", addon.version);
  xml.ele("author", addon.author);
  xml.ele("website", addon.website);
  xml.ele("documentation", addon.documentation);
  xml.ele("description", addon.description);

  var type = addon.type;


};