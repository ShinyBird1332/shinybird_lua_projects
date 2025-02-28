local frontAdditionalControl = {}

local constants = dofile("constants.lua")


local function draw_rect(start_x, start_y, w, h)
    for i = start_x, w do
        for j = start_y, h do
            if i == start_x or i == w or i == start_x + 1 or i == w - 1 or j == start_y or j == h then
                constants.gpu.fill(i, j, 1, 1, " ")
            end
        end
    end
end

function frontAdditionalControl.main(reactor_number)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    constants.gpu.setBackground(constants.colors.yellow)
        draw_rect(1, 1, constants.w, constants.h)
        constants.gpu.setBackground(constants.colors.gray)
        draw_rect(5, 3, constants.w - 70, constants.h - 2)
        draw_rect(93, 3, constants.w - 4, constants.h - 20)
        draw_rect(93, 32, constants.w - 4, constants.h - 2)

        constants.gpu.setBackground(constants.colors.black)
        constants.gpu.set(10, 3, "   INFO   ")
        constants.gpu.set(98, 3, "   CONTROL   ")
        constants.gpu.set(98, 32, "   NUMBERS   ")

    while true do
        reactor_state = "Работает"
        reactor_energy_out = "253000"
        reactor_energy_storage = "3000"
        c = 26
        constants.gpu.setBackground(constants.colors.green)
        constants.gpu.setForeground(constants.colors.black)
        constants.gpu.fill(98, 7, c, 3, " ")
        constants.gpu.set(98 + c // 2 - 2, 8, "ON")
        constants.gpu.setBackground(constants.colors.red)
        constants.gpu.setForeground(constants.colors.white)
        constants.gpu.fill(98 + c + 2, 7, c, 3, " ")
        constants.gpu.set(98 + c + c // 2, 8, "OFF")

        constants.gpu.setBackground(constants.colors.black)
        constants.gpu.setForeground(constants.colors.white)

        constants.gpu.set(98, 35, "Реактор № " .. reactor_number)
        constants.gpu.set(98, 37, "Состояние:  " .. reactor_state)
        constants.gpu.set(98, 39, "Выработка энергии: " .. reactor_energy_out .. " rf/t")
        constants.gpu.set(98, 41, "Потребление топлива: " .. reactor_energy_storage .. " rf")

        constants.gpu.set(10,  7, "Температура корпуса: ")
        constants.gpu.set(10, 17, "Температура ядра: ")
        constants.gpu.set(10, 27, "Количество топлива: ")
        constants.gpu.set(10, 37, "Хранимая энергия в реактое: ")

        constants.gpu.setBackground(constants.colors.gray)
        constants.gpu.fill(10,  9, 75, 6, " ")
        constants.gpu.fill(10, 19, 75, 6, " ")
        constants.gpu.fill(10, 29, 75, 6, " ")
        constants.gpu.fill(10, 39, 75, 6, " ")


        os.sleep(0.5) --160 50
    end
end

frontAdditionalControl.main(4)

return frontAdditionalControl