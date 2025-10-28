local guiModuls = {}

local guiConstants = dofile("guiConstants.lua")
local colors = guiConstants.colors

local function return_args(params)
    local args = {
        start_x = 1,
        start_y = 1,
        width = 20,
        height = 10,
        text = "",
        border_bg = colors.gray,
        border_fg = colors.white,
        block_bg = colors.black,
        block_fg = colors.white,
    }

    for key, value in pairs(params) do
        args[key] = value
    end
    return args
end

local function return_args_button(params)
    local args = {
        switch_button = false,
        click_bg = colors.black,
        click_fg = colors.white,
        hold_button = false,
        hold_bg = colors.black,
        hold_fg = colors.white,
        button_block = false,
    }

    for key, value in pairs(params) do
        args[key] = value
    end
    return args
end

function guiModuls.merge_tables(...)
    local result = {}
    for _, tbl in ipairs({...}) do
        for key, value in pairs(tbl) do
            result[key] = value
        end
    end
    return result
end

function guiModuls.create_relative_frame(parent, options)
    --вроде как, работает идеально, но это не точно
    --не тестил top_left top_right bottom_left bottom_right
    local opt = {}
    local defaults = {
        width_percent = 0.8,
        height_percent = 0.8,
        position = "center",
        margin_percent = 0.05,
        align = "center",
        text = ""
    }
    for k, v in pairs(defaults) do
        opt[k] = options[k] or v
    end
    local width = parent.width * opt.width_percent
    local height = parent.height * opt.height_percent
    local start_x, start_y
    if opt.position == "top" then
        start_y = parent.start_y + (parent.height * opt.margin_percent)
    elseif opt.position == "bottom" then
        start_y = parent.start_y + parent.height - height - (parent.height * opt.margin_percent)
    else
        start_y = parent.start_y + (parent.height - height) / 2
    end
    if opt.position == "left" then
        start_x = parent.start_x + (parent.width * opt.margin_percent)
    elseif opt.position == "right" then
        start_x = parent.start_x + parent.width - width - (parent.width * opt.margin_percent)
    else
        start_x = parent.start_x + (parent.width - width) / 2
    end
    if opt.position == "top_left" then
        start_x = parent.start_x + (parent.width * opt.margin_percent)
        start_y = parent.start_y + (parent.height * opt.margin_percent)
    elseif opt.position == "top_right" then
        start_x = parent.start_x + parent.width - width - (parent.width * opt.margin_percent)
        start_y = parent.start_y + (parent.height * opt.margin_percent)
    elseif opt.position == "bottom_left" then
        start_x = parent.start_x + (parent.width * opt.margin_percent)
        start_y = parent.start_y + parent.height - height - (parent.height * opt.margin_percent)
    elseif opt.position == "bottom_right" then
        start_x = parent.start_x + parent.width - width - (parent.width * opt.margin_percent)
        start_y = parent.start_y + parent.height - height - (parent.height * opt.margin_percent)
    end
    return {
        start_x = math.floor(start_x),
        start_y = math.floor(start_y),
        width = math.floor(width),
        height = math.floor(height),
        text = opt.text
    }
end

function guiModuls.draw_border(params)
    local args = return_args(params)

    if args.text ~= "" then
        args.text = "  " .. args.text .. "  "
    end

    guiConstants.gpu.setBackground(args.block_bg)
    guiConstants.gpu.fill(args.start_x+1, args.start_y+1, args.width, args.height, " ")

    guiConstants.gpu.setBackground(args.border_bg)
    guiConstants.gpu.setForeground(args.border_fg)

    for i = 1, args.width do
        for j = 1, args.height do
            if i == 1 or i == args.width or i == 2 or i == args.width - 1 or j == 1 or j == args.height then
                guiConstants.gpu.fill(i + args.start_x, j + args.start_y, 1, 1, " ")
            end
        end
    end

    guiConstants.gpu.setBackground(args.block_bg)
    if guiConstants.unicode.len(args.text) > args.width then
        guiConstants.gpu.set(args.start_x + 4, args.start_y + 1, guiConstants.unicode.sub(args.text, 1, guiConstants.unicode.len(args.text) - args.width))
    else
        guiConstants.gpu.set(args.start_x + 4, args.start_y + 1, args.text)
    end
end

function guiModuls.print(params)
    local args = return_args(params)

    guiConstants.gpu.setBackground(args.block_bg)
    guiConstants.gpu.setForeground(args.block_fg)

    args.width = args.width - 4 
    args.start_x = args.start_x + 2
    args.height = args.height - 2 
    args.start_y = args.start_y + 2

    local lines = {}
    for line in args.text:gmatch("[^|]+") do
        table.insert(lines, line)
    end


    local start_y_offset = math.floor((args.height - #lines) / 2)
    if math.type(start_y_offset) == "float" and start_y_offset ~= 1 then
        start_y_offset = start_y_offset - 1
    end

    local wrapped_lines = {}
    for _, line in ipairs(lines) do
        while guiConstants.unicode.len(line) > args.width do

            local split_pos = args.width
            while split_pos > 0 and guiConstants.unicode.sub(line, split_pos, split_pos) ~= " " do
                split_pos = split_pos - 1
            end
            if split_pos == 0 then split_pos = args.width end

            table.insert(wrapped_lines, guiConstants.unicode.sub(line, 1, split_pos))
            line = guiConstants.unicode.sub(line, split_pos + 1)
        end
        table.insert(wrapped_lines, line)
    end

    if #wrapped_lines > args.height then
        wrapped_lines = {table.unpack(wrapped_lines, 1, args.height - 1)}
        wrapped_lines[args.height] = "..."
    end

    for i, line in ipairs(wrapped_lines) do
        local line_len = guiConstants.unicode.len(line)
        local start_x_offset = math.floor((args.width - line_len) / 2) + 1

        guiConstants.gpu.set(
            args.start_x + start_x_offset,
            args.start_y + start_y_offset + i - 1,
            line
        )
    end
end

function guiModuls.draw_button(params, params_button, func)
    local args = return_args(params)
    local args_button = return_args_button(params_button)

    guiModuls.draw_border(params)
    guiModuls.print(params)

    guiConstants.gpu.setBackground(args.border_bg)
    guiConstants.gpu.fill(args.start_x + 1, args.start_y + 1, args.width, 1, " ")

    local res1 = {
        x = args.start_x,
        y = args.start_y,
        btn_w = args.start_x + args.width,
        btn_h = args.start_y + args.height,
        btn_func = func
    }

    return guiModuls.merge_tables(args_button, res1)
end

function guiModuls.handle_click(x, y)
    for _, btn in ipairs(buttons) do
        if btn.enabled and x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then
            -- Обработка разных типов кнопок
            if btn.switch_mode then
                -- Переключаемая кнопка
                btn.pressed = not btn.pressed
                guiModuls.redraw_button(btn)
            else
                -- Обычная кнопка - временное нажатие
                btn.pressed = true
                guiModuls.redraw_button(btn)
                
                -- Выполняем функцию
                if btn.btn_func then
                    btn.btn_func()
                end
                
                -- Возвращаем в исходное состояние
                btn.pressed = false
                guiModuls.redraw_button(btn)
            end
            return btn.id  -- Возвращаем ID нажатой кнопки
        end
    end
    return nil  -- Ни одна кнопка не нажата
end

return guiModuls
