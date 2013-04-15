/*jshint node:true */

function GetPluginSettings() {
  return {
    "name":        $name,
    "id":          $id,
    "version":     $version,
    "description": $description,
    "author":      $author,
    "help url":    $documentation,
    "category":    $category,
    "type":        $plugin.type,
    "rotatable":   $plugin.rotatable,
    "flags": 0
      | $plugin.flags.pf_singleglobal
      | $plugin.flags.pf_texture
      | $plugin.flags.pf_position_aces
      | $plugin.flags.pf_size_aces
      | $plugin.flags.pf_angle_aces
      | $plugin.flags.pf_appearance_aces
      | $plugin.flags.pf_tiling
      | $plugin.flags.pf_animations
      | $plugin.flags.pf_zorder_aces
      | $plugin.flags.pf_nosize
      | $plugin.flags.pf_effects
      | $plugin.flags.pf_predraw
  };
}

function GetBehaviorSettings() {
  return {
    "name":        $name,
    "id":          $id,
    "version":     $version,
    "description": $description,
    "author":      $author,
    "help url":    $documentation,
    "category":    $category,
    "flags": 0
      | $behavior.flags.bf_onlyone
  };
}

// helper function for transforming the flags into desired form
function transform(flags) {
  for(var f in flags) {
    if(flags[f]) {
      flags[f] = f;
    } else {
      flags[f] = "0";
    }
  }
  return flags;
}

module.exports = function(data) {
  var type = data.type;

  // transform the flags to "| flag" if enabled
  var flags = data[type].flags;
  data[type].flags = transform(flags);

  // determine the function we need to generate
  var fn;
  switch(type) {
    case "plugin":
      fn = GetPluginSettings;
      break;
    case "behavior":
      fn = GetBehaviorSettings;
      break;
  }

  // first-class functions are awesome
  var str = fn.toString();

  // recursively parse the data object and replace accordingly
  (function replace(data, path) {
    for(var k in data) {
      var curpath = path + k;
      if(data[k] instanceof Object) {
        curpath += ".";
        replace(data[k], curpath);
      } else {
        var value = data[k];
        if(''+value === value && !path.match('flags')) {
          value = '"' + value + '"';
        }
        str = str.replace(curpath,value);
      }
    }
  })(data, '$');

  // warn about leftover variables and set them to null
  var matches = str.match(/\$[a-z0-9\.]+/g);
  if(matches) {
    console.log("Warning: Leftover variable(s) found: ", matches.join(","), "Setting value(s) to null.");
    str = str.replace(/\$[a-z0-9\.]+/g,"null");
  }

  // standardize linebreaks
  str = str.replace(/\r\n|\r/g,'\n') + '\n';

  return str;
};