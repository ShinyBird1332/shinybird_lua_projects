local guiButtons = {}

local guiConstants = dofile("guiConstants.lua")
local guiModuls = dofile("guiModuls.lua")

function guiButtons.pass()
    return nil
end

function guiButtons.switch_button(buttons)
    --распарс - ЭТО ВРЕМЯНКА!!!!!!
    if buttons.switch_button == true then
        local btn = guiModuls.draw_button({
            start_x=70, 
            start_y=5, 
            width=30, 
            height=7,
            text="Кнопка 3|Переключаемая,|с доп. цветами",
            block_bg = buttons.click_bg,
            block_fg = buttons.click_fg
        }, {
            --switched_button = true
        }, guiButtons.pass)

        guiModuls.draw_button(btn)
        os.sleep(3)
        return true       
    end
    

end

function guiButtons.handler_button(buttons)
    --работает с отрисовкой новых окон и выполнением функций   
    --не работает:
    --переключаемая кнопка switch_button
    --залоченая кнопка button_block (надо по умолчанию сделать в серых тонах)
    while true do
        local _, _, x, y = guiConstants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then

                if guiButtons.switch_button(buttons) == true then
                    return 1
                else
                    local func = btn.btn_func
                    buttons = {}
                    func()
                    return buttons
                end

            end
        end
        os.sleep(0.5)
    end
end

return guiButtons