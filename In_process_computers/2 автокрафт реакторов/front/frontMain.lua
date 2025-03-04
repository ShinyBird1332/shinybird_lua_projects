local frontMain = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")
local craftReactor = dofile("craftReactor.lua")
local buttons = {}

local colors = constants.colors

function btn_new_reactor()
    craftReactor.main()
end

function btn_info_reactors()
    frontControl.main()
end

function frontMain.draw_start_interfase() --160
    main_w = constants.w - 20 - 10
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    guiModuls.draw_border(10, 5, constants.w - 20, constants.h - 10, "  MAIN MENU  ")

    guiModuls.draw_border(14, 7, main_w // 3, constants.h - 24, "  NEW REACTOR  ")
    guiModuls.draw_border(18, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(24, 12, "Постройка нового реактора.")
    constants.gpu.set(24, 14, "Перед постройкой убедитесь,")
    constants.gpu.set(25, 16, "что у вас есть ~60 000mb")
    constants.gpu.set(32, 18, "материи.")
    table.insert(
        buttons, guiModuls.draw_button(
        18, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_new_reactor)
    )
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(28, 27, "Начать постройку")

    guiModuls.draw_border(main_w // 3 + 16, 7, main_w // 3, constants.h - 24, "  REACTOR CONTROL PANEL  ")
    guiModuls.draw_border(main_w // 3 + 20, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(main_w // 3 + 30, 14, "Панель управления")
    constants.gpu.set(main_w // 3 + 33, 16, "реактором.")
    table.insert(
        buttons, guiModuls.draw_button(
        main_w // 3 + 20, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_info_reactors)
    )
    
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(main_w // 3 + 26, 27, "Открыть панель управления")

    guiModuls.draw_border(main_w // 3 * 2 + 18, 7, main_w // 3, constants.h - 24, "  CHECK COMPONENTS  ")
    guiModuls.draw_border(main_w // 3 * 2 + 22, 9, main_w // 3 - 8, 11, "")
    constants.gpu.set(main_w // 3 * 2 + 30, 14, "Проверка целостности")
    constants.gpu.set(main_w // 3 * 2 + 37, 16, "системы.")
    table.insert(
        buttons, guiModuls.draw_button(
        main_w // 3 * 2 + 22, 22, main_w // 3 - 8, 9, "", colors.gray, colors.green, colors. black, btn_info_reactors)
    )
    constants.gpu.setBackground(colors.green)
    constants.gpu.set(main_w // 3 * 2 + 34, 27, "Начать проверку")

    table.insert(
        buttons, guiModuls.draw_button(
        14, 34, main_w + 3, 9, "", colors.gray, colors.green, colors. black, btn_info_reactors)
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