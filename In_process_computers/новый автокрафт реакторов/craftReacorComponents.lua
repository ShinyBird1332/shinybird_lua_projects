local constants = dofile("constants.lua")

function transfer_fluid(count, name_trans, fluid_cost)
    local g = count * fluid_cost 
    local result = 0
    print("Стоимость в материи", g, "mb")
    while result < g do
        local _, c = name_trans.transferFluid(constants.side_trans_in_mat, constants.side_trans_out_mat, g - result)
        result = result + c
        print("Перенесено", result, "mb.", "Не хватает", g - result, "mb.")
        os.sleep(5)
    end
end

function check_or_wait(state)
    for component, craft in pairs(constants.trans_craft) do
        print("Проверяем наличие " .. component .. " " .. craft.count .. " штук")

        local item_count = check_count(component)

        if state == "check" then
            check_need_items(craft, component, item_count)
        elseif state == "wait" then
            wait_need_items(craft, component, item_count)
        end

        print("======================================")
        
    end
end

function check_count(component)
    local item_count = 0
    for i = 1, constants.main_trans_craft.getInventorySize(constants.side_trans_result_craft) do
        local item = constants.main_trans_craft.getStackInSlot(constants.side_trans_result_craft, i)

        if item and item.label == component then
            item_count = item_count + item.size
        end
    end
    return item_count
end

function wait_need_items(craft, component, item_count)
    while craft.count < item_count do

        local count_craft = craft.count - item_count
        print("Осталось: " .. component .. " " .. count_craft .. " штук.")
        os.sleep(3)
    
    end
end

function check_need_items(craft, component, item_count)
    if craft.count > item_count then
        local count_craft = craft.count - item_count
        print("Недостаточно ресурсов: " .. component .. " " .. count_craft .. " штук.")

        print("Крафтим: " .. component .. " " .. craft.count - item_count .. " штук.")
        transfer_fluid(craft.count - item_count, craft.transposer, craft.mb)
    else
        print("Крафт: " .. component .. "  не требуется")
    end
end

function check_redstone()
    count_fluid = constants.main_trans_craft.getTankLevel(constants.side_trans_redstone_storage, 1)
    while count_fluid < constants.liquid_redstone do
        print("Жидкого редстоуна недостаточно! Не хватает " .. liquid_redstone - count_fluid .. " mb")
        os.sleep(3)
    end
    print("Жидкого редстоуна достаточно!")

end

function main()
    --check_or_wait("check") --проверяем наличие всех ресурсов
    --print("\n" .. "Ожидание завершения крафта компонентов....")
    --check_or_wait("wait") --ждем завершения создания необходимых компонентов
    --check_redstone() --проверяем уровень жиидкого редстоуна
    return true
end

main()