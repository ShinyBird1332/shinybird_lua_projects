local comp = require("component")
local sides = require("sides")
local trans = comp.transposer
local brew = comp.brewing_stand

--getBrewTime()

side_in = sides.south
side_out = sides.north

function transfer(side_in, side_out, stack, count)
    count = count or _
    for i = 1, trans.getInventorySize(side_out) do
        local temp = trans.transferItem(side_in, side_out, count, stack, i)
        if temp > 0 then
            break
        else
            goto continue
        end
        ::continue::
    end
end

function t()
    while true do
        old_time = brew.getBrewTime() 
        os.sleep(1)
        if brew.getBrewTime() == 0 and old_time ~= 0 then
            transfer(side_in, side_out, 1, 1)
        end
        if brew.getBrewTime() ~= 0 then
            c = brew.getBrewTime() / 391 * 100
            print("Осталось " .. c .. "%")
        end
    end
end

t()