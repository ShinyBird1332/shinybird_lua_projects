local comp = require("component") 
local sides = require("sides")
local trans = comp.transposer

-- Добавить прекрафт: излучатель уровня напротив красного контроллера, каждый контроллер закрепить за нужным предметом.

local side_input = sides.north
local side_output = sides.south
local side_craft_input = sides.east
local side_craft_output = sides.west

local time_sleep = 1.5
local dict_items = {"Redstone", "Glowstone Dust", "Nether Quartz", "Netherrack", "Coal", "Snowball", "Soul Sand", "Oak Leaves", "Grass"}
local size_chest = 243
size_chest = (size_chest - #dict_items) * 64

function check_order()
    for i = 1, #dict_items do
        local name_slot_item = dict_items[i]
        local count = 0

        for slot = 1, trans.getInventorySize(side_input) do
            if trans.getStackInSlot(side_input, slot) then
                local current_item = trans.getStackInSlot(side_input, slot).label

                if current_item == name_slot_item then
                    local c = trans.transferItem(side_input, side_output, 64, slot, slot)
                    count = count + c
                end
            end
        end
        if count > 0 then
            print("Заказ: ", count * 2, name_slot_item)
            craft(count * 2, i)
        end
    end
end

function craft(count, number_item)
    local res = 1
    local bool_clear = false
    while res < (count + 1) do
        res2 = trans.transferItem(side_craft_input, side_craft_output, 64, number_item, number_item)
        os.sleep(time_sleep)

        res = res + res2

        print("Выполнено ", res)
        if res > size_chest and bool_clear == false then
            clear(number_item)
            bool_clear = true
        end
    end
    clear(number_item)
end

function clear(number_item)
    os.sleep(2)
    local count = trans.getSlotStackSize(side_craft_input, number_item)
    trans.transferItem(side_craft_input, side_output, count - 1, number_item, 1)
    
    for i = 10, trans.getInventorySize(side_craft_input) do
        trans.transferItem(side_craft_input, side_output, _, i, i)
    end
    print("Завершено")
end

function main()
    while true do
        check_order()
    end
end

main()
