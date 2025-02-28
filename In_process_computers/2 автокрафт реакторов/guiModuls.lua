local guiModuls = {}

local constants = dofile("constants.lua")

function guiModuls.draw_border(start_x, start_y, w, h, info, bg, fg)
    bg = bg or constants.colors.gray
    fg = fg or constants.colors.white
    constants.gpu.setBackground(bg)
    constants.gpu.setForeground(fg)

    for i = start_x, w do
        for j = start_y, h do
            if i == start_x or i == w or i == start_x + 1 or i == w - 1 or j == start_y or j == h then
                constants.gpu.fill(i, j, 1, 1, " ")
            end
        end
    end

    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.set(start_x + 4, start_y, "  " .. info .. "  ")
end
--guiModuls.draw_border(10, 5, 70, 20, "HELLO")

--функция для создания кнопок
--варианты: с рамкой или без
--если с рамкой, то высота минимум 3




return guiModuls