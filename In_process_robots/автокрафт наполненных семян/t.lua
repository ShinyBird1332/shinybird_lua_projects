local comp = require("component") 
local sides = require("sides")

local trans = comp.transposer

local side = sides.north

for i = 1, trans.getInventorySize(side) do
    
    item = trans.getStackInSlot(side, i)
    if item then
        print"(===================)"
        for key, value in pairs(item) do
            print(key, value)
        end
    end
end
