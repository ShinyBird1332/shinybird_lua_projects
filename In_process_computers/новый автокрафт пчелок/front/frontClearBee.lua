-- Цель: привести пчелу до состояния: 1 чистая принцесса и 64 трутня в стаке
-- Сначала сканируем сундук и создаем список всех отсканированных трутней и принцесс
-- Убираем дубликаты (если есть и трутень и принцесса одного вида)
-- Выводим на экран список в следующем виде: 
-- поисковое поле, 
-- ниже таблица кнопок (A x B надо будет ан месте посчитать)
-- ниже стрелка назад, текущая страница/всего страниц, стрелка вперед

local frontClearBee = {}

local constants = dofile("constants.lua")
local gui_constants = dofile("gui_constants.lua")
local guiModuls = dofile("guiModuls.lua")
local guiBackend = dofile("guiBackend.lua")

cur_w = math.floor(gui_constants.w / 5)
cur_h = math.floor(gui_constants.h / 5)

frontClearBee.buttons = {}

function frontClearBee.draw_start_interfase()
    guiModuls.draw_border({
        start_x = gui_constants.start_x_first, 
        start_y = gui_constants.start_y_first, 
        width = gui_constants.wigth_first, 
        height = gui_constants.height_first,
        text="CLEAR BEE",
    })
    --guiModuls.draw_search({})
end

function draw_button(pos_x, pos_y, text)

    table.insert(frontClearBee.buttons, {
        x1 = pos_x,
        y1 = pos_y,
        x2 = pos_x + cur_w,
        y2 = pos_y + cur_h,
    })

    guiModuls.draw_button(pos_x, pos_y, cur_w, cur_h, "", constants.colors.gray, constants.colors.black, constants.colors.white, function() frontAdditionalControl.main(reactor_number) end)

    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)

    constants.gpu.set(pos_x + 8, pos_y + 5, text)

end

function frontClearBee.draw_buttons()
    local reactor_number2 = 1
    
    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    
    for i = 0, 4 do
        for j = 0, 4 do
            if reactor_number2 ~= 25 then
                frontClearBee.draw_button(j * cur_w, i * cur_h, "Скромная")
                reactor_number2 = reactor_number2 + 1
            else
                --guiModuls.draw_button(pos_x, pos_y, cur_w, cur_h, "", constants.colors.gray, constants.colors.black, constants.colors.white, function() frontAdditionalControl.main(reactor_number2) end)
                frontClearBee.draw_button(j * cur_w, i * cur_h, "Назад")
            end
        end
    end

end

return frontClearBee