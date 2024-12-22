local backend = {}

local constants = dofile("constants.lua")

pressed_buttons = {
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "EEPROM (Lua BIOS)",
    "Inventory Controller Upgrade",
    "Inventory Upgrade",
    "Graphics Card (Tier 1)"}

function check_item_in_me(item_name)
    local items = constants.me_interface.getItemsInNetwork()
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

    local craftables = constants.me_interface.getCraftables()
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
    local items = constants.me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name then
            print("Предмет найден: " .. item.label)
            constants.database.clear(constants.db_slot)
            constants.me_interface.store(item, constants.database.address, constants.db_slot)
            print("Предмет " .. item.label .. " записан в базу данных!")
            return true
        end
    end
    print("Предмет  " .. item.label .. "  не найден!")
    return false
end

function count_items_in_chest(item_name)
    local res = 0
    for i = 1, constants.trans.getInventorySize(constants.side_trans) do
        item = constants.trans.getStackInSlot(constants.side_trans, i)
        if item and item.label == item_name then
            res = res + 1
        end
    end
    return res
end

function export_limited_items(item_name)
    local transferred = 0

    while transferred < 1 do
        local success = constants.me_exportbus.setExportConfiguration(constants.side_me_bus, constants.me_bus_slot, constants.database.address, constants.db_slot)
        if not success then
            print("Ошибка настройки шины!")
            return false
        end

        os.sleep(0.3)

        transferred = count_items_in_chest(item_name)
        print("Передано предметов: " .. transferred .. " из " .. 1)
    end

    constants.me_exportbus.setExportConfiguration(constants.side_me_bus, constants.me_bus_slot, constants.database.address, constants.db_slot+1)
    print("Предмет  " .. item_name .. "  успешно передан!")
    return true
end

function monitor_assembler_status()
    constants.assembler.start()
    while true do
        local status, _ = constants.assembler.status()

        if status == "idle" then
            print(status)
            constants.tunnel.send("robot_grab_robot", 1)
            os.sleep(10)
            
            return true
        end
    end
end

function main(pressed_buttons)
    constants.tunnel.send("robot_move_me_bus_export", 1)
    os.sleep(3)
    for _, item in ipairs(pressed_buttons) do
        start_autocraft(item) 

        if store_item_in_database(item) then
            export_limited_items(item)
        end
    end
    constants.tunnel.send("robot_move_trash", 1)
    os.sleep(10)
    constants.tunnel.send("robot_move_assembler", 1)
    os.sleep(15)
    constants.tunnel.send("robot_move_grab", 1)
    os.sleep(10)
    monitor_assembler_status()
end

function backend.start_assembling(buttons)
    print("Начало сборки...")
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