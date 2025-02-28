local start = {}

--перед запуском основной программы идет проверка:
--проверка сразу должн быть с графикой

--гуи:
--поседерине рамка, разделенная на 4 части
--в каждой ячейке условие проверки и серая заливка
--если проверка успешная, ячейка заливается зеленым
--если нет, заливается желтым или красным
--между заливками задержка в секунду для красоты
--если есть хоть 1 желтый, выводится сообщение "вы уверены, что хотите продолжить работу?"
--если есть красный, программа "останавливается"

--новый план:
--сделать проверку как запуск ОС
--слудба - ОК или служба - FAIL

local constants = dofile("constants.lua")


local tunnel = constants.comp.tunnel
local trans_uran = constants.comp.proxy("55cffde0-ebb4-4e19-9dd0-23a66098ed2c")
local trans_redstone = constants.comp.proxy("55cffde0-ebb4-4e19-9dd0-23a66098ed2c")

local cur_w = math.floor(constants.w / 5)
local cur_h = math.floor(constants.h / 5)

local descr = {{"Робот", check_robot}, 
    {"Репликаторы для создания компонентов", check_repl_component}, 
    {"Репликатор для урана", check_repl_uran}, 
    {"Система создания жидкого красного камня", check_redstone}}

function check_robot()
    tunnel.send("check", 1)
    local _, _, _, _, _, message, command = constants.event.pull("modem_message")
    --надо придумать, как убрать бесконечную задержку, если робот недоступен
    if message == "yes" then
        return "GREEN"
    else
        return "RED"
    end
end

function check_repl_component()
    
    return "GREEN"
end

function check_repl_uran()
    if trans_uran ~= nil then
        return "GREEN"
    else
        return "YELLOW"
    end
end

function check_redstone()
    if trans_redstone ~= nil then
        return "GREEN"
    else
        return "RED"
    end
end

--создание одной кнопки
function draw_reactor_button(pos_x, pos_y, reactor_number)
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
function start.draw_descr()    
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    local descr_number = 1
    for i = 0, 1 do
        for j = 0, 1 do
            draw_reactor_button(j*cur_w+(constants.w/2-cur_w), i*cur_h+(constants.h/2-cur_h), descr_number)
            descr_number = descr_number + 1
        end
    end
end

function start.sheck_all_func()
    start.draw_descr()

end

return start