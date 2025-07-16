local frontNewBee = {}

--тут будет список со всеми возможными пчелкам
--надо бы еще поле поиска сделать

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")

cur_w = math.floor(constants.w / 5)
cur_h = math.floor(constants.h / 5)
frontNewBee.buttons = {}

--создание одной кнопки
function frontNewBee.draw_reactor_button(pos_x, pos_y, reactor_number)
    local function state_reactor(react_state)
        local state_colors = {
            ON = {fore = constants.colors.black, back = constants.colors.green},
            OFF = {fore = constants.colors.white, back = constants.colors.red},
        }
        local colors = state_colors[react_state] or state_colors["OFF"]
        constants.gpu.setForeground(colors.fore)
        constants.gpu.setBackground(colors.back)

        constants.gpu.set((pos_x + cur_w / 2) + 7, pos_y + 3, " " .. react_state ..  " ")

        constants.gpu.setForeground(constants.colors.white)
        constants.gpu.setBackground(constants.colors.black)
    end

    local react_state = "ON"
    local reactor_count_fluid = 5
    local reactor_gen_energy = 5

    table.insert(frontNewBee.buttons, {
        number = reactor_number,
        x1 = pos_x,
        y1 = pos_y,
        x2 = pos_x + cur_w,
        y2 = pos_y + cur_h,
    })

    guiModuls.draw_button(pos_x, pos_y, cur_w, cur_h, "", constants.colors.gray, constants.colors.black, constants.colors.white, function() frontAdditionalControl.main(reactor_number) end)

    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 3, "Реактор № " .. reactor_number .. "   ")
    state_reactor(react_state)
    constants.gpu.set(pos_x + 8, pos_y + 5, "Кол-во топлива: " .. reactor_count_fluid .. "%")
    constants.gpu.set(pos_x + 5, pos_y + 7, "Выработка энергии: " .. reactor_gen_energy .. " rf/t")
end

--отрисовка кнопок реакторов
function frontNewBee.draw_reactors_buttons()
    local reactor_number2 = 1
    
    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    
    for i = 0, 4 do
        for j = 0, 4 do
            if reactor_number2 ~= 25 then
                frontNewBee.draw_reactor_button(j * cur_w, i * cur_h, t[reactor_number2].reactor_number)
                reactor_number2 = reactor_number2 + 1
            else
                guiModuls.draw_button(pos_x, pos_y, cur_w, cur_h, "", constants.colors.gray, constants.colors.black, constants.colors.white, function() frontAdditionalControl.main(reactor_number2) end)
                frontNewBee.draw_reactor_button(j * cur_w, i * cur_h, "")
            end
        end
    end

end

-- Обработчик кликов
function frontNewBee.handle_click(x, y)
    for _, button in ipairs(frontNewBee.buttons) do
        if x >= button.x1 and x <= button.x2 and y >= button.y1 and y <= button.y2 then
            frontAdditionalControl.main(button.number)
            return
        end
    end
end

function frontNewBee.get_reactors()
    
end

function frontNewBee.main()

    frontNewBee.draw_reactors_buttons()

    while true do
        local _, _, x, y = require("event").pull("touch")
        frontNewBee.handle_click(x, y)
    end
end

return frontNewBee






