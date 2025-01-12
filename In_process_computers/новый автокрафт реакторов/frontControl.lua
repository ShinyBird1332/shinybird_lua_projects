--local frontControl = {}





--отдельное окно со списком реакторов - готово (75%)
--каждый блок с небольшой инфой (номер, работает ли реактор, кол-во топлива, буфер энергии)
--каждый блок - кнопка, которая расширяет информацию о выбранном реакторе

local constants = dofile("constants.lua")
local frontAdditionalControl = dofile("frontAdditionalControl.lua")

cur_w = math.floor(constants.w / 5)
cur_h = math.floor(constants.h / 5)
local buttons = {}

--создание одной кнопки
function draw_reactor_button(pos_x, pos_y, reactor_number)
    local function state_reactor(react_state)
        local state_colors = {
            ON = {fore = constants.colors.black, back = constants.colors.green},
            OFF = {fore = constants.colors.white, back = constants.colors.red},
        }
        local colors = state_colors[react_state] or state_colors["OFF"]
        constants.gpu.setForeground(colors.fore)
        constants.gpu.setBackground(colors.back)

        constants.gpu.set((pos_x + cur_w / 2) + 7, pos_y + 3, " ".. react_state ..  " ")

        constants.gpu.setForeground(constants.colors.white)
        constants.gpu.setBackground(constants.colors.black)
    end

    local react_state = "ON"
    local reactor_count_fluid = 5
    local reactor_gen_energy = 5

    table.insert(buttons, {
        number = reactor_number,
        x1 = pos_x,
        y1 = pos_y,
        x2 = pos_x + cur_w,
        y2 = pos_y + cur_h,
    })
    
    constants.gpu.setBackground(constants.colors.gray)
    for i = 1, cur_w do
        for j = 1, cur_h do
            if i == 1 or i == cur_w or j == 1 or j == cur_h then
                constants.gpu.fill(i + pos_x, j + pos_y, 1, 1, " ")
            end
        end
    end

    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 3, "Реактор № " .. reactor_number .. "   ")
    state_reactor(react_state)
    constants.gpu.set(pos_x + 8, pos_y + 5, "Кол-во топлива: " .. reactor_count_fluid .. "%")
    constants.gpu.set(pos_x + 5, pos_y + 7, "Выработка энергии: " .. reactor_gen_energy .. " rf/t")
end

--отрисовка кнопок реакторов
function draw_reactors_buttons()
    reactor_number = 1
    local buttons_in_row = math.floor(constants.w / cur_w)
    local buttons_in_column = math.floor(constants.h / cur_h)
    
    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    

    for i = 0, buttons_in_column - 1 do
        for j = 0, buttons_in_row - 1 do
            draw_reactor_button(j * cur_w, i * cur_h, reactor_number)
            reactor_number = reactor_number + 1
        end
    end

end

-- Обработчик кликов
function handle_click(x, y)
    for _, button in ipairs(buttons) do
        if x >= button.x1 and x <= button.x2 and y >= button.y1 and y <= button.y2 then
            --constants.gpu.fill(button.x1, button.y1, cur_w, cur_h, "*")
            frontAdditionalControl.main(button.number)
            return
        end
    end
end

function main()
    draw_reactors_buttons()

    while true do
        local _, _, x, y = require("event").pull("touch")
        handle_click(x, y)
    end
end

main()


--return frontControl