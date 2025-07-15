local guiModuls = {}

local constants = dofile("constants.lua")

function guiModuls.draw_border(start_x, start_y, width, height, info, bg, fg)
    info = "  " .. info .. "  " or nil
    bg = bg or colors.gray
    fg = fg or colors.white
    constants.gpu.setBackground(bg)
    constants.gpu.setForeground(fg)

    for i = 1, width do
        for j = 1, height do
            if i == 1 or i == width or i == 2 or i == width - 1 or j == 1 or j == height then
                constants.gpu.fill(i + start_x, j + start_y, 1, 1, " ")
            end
        end
    end

    constants.gpu.setBackground(colors.black)
    constants.gpu.set(start_x + 4, start_y + 1, info)
end

function guiModuls.print(start_x, start_y, width, height, text, textColor)
    constants.gpu.setForeground(textColor)
    local unicode = require("unicode")

    local dict_text = {}
    for str in string.gmatch(text, "([^|]+)") do
        table.insert(dict_text, str)
    end

    if width - unicode.len(text) // 2 <= width then
        start_text_x = width - unicode.len(text) // 2
    else
        start_text_x = nil
    end
    
    if height - #dict_text // 2 <= height then
        start_text_y = height - #dict_text // 2
    else
        start_text_y = nil
    end
end

return guiModuls