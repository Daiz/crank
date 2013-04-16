# PARAMETER TYPES
#
# AddNumberParam  label, description [, initial_string = '0']
# AddStringParam  label, description [, initial_string = '""']
# AddAnyTypeParam label, description [, initial_string = '0'] # number or string
#
# AddCmpParam     label, description # combo with equal, not equal, less, etc.
#
# AddComboParamOption text # repeat before 'AddComboParam' to add combo items
# AddComboParam label, description [, initial_selection = 0] # dropdown list
#
# AddObjectParam label, description   # button to click and pick an object
# AddLayerParam  label, description   # accepts a layer number or name (string)
# AddLayoutParam label, description   # dropdown list with all project layouts
# AddKeybParam   label, description   # button to click and press a key
#
# AddAnimationParam label, description # string for specifying an animation name
# AddAudioFileParam label, description # dropdown list with project audio files

# CONDITIONS
#
# AddCondition id   # any positive integer to uniquely identify this condition
#   , flags         # (see docs) cf_none, cf_trigger, cf_fake_trigger,
#                   # cf_static, cf_not_invertible, cf_deprecated,
#                   # cf_incompatible_with_triggers, cf_looping
#   , list_name     # appears in event wizard list
#   , category      # category in event wizard list
#   , display_str   # as appears in event sheet - use {n} for parameters,
#                   # also supports <b>bold</b> and <i>italics</i>
#   , description   # appears in event wizard dialog when selected
#   , script_name   # corresponding runtime function name

# Example Condition
AddNumberParam "Number"
  , "Enter a number to test if positive."
AddCondition 0
  , cf_none
  , "Is number positive"
  , "My category"
  , "{0} is positive"
  , "Description for my condition!"
  , "PositiveNumber"

# ACTIONS
#
# AddAction id      # any positive integer to uniquely identify this action
#   , flags         # (see docs) af_none, af_deprecated
#   , list_name     # appears in event wizard list
#   , category      # category in event wizard list
#   , display_str   # as appears in event sheet - use {n} for parameters,
#                   # also supports <b>bold</b> and <i>italics</i>
#   , description   # appears in event wizard dialog when selected
#   , script_name   # corresponding runtime function name

# Example Action
AddStringParam "Message"
  , "Enter a string to alert."
AddAction 0
  , af_none
  , "Alert"
  , "My category"
  , "Alert {0}"
  , "Description for my action!"
  , "Alert"

# EXPRESSIONS
#
# AddExpression id  # any positive integer to uniquely identify this expression
#   , flags         # (see docs) ef_none, ef_deprecated, ef_return_number,
#                   # ef_return_string, ef_return_any, ef_variadic_parameters*
#                   # (* one return flag must be specified)
#   , list_name     # currently ignored, but set as if appeared in event wizard
#   , category      # category in expressions panel
#   , exp_name      # the expression name after the dot, eg. "foo" for "obj.foo"
#                   # also the runtime function name.
#   , description   # description in expressions panel

# Example Expression
AddExpression 0
  , ef_return_number
  , "Elite expression"
  , "My category"
  , "Elite"
  , "Return the number 1337."

# No more ACE definitions after this
ACESDone()

# PROPERTY TYPES
# 
# new cr.Property ept_integer, name, initial_value, description
# new cr.Property ept_float,   name, initial_value, description
# new cr.Property ept_text,    name, initial_value, description
# new cr.Property ept_color,   name, initial_value, description
# new cr.Property ept_font     name, "Arial,-16",   description
# new cr.Property ept_combo    name, "a",           description, "a|b|c"
# new cr.Property ept_link     name, link_text,     description, "firstonly"
#
# Font's initial value format is "Font Face, Font Size"
# Dropdown list (Combo) takes a string of an option as the initial value,
# and the options are listed after the description in a string like "opt1|opt2"
# Link has no associated value, simply calls "OnPropertyChanged" on click
#
# The properties are set in the following array
property_list = [
  new cr.Property ept_integer, "My Number",    12, "A number property."
  new cr.Property ept_string,  "My String", "foo", "A string property."
]

# Called by IDE when a new object type is to be created
CreateIDEObjectType = ->
  new IDEObjectType()

# Class representing an object type in the IDE
IDEObjectType = ->
  assert2 this instanceof arguments.callee, "Constructor called as a function"

# Called by IDE when a new object instance of this type is to be created
IDEObjectType.prototype.CreateInstance = (instance) ->
  new IDEInstance(instance)

# Class representing an individual instance of an object in the IDE
IDEInstance = (instance, type) ->
  assert2 this instanceof arguments.callee, "Constructor called as a function"

  # Save the constructor parameters
  this.instance = instance
  this.type = type

  # Set the default property values from the property table
  this.properties = {}

  for property in property_list
    this.properties[property.name] = property.initial_value

  # Plugin-specific variables, eg...
  # this.myValue = 0

  return # CoffeeScript has implicit return - empty return clears it

IDEInstance.prototype =
  OnInserted: ->
    # Called when inserted via Insert Object Dialog for the first time
  OnDoubleClicked: ->
    # Called when double clicked in layouts
  OnPropertyChanged: (property_name) ->
    # Called after a property has been changed in the properties bar
  OnRendererInit: (renderer) ->
    # For rendered objects to load fonts or textures
  Draw: (renderer) ->
    # Called to draw self in the editor if a layout object
  OnRendererReleased: (renderer) ->
    # For rendered objects to release fonts or textures