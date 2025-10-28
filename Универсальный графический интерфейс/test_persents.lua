local guiConstants = dofile("guiConstants.lua")
local guiModuls = dofile("guiModuls.lua")

local function draw_start_interfase()
    local border_main = {
        start_x=(guiConstants.w * 0.1)/2, 
        start_y=(guiConstants.h * 0.1)/2,
        width=guiConstants.w * 0.93, 
        height=guiConstants.h * 0.93,
        margin_percent = 0,
        text="MAIN"
    }
    --local border_main = {
    --    start_x=(guiConstants.w * 0.1)/2, 
    --    start_y=(guiConstants.h * 0.1)/2,
    --    width=guiConstants.w * 0.9, 
    --    height=guiConstants.h * 0.7,
    --}
    local right_panel = guiModuls.create_relative_frame(border_main, {
        width_percent = 0.46,
        height_percent = 0.9,
        position = "right",
        text = "BORDER RIGHT"
    })

    guiModuls.draw_border(border_main)
    guiModuls.draw_border(right_panel)
end

local function main()
    guiConstants.gpu.fill(1, 1, guiConstants.w, guiConstants.h, " ")
    draw_start_interfase()
end

main()
