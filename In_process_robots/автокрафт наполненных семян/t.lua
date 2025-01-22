local comp = require("component") 
local sides = require("sides")

local trans = comp.transposer

local side = sides.north 

-- Предположим, у нас есть переменная 'item' — объект предмета
local item = trans.compareStacks(side, 1, 2)
print(item)