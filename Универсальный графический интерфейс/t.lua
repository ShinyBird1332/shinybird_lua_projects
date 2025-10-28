local guiConstants = dofile("guiConstants.lua")
local guiBackend = dofile("guiBackend.lua")
local guiModuls = dofile("guiModuls.lua")
local guiButtons = dofile("guiButtons.lua")

local colors = guiConstants.colors

function test()
    table.insert(guiButtons.buttons, guiModuls.draw_button({
        start_x=7, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 1|Статичная, без|доп. настроек",
    }, 
    {}, 1))

    table.insert(guiButtons.buttons, guiModuls.draw_button({
        start_x=7+30+4, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 2|Статичная,|с доп. цветами",
        border_bg = colors.yellow,
        block_bg = colors.green,
        block_fg = colors.black,
    }, 
    {}, 1))

        table.insert(guiButtons.buttons, guiModuls.draw_button({
        start_x=7+30*2+4*2, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 3|Переключаемая,|с доп. цветами",
        block_bg = colors.green,
        block_fg = colors.black
    }, 
    {
        switch_button=true,
        click_bg=colors.red,
        click_fg=colors.black
    }, 1))
    
    guiBackend.btn_new_window(guiButtons.buttons)

end

function draw_start_interfase()
    guiConstants.gpu.fill(1, 1, guiConstants.w, guiConstants.h, " ")
    guiModuls.draw_border({
        start_x=10, 
        start_y=5, 
        width=guiConstants.w - 20, 
        height=guiConstants.h - 10, 
        text="  MAIN MENU  "})
end

function main()
    draw_start_interfase()
    test()
end