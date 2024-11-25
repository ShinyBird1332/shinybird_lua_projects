--powered by ShinyBird368
local comp = require("component") 
local trans = comp.transposer
local sides = require("sides")

local side_count = sides.north
local side_input = sides.west
local side_output = sides.east
local side_storage = sides.south
local count_details = 18

while true do
    chest_count = 1
    item = 1 
    sum = 0

    while chest_count ~= 0 do
        chest_count = trans.transferItem(side_count, side_output, _, item, item) 
        item = item + 1 
        sum = sum + chest_count
    end

    if sum ~= 0 then
        print("Получен заказ:", sum, " комплект(ов)") 
    end

    result = 0

    while result < sum * count_details do
        chest_result = trans.transferItem(side_input, side_output, _, 1, 1) 
        result = result + chest_result
        os.sleep(1)
    end

    i = 1
    while i < 4 do
        trans.transferItem(side_storage, side_output, sum, i, i)
        i = i + 1
    end

    if result ~= 0 then
        print("Успешно изготовлено!") 
    end

    os.sleep(3)
end