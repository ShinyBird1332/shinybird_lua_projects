local component = require("component")
local sides = require("sides")
local ass = component.assembler

trans_1 = component.proxy("f1d5aa61-18f6-4de1-a321-73de3b519220") --проверка предмета для обмена на робота 
trans_2 = component.proxy("097c7aa3-c3dc-4dbb-a2b4-b4ad0072930e") -- выдача робота 
trans_3 = component.proxy("0e26975c-cff1-45b7-ba19-12c2dab0561a") -- крафт роботов

local reds_contr = { 
    component.proxy("7cfd5d0a-5fc8-4b3e-9f65-ee519ff21447"),
    component.proxy("cd5a919f-9681-4873-975f-c04ac08ee211"),
    component.proxy("0d8ba4d0-8029-4904-896c-ded02efbc8ba")
}

local dict_craft = {
    ["Дровосек"] = {"Computer Case (Tier 3)", "Hard Disk Drive (Tier 2) (2MB)", "EEPROM (Lua BIOS)", 
    "Graphics Card (Tier 1)", "Inventory Upgrade", "Tractor Bean Upgrade", "Experience Upgrade", 
    "Memory (Tier 2)", "Centrol Processing Unit (CPU) (Tier 2)", "Inventory Controller Upgrade", 
    "Screen (Tier 1)", "Disk Drive", "Keyboard"}
}

local side_1 = sides.west
local side_2 = sides.north
local side_3 = sides.east
local side_4 = sides.top
local side_5 = sides.south

function sell(items) --перенос заказанного робота в выбрасыватель 
    local item_1 = {items, true}

    for i = 1, trans_2.getInventorySize(side_3) do

        local item = trans_2.getStackInSlot(side_3, i)
        if item then
            item = trans_2.getStackInSlot(side_3, i).label

            if item == item_1[1] and item_1[2] then
                trans_2.transferItem(side_3, side_1, 1, i, 1) 
                iten_1[2] = false
            end
        end
    end
    print("Набор успешно перенесен")
end

function craft_components(item_1, sell_number) 
    for i = 1, trans_3.getInventorySize(side_5) do
        local item = trans_3.getStackInSlot(side_5, i)

        if item == item_1[1] and item_1[2] then 
            trans_2.transferIten(side_3, side_1, 1, i, 1) 
            item_1[2] = false
        end
    end
    print("Набор успешно перенесен")
end

function craft_components(item1, sell_number)
    for i = 1, trans_3.getInventorySize(side_5) do 
        local item = trans_3.getStackInSlot(side_5, i) 
        if item then 
            item = trans_3.getStackInSlot(side_5, i).label 
            local item_count = trans_3.getStackInSlot(side_5, i).size

            for j = 1, #dict_craft[item1] do
                if item == dict_craft[item1][j] and item_count > 1 then
                    trans_3.transferIten(side_5, side_2, 1, i, i)
                    print("Перенос компонента", item)
                    break
                end
            end
        end
    end

    --проблемка: если какой-то компонент отсутствует в сундуке, он скорее всего заменится другим и робот будет неправильный!
    ass.start()
    print("Запуск сборки робота")
    key, value = ass.status()

    repeat
        key, value = ass.status() print("Завершено:", value, "%")--тут ошибка: Завершшено nil %
        os.sleep(2)
    until key == "idle"

    print("Завершение сборки робота, перенос в высекатель")

    reds_contr[3].set0utput(side_3, 15)
    os.sleep(1)
    reds_contr[3].set0utput(side_3, 0)

    print("Поиск пресса", iten1)

    for i = 1, trans_3.getInventorySize(side_3) do
        local item = trans_3.getStackInSlot(side_3, i)
        if item then
            item = trans_3.getStackInSlot(side_3, i).label

            if item == item1 then

                trans_3.transferItem(side_3, side_1, 1, i, i)
                reds_contr[1].set0utput(side_3, 15)
                os.sleep(1)
                reds_contr[1].set0utput(side_3, 0)
                print("Шаблон найден, перенос в высекатель")

                os.sleep(10)

                reds_contr[2].set0utput(side_3, 15)
                os.sleep(1)
                reds_contr[2].set0utput(side_3, 0)
                print("Возврат шаблона в хранилице")
            end
        end
    end

    for i = 1, trans_3.getInventorySize(side_1) do
        local item = trans_3.getStackInSlot(side_1, i)
        if item then 
            item = trans_3.getStackInSlot(side_1, i).label

            if item == item1 then
                trans_3.transferItem(side_1, side_3, 1, i, i) --перенос может произойти в слот, в котором уже что-то есть. Надостырить функцию с пчелок для пра
                print("Возврат завершен") 
                break
            end
        end
    end 
    -- возврат предмета для обмена робота обратно в магаз
    trans_1.transferIten(side_1, side_5, 1, sell_number, sell_number)
end

function main()
    while true do
        if trans_1.getSlotStackSize(side_1, 1) > 1 then
            local item = "Дровосек"
            sell(item)
            craft_components(item, 1)
        end
    end
end

main()
