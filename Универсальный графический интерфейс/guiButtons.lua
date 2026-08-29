local guiButtons = {}

local guiConstants = dofile("guiConstants.lua")
local guiModuls = dofile("guiModuls.lua")

guiButtons.buttons = {}

function guiButtons.pass()
    return nil
end

function guiButtons.add_button(params, btn_params, func)
    table.insert(guiButtons.buttons, {params, btn_params, func})
    for index, value in ipairs(guiButtons) do
        print(index, value)
    end
end

function guiButtons.switch_button(buttons)
    --распарс - ЭТО ВРЕМЯНКА!!!!!!
    
    local btn = guiModuls.draw_button({
        start_x=70, 
        start_y=5, 
        width=30, 
        height=7,
        text="Кнопка 3|Переключаемая,|с доп. цветами",
        block_bg = guiButtons.buttons.click_bg,
        block_fg = guiButtons.buttons.click_fg
    }, {
        --switched_button = true
    }, guiButtons.pass)

    os.sleep(3)
    return true
    --сейчас кнопка не добавляется в общ таблицу... а надо ли, если это свич кнопка??
    --мб сделать универсальную функцию по добавлению кнопок в таблицу
    --guiButtons.add_button(параметры, окно)
end

function guiButtons.handler_button()
    --клик
    --свич
    --блок
    --наведение (В САМОМ КОНЦЕ)
    while true do
        local _, _, x, y = guiConstants.event.pull("touch")

        for _, btn in ipairs(guiButtons.buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then

                if guiButtons.buttons.switch_button then
                    guiButtons.switch_button(guiButtons.buttons)
                    guiModuls.print({ start_x = 30, start_y = 20, text = "switch_button"})
                else
                    local func = btn.btn_func
                    --guiButtons.buttons = {}
                    func()
                    return guiButtons.buttons
                end

            end
        end
        os.sleep(0.5)
    end
end

return guiButtons