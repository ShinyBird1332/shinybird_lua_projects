local functions = {}
local frontControl = {}
local constants = dofile("constants.lua")

--cur_w = 50
--cur_h = 18

cur_w = math.floor(constants.w / 5)
cur_h = math.floor(constants.h / 5)
buttons = {}
descr = {{"Робот", check_robot}, 
    {"Репликаторы для создания компонентов", check_repl_component}, 
    {"Репликатор для урана", check_repl_uran}, 
    {"Система создания жидкого красного камня", check_redstone}}
--порядок проверки:
--1) робот - код красный
--2) репликаторы для создания компонентов. Код желтый для каждого недоступного репликатора
--3) репликатор для создания урана - код желтый
--4) система создания жидкого красного камня - код желтый

function check_robot()
    
    return "RED"
end

function check_repl_component()
    
    return "GREEN"
end

function check_repl_uran()
    
    return "YELLOW"
end

function check_redstone()
    
    return "YELLOW"
end

--создание одной кнопки
function frontControl.draw_reactor_button(pos_x, pos_y, reactor_number)
    local function state_reactor(react_state)
        local state_colors = {
            GREEN = {back = constants.colors.green},
            RED = {back = constants.colors.red},
            YELLOW = {back = constants.colors.yellow},
        }
        local colors = state_colors[react_state]
        return colors.back
    end

    local react_state = state_reactor(descr[reactor_number][2]())
    constants.gpu.setForeground(constants.colors.black)
    
    for i = 1, cur_w do
        for j = 1, cur_h do
            if i == 1 or i == cur_w or j == 1 or j == cur_h then
                constants.gpu.setBackground(constants.colors.gray)          
            else
                constants.gpu.setBackground(react_state)       
            end
            constants.gpu.fill(i + pos_x, j + pos_y, 1, 1, " ")
        end
    end

    constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 3, descr[reactor_number][1])
    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
end

--отрисовка кнопок реакторов
function frontControl.draw_descr()    
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    local descr_number = 1
    for i = 0, 1 do
        for j = 0, 1 do
            frontControl.draw_reactor_button(j*cur_w+(constants.w/2-cur_w), i*cur_h+(constants.h/2-cur_h), descr_number)
            descr_number = descr_number + 1
            os.sleep(1)
        end
    end
end

function main()
    frontControl.draw_descr()
end

main()


function functions.sheck_all_func()
    --перед запуском основной программы идет проверка:
    --(может вывести всю эту проверку в отдельный файл? Пока пусть будет тут, потмо перенесу)
    --проверка сразу должн быть с графикой
    --куда деть графику? в отдельный файл с проверкой? или в файл со всей отрисовкой?
    --потом, на финальной отпимизации решу.

--порядок проверки:
--1) робот - код красный
--2) репликаторы для создания компонентов. Код желтый для каждого недоступного репликатора
--3) репликатор для создания урана - код желтый
--4) система создания жидкого красного камня - код желтый

--гуи:
--поседерине рамка, разделенная на 4 части
--в каждой ячейке условие проверки и серая заливка
--если проверка успешная, ячейка заливается зеленым
--если нет, заливается желтым или красным
--между заливками задержка в секунду для красоты
--если есть хоть 1 желтый, выводится сообщение "вы уверены, что хотите продолжить работу?"
--если есть красный, программа "останавливается"

end

return functions