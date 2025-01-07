local backend = {}

local constants = dofile("constants.lua")

pressed_buttons = {
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "EEPROM (Lua BIOS)",
    "Inventory Upgrade",
    "Graphics Card (Tier 1)"}


function backend.start_assembling(buttons)
    print("Начало сборки...")
    for _, btn in ipairs(buttons) do
        if btn.button_pressed then
            table.insert(pressed_buttons, btn.name_craft)
        end
    end
    main(pressed_buttons)
end

function get_component_level(item_label)
    local required_components = {
        ["Screen (Tier 1)"] = 1,
        ["Disk Drive"] = 1,
        ["Keyboard"] = 1,
        ["Inventory Upgrade"] = 1
    }

    if required_components[item_label] then
        return required_components[item_label]
    end

    for _, component in ipairs(constants.choise_components) do
        if component.name_craft == item_label then
            return component.tier or 1
        end
    end

    return 1
end

function sort_components_by_level()
    local components = {}

    for i = 1, constants.trans_1.getInventorySize(constants.side_trans) do
        local item = constants.trans_1.getStackInSlot(constants.side_trans, i)
        if item then
            table.insert(components, {slot = i, item = item, level = get_component_level(item.label)})
        end
    end

    table.sort(components, function(a, b)
        return a.level > b.level
    end)

    return components
end

function move_assembler()
    print("Начало загрузки компонентов в сборщик...")

    local sorted_components = sort_components_by_level()

    -- Сначала загружаем системный блок
    for _, component in ipairs(sorted_components) do
        if component.item.label:find("Computer Case") then
            print("Загружаем основной компонент: " .. component.item.label)
            constants.trans.transferItem(constants.side_trans, constants.side_trans_out_ass, 1, component.slot, component.slot)
            break
        end
    end

    -- Затем загружаем остальные компоненты в порядке уровня
    for _, component in ipairs(sorted_components) do
        print("Загружаем дополнительный компонент: " .. component.item.label)
        constants.trans.transferItem(constants.side_trans, constants.side_trans_out_ass, 1, component.slot, component.slot)    
        os.sleep(1)
    end
    print("Все компоненты успешно загружены в сборщик.")
    os.sleep(2)
    constants.assembler.start()
end


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
    print("Предмет не найден!")
    return false
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

function count_items_in_chest(item_name)
    local res = 0
    for i = 1, constants.trans_1.getInventorySize(constants.side_trans) do
        item = constants.trans_1.getStackInSlot(constants.side_trans, i)
        if item and item.label == item_name then
            res = res + 1
        end
        if res > 1 then
            print("Удаление лишних предметов.")
            constants.trans_1.transferItem(constants.side_trans, constants.side_trans_out_trash, res - 1, i, i)
        end
    end
    return res
end

function main(components)
    for _, j in pairs(components) do
        print(j)
    end
    for _, item in ipairs(components) do
        start_autocraft(item) 
        
        if store_item_in_database(item) then
            export_limited_items(item)
        end
    end
    move_assembler()
end

return backend