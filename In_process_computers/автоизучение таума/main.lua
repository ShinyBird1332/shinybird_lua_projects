--Research Notes
--Discovery

local comp = require("component")
local sides = require("sides")
local tunnel = comp.tunnel
local trans = comp.transposer
local book = comp.blockknowledgebook

local side_chest_in = sides.south
local side_chest_out = sides.west

function scan_chest_in()
    for i = 1, trans.getInventorySize(side_chest_in) do
        local slot = trans.getStackInSlot(side_chest_in, i)
        if slot and slot.label == "Research Notes" then
            print("Начинаем изучение свитка...")
            print("==========")
            trans.transferItem(side_chest_in, side_chest_out, 1, i, i)
            os.sleep(1)
            scan_book()
            tunnel.send("grab", 1)
        end
    end
end

function scan_book()
    while true do
        print("Осталось:")
        local res = 0
        for _, value in pairs(book.getAspects()) do 
            
            local count = book.getAspectCount(value) 
            print(value .. ": " .. count)
            res = res + count
        end
        print("==========")
        os.sleep(5)
        if res == 0 then 
            print("++")
            break
        end
    end
end

function main()
    while true do
        scan_chest_in()
    end
end

main()
