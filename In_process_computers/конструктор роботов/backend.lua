local backend = {}

local component = require("component")
local event = require("event")
local event = require("unicode")
local term = require("term")
local gpu = component.gpu
local me_interface = component.me_interface

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

function start_autocraft()
    item_name = "Computer Case (Tier 3)"

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

start_autocraft() 


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