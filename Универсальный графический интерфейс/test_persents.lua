local guiConstants = dofile("guiConstants.lua")
local guiModuls = dofile("guiModuls.lua")
local guiButtons = dofile("guiButtons.lua")

local buttons = {}

local function draw_start_interfase()
    local border_main = {
        start_x=(guiConstants.w * 0.1)/2, 
        start_y=(guiConstants.h * 0.1)/2,
        width=guiConstants.w * 0.9, 
        height=guiConstants.h * 0.9,
        margin_percent = 0,
        text="MAIN"
    }
    local right_panel = guiModuls.create_relative_frame(border_main, {
        width_percent = 0.46,
        height_percent = 0.9,
        position = "right",
        text = "BORDER RIGHT"
    })

    guiModuls.draw_border(border_main)
    guiModuls.draw_border(right_panel)
end

function test()
    table.insert(buttons, guiModuls.draw_button({
        start_x=7, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 1|Статичная, без|доп. настроек",
    }, 
    {}, draw_start_interfase))

    table.insert(buttons, guiModuls.draw_button({
        start_x=70, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 3|Переключаемая,|с доп. цветами",
        block_bg = guiConstants.colors.green,
        block_fg = guiConstants.colors.black
    }, {
        switch_button=true,
        click_bg=guiConstants.colors.red,
        click_fg=guiConstants.colors.black
    }, guiButtons.pass))
    
    buttons = guiButtons.handler_button(buttons)
    --надо придумать реализацию переключения кнопок
    --функции, которые требуют переключения кнопок, будут программироваться отдельно,
    --завися от switch_button true или false и нового параметра btn_switched (только, если кнопка переключаемая)
    --или вывести это все в отдельную функцию? guiButtons.switched 
    -- но как тогда передать туда параметр?
    

end

local function main()
    guiConstants.gpu.fill(1, 1, guiConstants.w, guiConstants.h, " ")
    test()
end

main()
