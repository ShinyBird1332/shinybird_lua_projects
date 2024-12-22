local constants = dofile("constants.lua")
local backend = dofile("backend.lua")


buttons = {}
max_difficulty = 0
current_difficulty = 0

--надо добавить возможность выбора 1 и 2 плашек оперативы
--вот бы как-то еще добавить примерное время завершения сборки робота
--надо бы еще сделать нормальную версию конструктора для магазина


-- Функция для обновления максимальной сложности
function update_max_difficulty(robot_lvl, cpu_lvl)
    if robot_lvl == 1 then
        max_difficulty = 12
    elseif robot_lvl == 2 then
        if cpu_lvl == 1 then
            max_difficulty = 18
        elseif cpu_lvl == 2 then
            max_difficulty = 24
        end
    elseif robot_lvl == 3 then
        if cpu_lvl == 1 then
            max_difficulty = 20
        elseif cpu_lvl == 2 then
            max_difficulty = 26
        elseif cpu_lvl == 3 then
            max_difficulty = 32
        end
    end
end

-- Функция для создания кнопок
function create_buttons()
    local x_start = 3
    local y_start = 3
    local columns = 4
    local x = x_start
    local y = y_start

    for i, component in ipairs(constants.choise_components) do
        local is_switched_button = component.btn_text:match("Процессор") or
                                   component.btn_text:match("Память") or
                                   component.btn_text:match("Диск") or
                                   component.btn_text:match("Корпус") or
                                   component.btn_text:match("полет") or
                                   component.btn_text:match("аккум")

        local button = {
            x = x,
            y = y,
            text = component.btn_text,
            tier = component.tier,
            difficult = component.difficult,
            button_pressed = false,
            switched_button = is_switched_button,
            fore = constants.colors.black,
            back = constants.colors.red,
            fore1 = constants.colors.white,
            back1 = constants.colors.green,
            name_craft = component.name_craft
        }

        table.insert(buttons, button)

        x = x + constants.BTN_WIDTH + 2
        if (i % columns) == 0 then
            x = x_start
            y = y + constants.BTN_HEIGHT + 1
        end
    end

end

-- Функция для отрисовки кнопок
function draw_buttons()
    constants.term.clear()
    -- Отрисовка кнопок компонентов
    for _, btn in ipairs(buttons) do
        constants.gpu.setForeground(btn.button_pressed and btn.fore1 or btn.fore)
        constants.gpu.setBackground(btn.button_pressed and btn.back1 or btn.back)
        constants.gpu.fill(btn.x, btn.y, constants.BTN_WIDTH, constants.BTN_HEIGHT, " ")
        constants.gpu.set(btn.x + 2, btn.y + math.floor(constants.BTN_HEIGHT / 2), btn.text .. "-" .. btn.difficult)
    end

    -- Отрисовка кнопок управления
    for _, ctrl_btn in ipairs(constants.control_buttons) do
        constants.gpu.setForeground(constants.colors.black)

        if ctrl_btn.text == "Сложность:" then
            constants.gpu.setBackground(constants.colors.gray)
            constants.gpu.fill(ctrl_btn.x, ctrl_btn.y, 32, constants.BTN_HEIGHT, " ")
            constants.gpu.set(ctrl_btn.x + 2, ctrl_btn.y + math.floor(constants.BTN_HEIGHT / 2), "Сложность: " .. current_difficulty .. "/" .. max_difficulty)
        else
            constants.gpu.setBackground(constants.colors.green)
            constants.gpu.fill(ctrl_btn.x, ctrl_btn.y, constants.BTN_WIDTH, constants.BTN_HEIGHT, " ")
            constants.gpu.set(ctrl_btn.x + 2, ctrl_btn.y + math.floor(constants.BTN_HEIGHT / 2), ctrl_btn.text)
        end

    end

    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
end

-- Функция для обработки нажатий
function handle_touch()
    local robot_lvl = tonumber(1)
    local cpu_lvl = tonumber(1)

    while true do
        local _, _, x, y = constants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.x + constants.BTN_WIDTH and y >= btn.y and y < btn.y + constants.BTN_HEIGHT then

                if btn.text:match("Корпус") then
                    robot_lvl = tonumber(string.sub(btn.text, -1))
                    update_max_difficulty(robot_lvl, cpu_lvl)

                    for _, check_btn in ipairs(buttons) do
                        if check_btn.tier > robot_lvl then
                            check_btn.button_pressed = false
                        end
                    end

                elseif btn.text:match("Процессор") then
                    cpu_lvl = tonumber(string.sub(btn.text, -1))
                    update_max_difficulty(robot_lvl, cpu_lvl)
                end

                if btn.tier <= robot_lvl then
                    if btn.switched_button then

                        for _, other_btn in ipairs(buttons) do
                            if other_btn.switched_button and other_btn.text:match(btn.text:sub(1, 4)) then
                                other_btn.button_pressed = false
                            end
                        end

                    end

                    btn.button_pressed = not btn.button_pressed
                end
                draw_buttons()
            end
        end

        for _, ctrl_btn in ipairs(constants.control_buttons) do
            if x >= ctrl_btn.x and x < ctrl_btn.x + constants.BTN_WIDTH and y >= ctrl_btn.y and y < ctrl_btn.y + constants.BTN_HEIGHT then
                if ctrl_btn.action == "start" then backend.start_assembling(buttons) end
                if ctrl_btn.action == "stop" then backend.stop_assembling() end
                if ctrl_btn.action == "clear" then backend.clear_components() end
                draw_buttons()
            end
        end
    end
end


-- Инициализация
create_buttons()
draw_buttons()
handle_touch()