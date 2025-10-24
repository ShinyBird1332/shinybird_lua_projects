local comp = require("component") 
local sides = require("sides")

local trans = comp.transposer

local side = sides.north

for i = 1, trans.getInventorySize(side) do
    item = trans.getStackInSlot(side, i)
    if item then
        item = trans.getStackInSlot(side, i).label
        print(item)
    end
end

-- Reactor Casing