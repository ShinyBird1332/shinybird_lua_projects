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
"Computer Case (Tier 3)", 

"Battery Upgrade (Tier 3)", 
"Crafting Upgrade", 
"Inventory Controller Upgrade", --
"Trading Upgrade",
"Screen (Tier 1)", 
"Disk Drive", 
"Keyboard", 
"EEPROM (Lua BIOS)"}

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
    while true do
        local status, _ = assembler.status()

        if status == "idle" then
            print(status)
            tunnel.send("robot_grab_robot", 1)
            os.sleep(10)
            assembler.start()
            return true
        end
    end
end


function main()
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
    tunnel.send("robot_move_grab", 1)
    monitor_assembler_status()
end

main()
