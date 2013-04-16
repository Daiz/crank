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
#                   # also supports <b>bold</b> and <i>italics</i>,
#                   # and {my} for the current behavior icon & name
#   , description   # appears in event wizard dialog when selected
#   , script_name   # corresponding runtime function name

# Example Condition
AddCondition 0
  , cf_none
  , "Is moving"
  , "My category"
  , "{my} is moving"
  , "Description for my condition!"
  , "IsMoving"

# ACTIONS
#
# AddAction id      # any positive integer to uniquely identify this action
#   , flags         # (see docs) af_none, af_deprecated
#   , list_name     # appears in event wizard list
#   , category      # category in event wizard list
#   , display_str   # as appears in event sheet - use {n} for parameters,
#                   # also supports <b>bold</b> and <i>italics</i>
#                   # and {my} for the current behavior icon & name
#   , description   # appears in event wizard dialog when selected
#   , script_name   # corresponding runtime function name

# Example Action
AddAction 0
  , af_none
  , "Stop"
  , "My category"
  , "Stop {my}"
  , "Description for my action!"
  , "Stop"

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
# new cr.Property ept_combo    name, "a",           description, "a|b|c"
#
# Dropdown list (Combo) takes a string of an option as the initial value,
# and the options are listed after the description in a string like "opt1|opt2"
#
# The properties are set in the following array
property_list = [
  new cr.Property ept_integer, "My Number",    12, "A number property."
  new cr.Property ept_string,  "My String", "foo", "A string property."
]

# Called by IDE when a new behavior type is to be created
CreateIDEBehaviorType = ->
  new IDEBehaviorType()

# Class representing a behavior type in the IDE
IDEBehaviorType = ->
  assert2 this instanceof arguments.callee, "Constructor called as a function"

# Called by IDE when a new object instance of this type is to be created
IDEBehaviorType.prototype.CreateInstance = (instance) ->
  new IDEInstance(instance, this)

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

  # Behavior-specific variables, eg...
  # this.myValue = 0

  return # CoffeeScript has implicit return - empty return clears it

IDEInstance.prototype =
  OnCreate: () ->
    # Called by the IDE after initialization on this instance has been completed
  OnPropertyChanged: (property_name) ->
    # Called by the IDE after a property has been changed