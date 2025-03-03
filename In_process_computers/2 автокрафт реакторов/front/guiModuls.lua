local guiModuls = {}

local constants = require("constants")
local buttons = require("buttons")
local colors = constants.colors

local button = {}

function guiModuls.draw_border(start_x, start_y, w, h, info, bg, fg)
    bg = bg or constants.colors.gray
    fg = fg or constants.colors.white
    constants.gpu.setBackground(bg)
    constants.gpu.setForeground(fg)

    for i = 1, w do
        for j = 1, h do
            if i == 1 or i == w or i == 2 or i == w - 1 or j == 1 or j == h then
                constants.gpu.fill(i + start_x, j + start_y, 1, 1, " ")
            end
        end
    end

    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.set(start_x + 4, start_y + 1, info)
end
--guiModuls.draw_border(10, 5, constants.w - 20, constants.h - 10, "MAIN MENU")

--функция для создания кнопок
--варианты: с рамкой или без
--если с рамкой, то высота минимум 3
--сделать таблицу кнопок в отдельном файле
--помимо всех функций, добавить возможность как-то удалять старые кнопки при отрисовке нового интерфейса

function guiModuls.draw_button(start_x, start_y, w, h, text, bg1, bg2, fg, func)
    constants.gpu.setForeground(fg)

    table.insert(buttons.button, {
        x = start_x,
        y = start_y,
        btn_w = start_x + w,
        btn_h = start_y + h,
        btn_func = func
    })

    for i = 1, w do
        for j = 1, h do
            if i == 1 or i == w or i == 2 or i == w - 1 or j == 1 or j == h then
                constants.gpu.setBackground(bg1)          
            else
                constants.gpu.setBackground(bg2)       
            end
            constants.gpu.fill(i + start_x, j + start_y, 1, 1, " ")
        end
    end
    constants.gpu.set(start_x + 4, start_y + 1, "  " .. text .. "  ")
end

--guiModuls.draw_button(20, 10, 20, 10, "hello", colors.gray, colors.white, colors. black, buttons.btn_new_reactor)

function guiModuls.delete_all_btn_in_old_interfase()

end


return guiModuls