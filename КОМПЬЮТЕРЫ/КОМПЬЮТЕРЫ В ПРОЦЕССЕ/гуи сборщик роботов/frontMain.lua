local frontMain = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")
local gui_constants = dofile("gui_constants.lua")
local colors = gui_constants.colors
local buttons = {}

function frontMain.draw_start_interfase()
    main_w = constants.w - 20 - 10
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")

    frontMain.draw_start_borders()
    frontMain.draw_comp_buttons()
    frontMain.draw_add_buttons()
end

function frontMain.draw_start_borders()
    guiModuls.draw_border({
        start_x=2, 
        start_y=1, 
        width=gui_constants.w - 4, 
        height=gui_constants.h - 2, 
    })
    guiModuls.draw_border({
        start_x=6, 
        start_y=3, 
        width=((gui_constants.w - 12) // 3 * 2), 
        height=5, 
    })
    guiModuls.draw_border({
        start_x=((gui_constants.w) // 3 * 2), 
        start_y=3, 
        width=((gui_constants.w - 12) // 3) - 2, 
        height=5, 
    })
    guiModuls.draw_border({
        start_x=6, 
        start_y=3+5+1, 
        width=((gui_constants.w - 12) // 3 * 2), 
        height=gui_constants.h - (3+5+4),
    })
    guiModuls.draw_border({
        start_x=((gui_constants.w) // 3 * 2), 
        start_y=3+5+1,
        width=((gui_constants.w - 12) // 3) - 2, 
        height=gui_constants.h - (3+5+4),
    })
    guiModuls.print({
        start_x=6, 
        start_y=3, 
        width=((gui_constants.w - 12) // 3 * 2), 
        height=5, 
        text="ЗАВОД ПО СОЗДАНИЮ РОБОТОВ"
    })
    guiModuls.print({
        start_x=((gui_constants.w) // 3 * 2), 
        start_y=3, 
        width=((gui_constants.w - 12) // 3) - 2, 
        height=5, 
        text="КОНСОЛЬ (ВЫВОД ИНФОРМАЦИИ)"
    })
end

function frontMain.draw_comp_buttons()
    local cur_w = ((gui_constants.w - 12) // 3 * 2) // 6 -1
    local cur_h = (gui_constants.h - (3+5+4)) // 5 
    local c = 1

    for i = 0, 4 do
        for j = 0, 5 do
            local pos_x = j * cur_w + 10
            local pos_y = i * cur_h + 10
            table.insert(buttons, guiModuls.draw_button({
                start_x=pos_x, 
                start_y=pos_y, 
                width=cur_w, 
                height=cur_h,
                text=constants.choise_components[c]["btn_text"],
                block_bg = colors.red,
                block_fg = colors.black,
                border_bg = colors.black
            }, {
                switch_button=true,
                click_bg=colors.green,
                click_fg=colors.black
            }, 1))
            c = c + 1
        end
    end
end

function frontMain.draw_add_buttons()
    local BUTTON_LAYOUT = {
        {
            count = 3,
            width = 12,
            height = 5,
            start_y = gui_constants.h - 14,
            names = {"СТАРТ", "СТОП", "СБРОС"}
        },{
            count = 2,
            width = 18,
            height = 5,
            start_y = gui_constants.h - 9,
            names = {"ВВОД IP", "ВВОД СТОРОН"}
        }
    }
    
    buttons = {}
    guiModuls.draw_border({
        start_x=((gui_constants.w) // 3 * 2) + 2, 
        start_y=(gui_constants.h-16//3)-10,
        width=43, 
        height=1,
    })
    local base_x = (gui_constants.w // 3 * 2) + 4

    for i = 1, #BUTTON_LAYOUT do
        for j = 1, BUTTON_LAYOUT[i].count do
            local x = base_x + ((j - 1) * (BUTTON_LAYOUT[i].width + 1))
            table.insert(buttons, guiModuls.draw_button({
            start_x = x, 
            start_y = BUTTON_LAYOUT[i].start_y, 
            width = BUTTON_LAYOUT[i].width, 
            height = BUTTON_LAYOUT[i].height,
            text = BUTTON_LAYOUT[i].names[j],
            block_bg = colors.green,
            block_fg = colors.black,
            border_bg = colors.black
        }, {
            switch_button = false,
            click_bg = colors.green,
            click_fg = colors.black
        }, 1))
        end
    end
end

frontMain.draw_start_interfase()

return frontMain