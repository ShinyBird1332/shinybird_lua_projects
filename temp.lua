local guiModuls = {}

local constants = dofile("constants.lua")
local colors = constants.colors

function guiModuls.draw_border(start_x, start_y, w, h, info, bg, fg)
    bg = bg or colors.gray
    fg = fg or colors.white
    constants.gpu.setBackground(bg)
    constants.gpu.setForeground(fg)

    for i = 1, w do
        for j = 1, h do
            if i == 1 or i == w or i == 2 or i == w - 1 or j == 1 or j == h then
                constants.gpu.fill(i + start_x, j + start_y, 1, 1, " ")
            end
        end
    end

    constants.gpu.setBackground(colors.black)
    constants.gpu.set(start_x + 4, start_y + 1, info)
end
--guiModuls.draw_border(10, 5, constants.w - 20, constants.h - 10, "MAIN MENU")

function guiModuls.draw_button(start_x, start_y, w, h, text, border_color, fill_color, text_color, func)
    constants.gpu.setForeground(textColor)
    constants.gpu.setBackground(fill_color)

    for i = 1, w do
        for j = 1, h do
            constants.gpu.fill(i + start_x, j + start_y, 1, 1, " ")
        end
    end
    constants.gpu.set(start_x + 4, start_y + 1, "  " .. text .. "  ")

    guiModuls.draw_border(start_x, start_y, w, h, "", border_color, text_color)

    return {
        x = start_x,
        y = start_y,
        btn_w = start_x + w,
        btn_h = start_y + h,
        btn_func = func
    }
end

--guiModuls.draw_button(20, 10, 20, 10, "hello", colors.gray, colors.white, colors. black, buttons.btn_new_reactor)

return guiModuls