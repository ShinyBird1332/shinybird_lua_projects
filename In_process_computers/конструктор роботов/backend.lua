local backend = {}

local component = require("component")
local event = require("event")
local event = require("unicode")
local term = require("term")
local sides = require("sides")
local gpu = component.gpu
local me_interface = component.me_interface
local me_exportbus = component.me_exportbus
local me_interface = component.me_interface
local database = component.database
local trans = component.transposer

local side_trans = sides.north
local side_me_bus = sides.west 
local db_slot = 1 
local me_bus_slot = 1 

pressed_buttons = {
"Computer Case (Tier 3)", 
"Battery Upgrade (Tier 3)", 
"Crafting Upgrade", 
"Inventory Controller Upgrade", 
"Trading Upgrade",
"Screen (Tier 1)", 
"Disk Drive", 
"Keyboard", 
"EEPROM (Lua BIOS)"}

--pressed_buttons = {}


local required_components = {
    
}

function check_autocraft(item)
    
    for _, item_me in ipairs(me_interface.getItemsInNetwork()) do
        if item == item_me.label then
            print("Предмет найден: " .. item_me.label)
            return true
        end
    end
    return false
end

function start_autocraft()
    for _, item in ipairs(pressed_buttons) do
        if check_autocraft(item) then
            return true
        else
            item_name = item
            local craftables = me_interface.getCraftables()
            if not craftables then
                print("Нет доступных автокрафтов в системе!")
                return
            end
        
            for _, craftable in ipairs(craftables) do
                local item = craftable.getItemStack()
                if item.label == item_name then
                    print("Запуск автокрафта для: " .. item_name)
                    local request = craftable.request(1) -- Запрос на 1 единицу
                    if request.isCanceled() then
                        print("Автокрафт отменен: недостаточно ресурсов.")
                    else
                        print("Автокрафт запущен!")
                    end
                    return
                end
            end
        
            print("Не удалось найти автокрафт для: " .. item_name)
        end
    end

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

function export_limited_items()
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

function main()
    start_autocraft() 
    for _, item in ipairs(pressed_buttons) do
        if store_item_in_database(item) then
            export_limited_items()
        end
    end
end

main()



function backend.start_assembling(buttons)
    print("Начало сборки...")
    pressed_buttons = {}
    for _, btn in ipairs(buttons) do
        if btn.button_pressed then
            table.insert(pressed_buttons, btn.name_craft)
        end
    end
    
end

function backend.stop_assembling()
    print("Остановка сборки...")
end

function backend.clear_components()
    for _, btn in ipairs(buttons) do
        btn.button_pressed = false
    end
    draw_buttons()
    max_difficulty = 0
end


return backend