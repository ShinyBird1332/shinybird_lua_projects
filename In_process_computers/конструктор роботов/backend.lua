local backend = {}

local component = require("component")
local event = require("event")
local unicode = require("unicode")
local term = require("term")
local sides = require("sides")
local gpu = component.gpu
local me_exportbus = component.me_exportbus
local me_interface = component.me_interface
local database = component.database
local trans = component.transposer
local tunnel = component.tunnel
local assembler = component.assembler

local side_trans = sides.north
local side_me_bus = sides.down 
local db_slot = 1 
local me_bus_slot = 1 

pressed_buttons = {
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "EEPROM (Lua BIOS)",
    "Inventory Controller Upgrade"}

function check_item_in_me(item_name)
    local items = me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name and item.size > 0 then
            print("\nПредмет найден в МЭ: " .. item_name .. " - " .. item.size .. " штук")
            return true
        end
    end
    return false
end

function start_autocraft(item_name)
    if check_item_in_me(item_name) then
        print("Крафт не требуется. Предмет уже есть: " .. item_name)
        return true
    end

    local craftables = me_interface.getCraftables()
    if not craftables then
        print("Ошибка: нет доступных шаблонов для крафта.")
        return false
    end

    for _, craftable in ipairs(craftables) do
        local item = craftable.getItemStack()
        if item.label == item_name then
            print("Шаблон найден. Запуск автокрафта для: " .. item_name)
            local request = craftable.request(1)

            if request.isCanceled() then
                print("Ошибка: автокрафт отменён. Недостаточно ресурсов.")
                return false
            end

            print("Ожидание завершения крафта...")
            while not request.isDone() do
                os.sleep(1)
                print("...")
            end

            print("Автокрафт завершён для: " .. item_name)
            return true
        end
    end

    print("Ошибка: не найден шаблон для: " .. item_name)
    return false
end

function store_item_in_database(item_name)
    local items = me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name then
            print("Предмет найден: " .. item.label)
            database.clear(db_slot)
            me_interface.store(item, database.address, db_slot)
            print("Предмет " .. item.label .. " записан в базу данных!")
            return true
        end
    end
    print("Предмет  " .. item.label .. "  не найден!")
    return false
end

function count_items_in_chest(item_name)
    local res = 0
    for i = 1, trans.getInventorySize(side_trans) do
        item = trans.getStackInSlot(side_trans, i)
        if item and item.label == item_name then
            res = res + 1
        end
    end
    return res
end

function export_limited_items(item_name)
    local transferred = 0

    while transferred < 1 do
        local success = me_exportbus.setExportConfiguration(side_me_bus, me_bus_slot, database.address, db_slot)
        if not success then
            print("Ошибка настройки шины!")
            return false
        end

        os.sleep(0.3)

        transferred = count_items_in_chest(item_name)
        print("Передано предметов: " .. transferred .. " из " .. 1)
    end

    me_exportbus.setExportConfiguration(side_me_bus, me_bus_slot, database.address, db_slot+1)
    print("Предмет  " .. item_name .. "  успешно передан!")
    return true
end

function monitor_assembler_status()
    assembler.start()
    while true do
        local status, _ = assembler.status()

        if status == "idle" then
            print(status)
            tunnel.send("robot_grab_robot", 1)
            os.sleep(10)
            
            return true
        end
    end
end

function main(pressed_buttons)
    tunnel.send("robot_move_me_bus_export", 1)
    os.sleep(3)
    for _, item in ipairs(pressed_buttons) do
        start_autocraft(item) 

        if store_item_in_database(item) then
            export_limited_items(item)
        end
    end
    tunnel.send("robot_move_trash", 1)
    os.sleep(10)
    tunnel.send("robot_move_assembler", 1)
    os.sleep(15)
    tunnel.send("robot_move_grab", 1)
    os.sleep(10)
    monitor_assembler_status()
end

function backend.start_assembling(buttons)
    print("Начало сборки...")
    pressed_buttons = {}
    for _, btn in ipairs(buttons) do
        if btn.button_pressed then
            table.insert(pressed_buttons, btn.name_craft)
        end
    end
    main(pressed_buttons)
end

function backend.clear_components()
    for _, btn in ipairs(buttons) do
        btn.button_pressed = false
    end
    draw_buttons()
    max_difficulty = 0
end

return backend