local comp = require("component") 
local sides = require("sides")

local trans = comp.transposer

local side = sides.north




function t()
    for i = 1, trans.getInventorySize(side) do
        item = trans.getStackInSlot(side, i)
        for k, v in pairs(item) do
            print(k, v)
        end
        print("+++++++++++++++++++")
    end
    
end

t()

-- Reactor Casing