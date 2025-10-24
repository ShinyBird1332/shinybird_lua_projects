local guiModuls = {}

local gui_constants = dofile("gui_constants.lua")
local colors = gui_constants.colors

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

function guiModuls.draw_border(params)
    local args = return_args(params)

    if args.text ~= "" then
        args.text = "  " .. args.text .. "  "
    end

    gui_constants.gpu.setBackground(args.block_bg)
    gui_constants.gpu.fill(args.start_x+1, args.start_y+1, args.width, args.height, " ")

    gui_constants.gpu.setBackground(args.border_bg)
    gui_constants.gpu.setForeground(args.border_fg)

    for i = 1, args.width do
        for j = 1, args.height do
            if i == 1 or i == args.width or i == 2 or i == args.width - 1 or j == 1 or j == args.height then
                gui_constants.gpu.fill(i + args.start_x, j + args.start_y, 1, 1, " ")
            end
        end
    end

    gui_constants.gpu.setBackground(args.block_bg)
    if gui_constants.unicode.len(args.text) > args.width then
        gui_constants.gpu.set(args.start_x + 4, args.start_y + 1, gui_constants.unicode.sub(args.text, 1, gui_constants.unicode.len(args.text) - args.width))
    else
        gui_constants.gpu.set(args.start_x + 4, args.start_y + 1, args.text)
    end
end

function guiModuls.print(params)
    local args = return_args(params)

    gui_constants.gpu.setBackground(args.block_bg)
    gui_constants.gpu.setForeground(args.block_fg)

    args.width = args.width - 4 
    args.start_x = args.start_x + 2
    args.height = args.height - 2 
    args.start_y = args.start_y + 2

    local lines = {}
    for line in args.text:gmatch("[^|]+") do
        table.insert(lines, line)
    end

    local start_y_offset = math.floor((args.height - #lines) / 2)

    local wrapped_lines = {}
    for _, line in ipairs(lines) do
        while gui_constants.unicode.len(line) > args.width do

            local split_pos = args.width
            while split_pos > 0 and gui_constants.unicode.sub(line, split_pos, split_pos) ~= " " do
                split_pos = split_pos - 1
            end
            if split_pos == 0 then split_pos = args.width end

            table.insert(wrapped_lines, gui_constants.unicode.sub(line, 1, split_pos))
            line = gui_constants.unicode.sub(line, split_pos + 1)
        end
        table.insert(wrapped_lines, line)
    end

    if #wrapped_lines > args.height then
        wrapped_lines = {table.unpack(wrapped_lines, 1, args.height - 1)}
        wrapped_lines[args.height] = "..."
    end

    for i, line in ipairs(wrapped_lines) do
        local line_len = gui_constants.unicode.len(line)
        local start_x_offset = math.floor((args.width - line_len) / 2) + 1

        gui_constants.gpu.set(
            args.start_x + start_x_offset,
            args.start_y + start_y_offset + i - 1,
            line
        )
    end
end

--кнопки надо сделать более гибкие: переключаемые с заменой цветов, смена цветов при наведении на кнопку, 
--блокирование кнопки, если на нее сейчас нельзя нажать
function guiModuls.draw_button(params, params_button, func)
    local args = return_args(params)
    local args_button = return_args_button(params_button)

    guiModuls.draw_border(params)
    guiModuls.print(params)

    gui_constants.gpu.setBackground(args.border_bg)
    gui_constants.gpu.fill(args.start_x + 1, args.start_y + 1, args.width, 1, " ")

    local res1 = {
        x = args.start_x,
        y = args.start_y,
        btn_w = args.start_x + args.width,
        btn_h = args.start_y + args.height,
        btn_func = func
    }

    return guiModuls.merge_tables(args_button, res1)
end

-- логика поиска:
-- при нажатии на поле поиска начинается цикл с ивентом key
-- при каждом нажатии кнопки, список обновляется, отсекая кнопки, которые не совпадают с текстом в поиске
-- если нажать ентер, поле поиска перестанет быть активным
-- если нажать бекспейс, список так же должен обновляться
-- сверху поиска обязательно писать про ограничение скорости печати (1 символ в секунду)
function guiModuls.draw_search(params, params_button, func)
    function temp()
        event = require("event")
        while true do
            state, _, k = event.pull("key")
            if k and state == "key_down" then
                char = gui_constants.unicode.char(k)
                print(char)
            end
            os.sleep(0.05)
        end
    end

    local args = return_args(params)
    guiModuls.draw_button(params, params_button, func)
    guiModuls.print({
        start_x=args.start_x+1, 
        start_y=args.start_y, 
        width=6, 
        height=5,
        text="\\_"
    })

end

return guiModuls
