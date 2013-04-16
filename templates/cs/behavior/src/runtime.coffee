# ECMAScript 5 strict mode
"use strict"

assert2 cr          , "cr namespace not created"
assert2 cr.behaviors, "cr.behaviors not created"

cr.behaviors.AddonId = (runtime) ->
  this.runtime = runtime

do ->

  pluginProto = cr.behaviors.AddonId.prototype

  # Behavior type class
  behaviorProto.Type = (behavior, objtype) ->
    this.behavior = behavior
    this.objtype = objtype
    this.runtime = behavior.runtime

  behtypeProto = behaviorProto.Type.prototype

  # Called on startup for each behavior type
  behtypeProto.onCreate = ->
    # code goes here

  # Behavior Instance class
  behaviorProto.Instance = (type, inst) ->
    this.type = type
    this.inst = inst # associated object instance to modify
    this.behavior = type.behavior
    this.runtime  = type.runtime

  behinstProto = behaviorProto.Instance.prototype =

    onCreate: ->
      # Called whenever an instance is created

      # Load properties
      this.myProperty = this.properties[0]

      # Note the object is sealed after this call; 
      # ensure any properties you'll ever need are created,
      # eg...
      # this.myValue = 0

    onDestroy: ->
      # Called when associated object is being destroyed.
      # Note runtime may keep the object and behavior alive after
      # this call for recycling; release, recycle or reset
      # any references here as necessary.
  
    saveToJSON: ->
      # Called when saving the full state of the game.
      # Return a JavaScript object containing information about
      # your behavior's state. Note you MUST use double-quote syntax
      # (eg. "property": value) to prevent Closure Compiler renaming
      # and breaking the save format.
      return {
        # eg.
        # "myValue": this.myValue
      }
  
    loadFromJSON: (o) ->
      # Called when loading the full state of the game.
      # Load from the state previously saved by saveToJSON.
      # 'o' provides the same object that you saved, eg.
      # this.myValue = o["myValue"]
      # Note you MUST use double-quote syntax (eg. o["property"]) to
      # prevent Closure Compiler renaming and breaking the save format.
  
    tick: ->
      # Called every tick for you to update this.inst as necessary.
      # dt is the amount of time passed since the last tick,
      # in case it's a movement

      dt = this.runtime.getDt this.inst

  # CONDITIONS
  Cnds = ->

  # Example Conditions
  Cnds.prototype =

    IsMoving: ->
      # See other behaviors for example implementations
      return false

    # ... other conditions here ...

  behaviorProto.cnds = new Cnds()

  # ACTIONS
  Acts = ->

  # Example Actions
  Acts.prototype =
    
    Stop: ->
      # See other bevahiors for example implementations

    # ... other actions here ...

  behaviorProto.acts = new Acts()

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

  behaviorProto.exps = new Exps()