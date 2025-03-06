local craftReactor = {}

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")

function transfer_fluid(count, name_trans, fluid_cost)
    local mb_cost = count * fluid_cost 
    local result = 0
    constants.gpu.set(34, 18, "Стоимость в материи " .. mb_cost .. " mb")
    while result < mb_cost do
        local _, c = name_trans.transferFluid(constants.sides.down, constants.sides.up, mb_cost - result)
        result = result + c
        constants.gpu.set(34, 20, "Перенесено " .. result .. " mb. Не хватает " .. mb_cost - result .. "mb.")
        os.sleep(5)
    end
end

function check_or_wait(state)
    for component, craft in pairs(constants.trans_craft) do
        constants.gpu.fill(34, 14, 50, 20, " ")
        constants.gpu.set(34, 14, "Компонент: " .. component)
        constants.gpu.set(34, 16, "Сканирование сундука...")

        local item_count = check_count(component)

        if state == "check" then
            check_need_items(craft, component, item_count)
        elseif state == "wait" then
            wait_need_items(craft, component)
        end        
    end
end

function check_count(component)
    local item_count = 0
    for i = 1, constants.main_trans_craft.getInventorySize(constants.sides.up) do
        local item = constants.main_trans_craft.getStackInSlot(constants.sides.up, i)

        if item and item.label == component then
            item_count = item_count + item.size
        end
    end
    return item_count
end

function wait_need_items(craft, component)
    local item_count = 0
    while craft.count > item_count do
        item_count = check_count(component)
        local count_craft = craft.count - item_count
        constants.gpu.fill(34, 16, 50, 20, " ")
        constants.gpu.set(34, 16, "Осталось: " .. count_craft .. " штук.")
        os.sleep(3)
    end
end

function check_need_items(craft, component, item_count)
    if craft.count > item_count then
        local count_craft = craft.count - item_count

        constants.gpu.set(34, 16, "Осталось создать: " .. count_craft .. " штук")

        transfer_fluid(craft.count - item_count, craft.transposer, craft.mb)
    else
        constants.gpu.set(34, 16, "Крафт: " .. component .. " не требуется")
    end
end

function check_redstone()
    local count_fluid = constants.trans_tank.getTankLevel(constants.sides.up, 1)
    constants.gpu.set(40, 40, "Уровень жидкого красного камня: " .. count_fluid .. "/" .. constants.liquid_redstone .. " mb")
    while count_fluid < constants.liquid_redstone do
        constants.gpu.set(40, 40, "Уровень жидкого красного камня: " .. count_fluid .. "/" .. constants.liquid_redstone .. " mb")
        os.sleep(3)
    end
end

function craftReactor.main()
    constants.modem.broadcast(4, "dig")

    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    guiModuls.draw_border(30, 5, constants.w - 60, constants.h - 10, "")
    guiModuls.draw_border(30, 5, constants.w - 60, 5, "")
    constants.gpu.set(constants.w // 2 - 8, 8, "CRAFT COMPONENTS")
    constants.gpu.set(40, 40, "Уровень жидкого красного камня: 0/0 mb")
    constants.gpu.set(34, 12, "Статус работы: проверка и создание.")
    check_or_wait("check")
    constants.gpu.fill(34, 14, 50, 20, " ")
    constants.gpu.set(34, 12, "Статус работы: ожидание завершения создания.")
    check_or_wait("wait")
    constants.gpu.fill(34, 14, 50, 20, " ")
    constants.gpu.set(34, 14, "Все компоненты готовы. Проверка количества жидкого красного камня...")
    check_redstone()
    constants.gpu.fill(34, 12, 70, 20, " ")
    constants.gpu.set(34, 12, "Все приготовления завершены. Запуск робота для постройки реактора.")
    --и забыл про прогрессбар
    --надо считать в процентах, сколько еще времени осталось
    --типа всего блоков нужно 8403, готово 1244, из этого считаем процент
    --и вот тут понеслась
    local _, _, _, _, _, message = event.pull("modem_message")
    if tostring(message) == "dig_ready" then
        print("Got a message: " .. tostring(message))
        constants.modem.broadcast(4, "build")
    end
end

return craftReactor