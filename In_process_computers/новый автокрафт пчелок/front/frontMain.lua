local frontMain = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")

local colors = constants.colors

local buttons = {}

function btn_big_hive()
    
end

function btn_new_bee()
    
end

function btn_clear_bee()

end

function frontMain.draw_start_interfase()
    local un_dict = {
        {
            name_border = "BIG HIVE", 
            description_border = "Создание следующих пчел чистого вида для первого большого улья:|Имперская (маточное молочко)|" ..
            "Трудолюбивая(скопление пыльцы)|Разводимая (соты и масло)| |Для работы требуются базовые пчелы.",
            button_text = "Вывод набора пчел для большого улья"
        },
        {
            name_border = "NEW BEE",
            description_border = "Создание определенной плелы чистого вида из списка всех существующих пчел на сервере.| " .. 
            "|Какие пчелы нужны для целевой пчелы, будет указано перед началом вывода.| " .. 
            "|В 99% случаях нужны только базовые пчелы.",
            button_text = "Заказать определенную пчелу"
        },
        {
            name_border = "CLEAR BEE",
            description_border = "Программа сканирует сундук с пчелами и выдает список, какой вид пчелы можно попытаться сделать чистым.| "..
            "|Нет гарантии, что процесс пройдет успешно, так как все пчелы могут отдеградировать или наоборот, эволюционировать.| ".. 
            "|В таком случае нужно будет заказать пчелу заново через режим NEW BEE.",
            button_text = "Приведение пчелы к чистым генам"
        },
    }
    local second_names_border = {"BIG HIVE", "NEW BEE", "CLEAR BEE"}

    local sep = 2
    local start_x_first = 10
    local start_y_first = 5
    local wigth_first = constants.w - start_x_first * 2
    local height_first = constants.h - start_y_first * 2

    local start_x_second = start_x_first + sep * 2
    local start_y_second = start_y_first + sep
    local wigth_second = wigth_first // #un_dict - sep * 2
    local height_second = height_first - sep * 2

    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    guiModuls.draw_border(start_x_first, start_y_first, wigth_first, height_first, "MAIN MENU")
    
    for i = 1, #un_dict do
        guiModuls.draw_border(start_x_second + (i-1) * wigth_second + (i-1)*sep, start_y_second, wigth_second, height_second, un_dict[i].name_border)
        guiModuls.draw_button(start_x_second + (i-1) * wigth_second + (i-1)*sep + 4, start_y_second+sep, wigth_second - sep*4, (height_second/6)+1, 
        un_dict[i].button_text, colors.gray, colors.white, colors.green, 1)
        guiModuls.print(start_x_second + (i-1) * wigth_second + (i-1)*sep + 4, start_y_second+sep*4, wigth_second - sep*3, height_second/2, un_dict[i].description_border, colors.black, colors.white, colors.black)
    end
end

frontMain.draw_start_interfase()

return frontMain