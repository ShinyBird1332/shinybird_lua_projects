local frontMain = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")
local frontClearBee = dofile("frontClearBee.lua")
local frontNewBee = dofile("frontNewBee.lua")
local buttons = {}

local colors = constants.colors

function btn_big_hive()
    
end

function btn_new_bee()
    
end

function btn_clear_bee()
    frontClearBee.draw_buttons()
end

function frontMain.draw_start_interfase()
    main_w = constants.w - 20 - 10
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    guiModuls.draw_border(10, 5, constants.w - 20, constants.h - 10, "  MAIN MENU  ")

    guiModuls.draw_border(14, 7, main_w // 3, constants.h - 24, "  BIG HIVE  ")
    guiModuls.draw_border(18, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(23, 12, "Вывод пчел для большого улья")
    constants.gpu.set(32, 14, "Имперская")
    constants.gpu.set(31, 16, "Трудолюбивая")
    constants.gpu.set(32, 18, "Разводимая")
    table.insert(
        buttons, guiModuls.draw_button(
        18, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_big_hive)
    )
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(32, 27, " Перейти ")

    guiModuls.draw_border(main_w // 3 + 16, 7, main_w // 3, constants.h - 24, "  NEW BEE  ")
    guiModuls.draw_border(main_w // 3 + 20, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(main_w // 3 + 28, 14, "Заказать определенную")
    constants.gpu.set(main_w // 3 + 35, 16, "пчелу")
    table.insert(
        buttons, guiModuls.draw_button(
        main_w // 3 + 20, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_new_bee)
    )
    
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(main_w // 3 + 34, 27, "Перейти")

    guiModuls.draw_border(main_w // 3 * 2 + 18, 7, main_w // 3, constants.h - 24, "  CLEAR BEE  ")
    guiModuls.draw_border(main_w // 3 * 2 + 22, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(main_w // 3 * 2 + 32, 14, "Приведение пчелы")
    constants.gpu.set(main_w // 3 * 2 + 33, 16, "к чистым генам.")
    table.insert(
        buttons, guiModuls.draw_button(
        main_w // 3 * 2 + 22, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_clear_bee)
    )
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(main_w // 3 * 2 + 36, 27, "Перейти")

    table.insert(
        buttons, guiModuls.draw_button(
        14, 34, main_w + 3, 9, "", colors.gray, colors.green, colors. black, btn_clear_bee)
    )

    constants.gpu.setBackground(colors.green)
    constants.gpu.set(main_w // 2 + 7, 39, "Открыть документацию")

    while true do
        local _, _, x, y = constants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then
                buttons = {}
                btn.btn_func()
                break
            end
        end
    end
end

return frontMain