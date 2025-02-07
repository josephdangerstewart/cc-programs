# Classy

A lightweight understandable class system for Lua that supports multiple inheritance.

## Usage

```lua
local Classy = require("Classy")

-- :extend returns a new class, derived from Classy
local FooClass = Classy:extend()

-- Add instance methods like so
function FooClass:barInstanceMethod()
	print("FooClass logic")
end

-- classes can be further derived through more :extend
local BazClass = FooClass:extend()

-- optional init method is called when a class is instantiated
function BazClass:init(param1, param2)
	-- You *must* invoke the super class init
	self.super:init()

	-- Initialize instance properties in the init
	-- using the initProperties method
	self:initProperties({
		property1 = "some property",
		param1 = param1,
		param2 = param2
	})
end

-- Add new instance methods or extend methods on the super class
function BazClass:barInstanceMethod()
	-- self.super gives you access to methods on the super class
	-- invoking overloaded methods on the super class is not required (only
	-- for the init)
	self.super:barInstanceMethod()
	print("BazClass logic")
end

-- Instantiate classes with the static :new method
local bazInstance = BazClass:new("param 1", "param 2")

-- This will print "FooClass logic" and then "BazClass logic"
bazInstance:barInstanceMethod()
```

## Class methods

* `isType(class): boolean` - returns true if the Class is equal to or derives from `class`
* `new(...)` - Constructs a new instance of the Class
* `extend(staticProperties)` - Creates a new derived class. Optionally pass in some static properties.

## Instance methods

* `isType(class): boolean` - returns true if the instance is an direct instance of the class or one of it's derived classes.

## Type checking

```lua
local Classy = require("classy.Classy")

local TestBase = Classy:extend()
local TestSub = TestBase:extend()

print("sub is base", TestSub:isType(TestBase))  -- True
print("base is sub", TestBase:isType(TestSub))  -- False
print("sub is classy", TestSub:isType(Classy))  -- True
print("base is classy", TestSub:isType(Classy)) -- True

local baseInst = TestBase:new();

local subInst = TestSub:new();

print("sub inst is base", subInst:isType(TestBase))   -- True
print("base inst is sub", baseInst:isType(TestSub))   -- False
print("sub inst is classy", subInst:isType(Classy))   -- True
print("base inst is classy", baseInst:isType(Classy)) -- True
```
