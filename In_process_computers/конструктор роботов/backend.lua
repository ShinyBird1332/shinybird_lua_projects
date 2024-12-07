local backend = {}

local component = require("component")
local event = require("event")
local event = require("unicode")
local term = require("term")
local gpu = component.gpu
local me_interface = component.me_interface

pressed_buttons = {}


local required_components = {
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "EEPROM (Lua BIOS)"
}

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