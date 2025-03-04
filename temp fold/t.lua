local comp = require("component")
local sides = require("sides")

local main_trans_craft = comp.proxy("d5b7ecca-245c-4796-868c-0f98c1b7c03d")

print("Проверяем размер инвентаря:", main_trans_craft.getInventorySize(sides.up))

function check_count(component)
    local item_count = 0
    print("Ищем компонент:", component) -- Проверяем, что программа ищет

    for i = 1, main_trans_craft.getInventorySize(sides.up) do
        local item = main_trans_craft.getStackInSlot(sides.up, i)

        if item then
            print("Слот", i, "->", item.label, "(количество:", item.size .. ")") -- Логируем найденное
        else
            --print("Слот", i, "пуст")
        end

        if item and item.label == component then
            item_count = item_count + item.size
        end
    end

    print("Всего найдено:", item_count)
    return item_count
end

check_count("Reactor Casing")