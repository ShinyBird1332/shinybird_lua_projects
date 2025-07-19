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
            description_border = "Вывод набора пчелдля большого улья:|Имперская|Трудолюбивая|Разводимая"
        },
        {
            name_border = "NEW BEE",
            description_border = "Заказать определенную пчелу"
        },
        {
            name_border = "CLEAR BEE",
            description_border = "Приведение пчелы к чистым генам."
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
        guiModuls.print(start_x_second + (i-1) * wigth_second + (i-1)*sep, start_y_second, wigth_second, height_second/2, un_dict[i].description_border, colors.black)
        guiModuls.draw_button(start_x_second + (i-1) * wigth_second + (i-1)*sep, start_y_second*2, wigth_second, height_second/2, un_dict[i].description_border, colors.black, colors.white, 1)
    end
end

frontMain.draw_start_interfase()

return frontMain