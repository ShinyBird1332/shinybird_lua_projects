local comp = require("component") 
local sides = require("sides")

local trans = comp.transposer

local side = sides.north

local item = trans.getStackInSlot(side, 1)
print(item.name) -- ID предмета
print(item.hasTag) -- Проверка, есть ли NBT
print(item.tag)


function t()
    for i = 1, trans.getInventorySize(side) do
        item = trans.getStackInSlot(side, i)
        if item then
            item = trans.getStackInSlot(side, i).label
            print(item)
        end
    end
end

-- Reactor Casing