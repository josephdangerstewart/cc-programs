local Classy = require("classy.Classy")

local TestBase = Classy:extend()
local TestSub = TestBase:extend()

print("sub is base", TestSub:isType(TestBase))
print("base is sub", TestBase:isType(TestSub))
print("sub is classy", TestSub:isType(Classy))
print("base is classy", TestSub:isType(Classy))

local baseInst = TestBase:new();

local subInst = TestSub:new();

print("sub inst is base", subInst:isType(TestBase))
print("base inst is sub", baseInst:isType(TestSub))
print("sub inst is classy", subInst:isType(Classy))
print("base inst is classy", baseInst:isType(Classy))
