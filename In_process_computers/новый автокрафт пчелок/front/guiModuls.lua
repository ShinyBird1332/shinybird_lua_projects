local guiModuls = {}

local unicode = require("unicode")
local constants = dofile("constants.lua")
local colors = constants.colors

function guiModuls.draw_border(start_x, start_y, width, height, info, bg, fg)
    info = info and ("  " .. info .. "  ")
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

function guiModuls.print(start_x, start_y, width, height, text, bg, fg)
    bg = bg or colors.gray
    fg = fg or colors.white
    constants.gpu.setBackground(bg)
    constants.gpu.setForeground(fg)

    width = width - 4 
    start_x = start_x + 2
    height = height - 2 
    start_y = start_y + 2

    local lines = {}
    for line in text:gmatch("[^|]+") do
        table.insert(lines, line)
    end

    local start_y_offset = math.floor((height - #lines) / 2)

    local wrapped_lines = {}
    for _, line in ipairs(lines) do
        while unicode.len(line) > width do

            local split_pos = width
            while split_pos > 0 and unicode.sub(line, split_pos, split_pos) ~= " " do
                split_pos = split_pos - 1
            end
            if split_pos == 0 then split_pos = width end

            table.insert(wrapped_lines, unicode.sub(line, 1, split_pos))
            line = unicode.sub(line, split_pos + 1)
        end
        table.insert(wrapped_lines, line)
    end

    if #wrapped_lines > height then
        wrapped_lines = {table.unpack(wrapped_lines, 1, height - 1)}
        wrapped_lines[height] = "..."
    end

    for i, line in ipairs(wrapped_lines) do
        local line_len = unicode.len(line)
        local start_x_offset = math.floor((width - line_len) / 2) + 1

        constants.gpu.set(
            start_x + start_x_offset,
            start_y + start_y_offset + i - 1,
            line
        )
    end
end

function guiModuls.draw_button(start_x, start_y, width, height, text, bg, fg, func)
    guiModuls.draw_border(start_x, start_y, width, height, nil, bg, fg)
    guiModuls.print(start_x, start_y, width, height, text, bg, fg)

    return {
        x = start_x,
        y = start_y,
        btn_w = start_x + width,
        btn_h = start_y + height,
        btn_func = func
    }
end

function guiModuls.draw_search(start_x, start_y, width, height, bg, fg, func)
    function temp()
        event = require("event")
        while true do
            state, _, k = event.pull("key")
            if k and state == "key_down" then
                char = unicode.char(k)
                print(char)
            end
            os.sleep(0.05)
        end
    end

    guiModuls.draw_button(start_x, start_y, width, height, nil, bg, fg)

    


end

return guiModuls
