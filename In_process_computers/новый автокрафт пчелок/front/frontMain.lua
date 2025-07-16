local frontMain = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")

local buttons = {}

function btn_big_hive()
    
end

function btn_new_bee()
    
end

function btn_clear_bee()

end

function frontMain.draw_start_interfase()
    local start_x_first = 10
    local start_y_first = 5
    local stop_x_first = constants.w - start_x_first * 2
    local stop_y_first = constants.h - start_y_first * 2

    local start_x_second = 0
    local start_y_second = start_y_first + 2
    local stop_x_second = 0
    local stop_y_second = stop_y_first - 4 -- constants.h - 24


    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    guiModuls.draw_border(start_x_first, start_y_first, stop_x_first, stop_y_first, "MAIN MENU")

    --заменить циклом для start_x_second и stop_x_second
    guiModuls.draw_border(14, start_y_second, main_w // 3, stop_y_second, "  BIG HIVE  ")
    guiModuls.draw_border(main_w // 3 + 16, start_y_second, main_w // 3, stop_y_second, "NEW BEE")
    guiModuls.draw_border(main_w // 3 * 2 + 18, start_y_second, main_w // 3, stop_y_second, "  CLEAR BEE  ")



end

frontMain.draw_start_interfase()

return frontMain