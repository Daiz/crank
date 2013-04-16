# ECMAScript 5 strict mode
"use strict"

assert2 cr         , "cr namespace not created"
assert2 cr.plugins_, "cr.plugins_ not created"

cr.plugins_.AddonId = (runtime) ->
  this.runtime = runtime

do ->

  pluginProto = cr.plugins_.AddonId.prototype

  # Object type class
  pluginProto.Type = (plugin) ->
    this.plugin = plugin
    this.runtime = plugin.runtime

  typeProto = pluginProto.Type.prototype

  # Called on startup for each object type
  typeProto.onCreate = ->
    # code goes here

  # Instance class
  pluginProto.Instance = (type) ->
    this.type = type
    this.runtime = type.runtime

    # Any other properties you need, eg...
    # this.myValue = 0

  instanceProto = pluginProto.Instance.prototype =

    onCreate: ->
      # Called whenever an instance is created.
      # Note the object is sealed after this call; 
      # ensure any properties you'll ever need are set on the object,
      # eg...
      # this.myValue = 0

    onDestroy: ->
      # Called whenever an instance is destroyed.
      # Note the runtime may keep the object after this call
      # for recycling; be sure to release/recycle/reset any
      # references to other objects in this function.
  
    saveToJSON: ->
      # Called when saving the full state of the game.
      # Return a JavaScript object containing information about
      # your object's state. Note you MUST uuse double-quote syntax
      # (eg. "property": value) to prevent Closure Compiler renaming
      # and breaking the save format.
      return {
        # eg.
        # "myValue": this.myValue
      }
  
    loadFromJSON: (o) ->
      # Called when loading the full state of the game.
      # Load from the state previously saved by saveToJSON
      # 'o' provides the same object that you saved, eg.
      # this.myValue = o["myValue"]
      # Note you MUST use double-quote syntax (eg. o["property"]) to
      # prevent Closure Compiler renaming and breaking the save format.
  
    draw: (ctx) ->
      # Only called if a layout object - draw to a canvas 2D context.
  
    drawGL: (glw) ->
      # Only called if a layout object - draw to the WebGL context.
      # 'glw' is not a WebGL context, it's a wrapper - you can
      # find its methods in GLWrap.js in the install directory,
      # or you can just copy what other plugins do.

  # CONDITIONS
  Cnds = ->

  # Example Conditions
  Cnds.prototype =

    PositiveNumber: (param) ->
      # Return true if number is positive
      return myparam >= 0

    NegativeNumber: (param) ->
      # Return true if number is negative
      return myparam < 0

    # ... other conditions here ...

  pluginProto.cnds = new Cnds()

  # ACTIONS
  Acts = ->

  # Example Actions
  Acts.prototype =

    Alert: (param) ->
      # Alert the message
      alert param

    Log: (param) ->
      # Log to console
      console.log param

    # ... other actions here ...

  pluginProto.acts = new Acts()

  # EXPRESSIONS
  Exps = ->

  # Example Expressions
  Exps.prototype =
    # 'ret' must always be the first parameter -
    # always return the expression's result through it!
    Elite: (ret) ->
      ret.set_int(1337)         # Return our value
      # ret.set_float(0.5)      # For returning floats
      # ret.set_string("Hello") # For ef_return_string
      # ret.set_any("World")    # For ef_return_any, number or set_string

    HelloWorld: (ret) ->
      ret.set_string("Hello World!")

    # ... other expressions here ...

  pluginProto.exps = new Exps()