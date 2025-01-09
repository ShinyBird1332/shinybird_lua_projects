-- powered by ShinyBird368
local com = require("component")
local sides = require("sides")
local term = require("term")
local filesystem = require("filesystem")
local serialization = require("serialization")
local event = require("event")
local shell = require("shell")
local currentDir = shell.getWorkingDirectory()
local Path = filesystem.concat(currentDir, "config.lua")
local trans_list = dofile(Path)

local SIDE_IN = sides.east
local SIDE_OUT = sides.west

local trans_main = com.proxy("cb95a9f4-f2e8-43a0-a7ce-8196fe376929")

function transfer(side_in, side_out, stack, transposer, count)
    count = count or _
    for i = 1, transposer.getInventorySize(side_out) do
        local temp = transposer.transferItem(side_in, side_out, count, stack, i)
        if temp > 0 then
            break
        else
            goto continue
        end
        ::continue::
    end
end

function check_order2()
    for slot = 1, trans_main.getInventorySize(SIDE_IN) do
        if trans_main.getStackInSlot(SIDE_IN, slot) then
            local current_item = trans_main.getStackInSlot(SIDE_IN, slot).label

            for i = 1, #trans_list do
                local name_slot_item = trans_list[i][1]
                local name_trans = com.proxy(trans_list[i][2])
                local fluid_cost = trans_list[i][3]
                local count = 0
        
                if current_item == name_slot_item then
                    local c = trans_main.transferItem(SIDE_IN, SIDE_OUT, 64, slot, slot)
                    count = count + c
                end
               
                print("Заказ: ", count, name_slot_item)
                transfer_fluid(count, name_trans, fluid_cost)
            end
        end
    end
end

function check_order()
    for i = 1, #trans_list do
        local name_slot_item = trans_list[i][1]
        local name_trans = com.proxy(trans_list[i][2])
        local fluid_cost = trans_list[i][3]
        local count = 0

        for slot = 1, trans_main.getInventorySize(SIDE_IN) do
            if trans_main.getStackInSlot(SIDE_IN, slot) then
                local current_item = trans_main.getStackInSlot(SIDE_IN, slot).label

                if current_item == name_slot_item then
                    local c = trans_main.transferItem(SIDE_IN, SIDE_OUT, 64, slot, slot)
                    count = count + c
                end
            end
        end
        print("Заказ: ", count, name_slot_item)
        transfer_fluid(count, name_trans, fluid_cost)
    end
end

function transfer_fluid(count, name_trans, fluid_cost)
    local g = count * fluid_cost 
    local result = 0
    print("Стоимость в материи", g, "mb")
    while result < g do
        local _, c = name_trans.transferFluid(SIDE_IN, SIDE_OUT, g - result)
        result = result + c
        print("Перенесено", result, "mb.", "Не хватает", g - result, "mb.")
        os.sleep(5)
    end
end

function add_to_config(item, trans_id, fluid_cost)
    table.insert(trans_list, {item, trans_id, fluid_cost})
    save_config()
end

function save_config()
    local file = io.open(Path, "w")
    file:write("return " .. serialization.serialize(trans_list))
    file:close()
end

function add_new_item()
    term.clear()
    print("Добавление нового предмета:")
    io.write("Название предмета: ")
    local item = io.read()
    io.write("ID транспозера: ")
    local trans_id = io.read()
    io.write("Стоимость материи: ")
    local fluid_cost = tonumber(io.read())

    add_to_config(item, trans_id, fluid_cost)
    print("Предмет добавлен!")
end

function draw_interface()
    term.clear()
    print("1. Добавить новый предмет")
    print("2. Выход")
    print("Для выбора нажмите соответствующую цифру.")
end

local function handle_key_down(_, address, char, code, playerName)
    if char == string.byte('m') then
        if coroutine.status(input_thread) == "suspended" then
            coroutine.resume(input_thread)
        end
    end
end

local function input_menu()
    local running = true
    while running do
        draw_interface()
        local choice = io.read()
        if choice == "1" then
            add_new_item()
        elseif choice == "2" then
            running = false
        else
            print("Неверный выбор, попробуйте снова.")
        end
        os.sleep(1)
    end
end

-- Основной цикл программы
local function main()
    local running = true
    while running do
        input_thread = coroutine.create(input_menu)

        while running and coroutine.status(input_thread) ~= "dead" do
            event.listen("key_down", handle_key_down)

            local success, errorMsg = pcall(check_order)
            if not success then
                print("Ошибка при проверке заказов: ", errorMsg)
            end
            os.sleep(1) 
        end

        event.ignore("key_down", handle_key_down)

        if coroutine.status(input_thread) == "dead" then
            print("Возвращаемся к проверке заказов...")
        end
    end
end

main()
