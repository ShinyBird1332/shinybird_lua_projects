local frontMain = {}

local constants = dofile("constants.lua")
local gui_constants = dofile("gui_constants.lua")
local guiModuls = dofile("guiModuls.lua")
local frontClearBee = dofile("frontClearBee.lua")

local colors = gui_constants.colors

function btn_big_hive()
    
end

function btn_new_bee()
    
end

function btn_clear_bee()
    frontClearBee.draw_start_interfase()
end

function frontMain.draw_start_interfase()
    local buttons = {}
    local un_dict = {
        {
            name_border = "BIG HIVE", 
            description_border = "Создание следующих пчел чистого вида для первого большого улья:|Имперская (маточное молочко)|" ..
            "Трудолюбивая(скопление пыльцы)|Разводимая (соты и масло)| |Для работы требуются базовые пчелы.",
            button_text = "Вывод набора пчел для большого улья",
            button_func = btn_big_hive
        },
        {
            name_border = "NEW BEE",
            description_border = "Создание определенной плелы чистого вида из списка всех существующих пчел на сервере.| " .. 
            "|Какие пчелы нужны для целевой пчелы, будет указано перед началом вывода.| " .. 
            "|В 99% случаях нужны только базовые пчелы.",
            button_text = "Заказать определенную пчелу",
            button_func = btn_new_bee
        },
        {
            name_border = "CLEAR BEE",
            description_border = "Программа сканирует сундук с пчелами и выдает список, какой вид пчелы можно попытаться сделать чистым.| "..
            "|Нет гарантии, что процесс пройдет успешно, так как все пчелы могут отдеградировать или наоборот, эволюционировать.| ".. 
            "|В таком случае нужно будет заказать пчелу заново через режим NEW BEE.",
            button_text = "Приведение пчелы к чистым генам",
            button_func = btn_clear_bee
        },
    }

    local start_x_second = gui_constants.start_x_first + gui_constants.sep * 2
    local start_y_second = gui_constants.start_y_first + gui_constants.sep
    local wigth_second = gui_constants.wigth_first // #un_dict - gui_constants.sep * 2
    local height_second = gui_constants.height_first - gui_constants.sep * 2

    gui_constants.gpu.fill(1, 1, gui_constants.w, gui_constants.h, " ")
    guiModuls.draw_border({
        start_x = gui_constants.start_x_first, 
        start_y = gui_constants.start_y_first, 
        width = gui_constants.wigth_first, 
        height = gui_constants.height_first,
        text="MAIN MENU",
    })
    
    for i = 1, #un_dict do
        guiModuls.draw_border({
            start_x = start_x_second + (i-1) * wigth_second + (i-1)*gui_constants.sep, 
            start_y = start_y_second, 
            width = wigth_second, 
            height = height_second,
            text=un_dict[i].name_border,
        })
        table.insert(buttons, guiModuls.draw_button({
            start_x = start_x_second + (i-1) * wigth_second + (i-1)*gui_constants.sep + 4, 
            start_y = start_y_second+gui_constants.sep, 
            width = wigth_second - gui_constants.sep*4, 
            height = (height_second/6)+1,
            text = un_dict[i].button_text,
            block_bg = colors.green,
            block_fg = colors.white
        }, 
        {}, un_dict[i].button_func))
        guiModuls.print({
            start_x = start_x_second + (i-1) * wigth_second + (i-1)*gui_constants.sep + 4, 
            start_y = start_y_second+gui_constants.sep*4, 
            width = wigth_second - gui_constants.sep*3, 
            height = height_second/2,
            text=un_dict[i].description_border,
        })
    end
    buttons[1].button_block = true
    buttons[2].button_block = true

    while true do
        local _, _, x, y = constants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h and btn.button_block == false then
                buttons = {}
                btn.btn_func()
                break
            end
        end
    end
end

return frontMain