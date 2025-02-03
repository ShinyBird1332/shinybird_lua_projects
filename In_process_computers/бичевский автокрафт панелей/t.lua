local comp = require("component")
local sides = require("sides")

local tunnel = comp.tunnel
local redstone = comp.redstone

local trans_double_compress = comp.proxy("d87e38a0-b999-417a-a25c-f325c20f0e09")
local trans_main_pillar = comp.proxy("fe7c8cca-2b15-4db6-b19d-2c3f3d59c269")

local base_essential = {
    ["perditio"] = comp.proxy("6a520861-3573-4d9d-913c-3ce988963edf"),
    ["aqua"] = comp.proxy("dd2030f9-9304-4b54-80aa-c7a4d97b8a94"),
    ["terra"] = comp.proxy("228c03e0-b51c-433a-937d-5ed2399684d2"),
    ["ignis"] = comp.proxy("28040af1-b47c-48d7-8f7d-fab21dcd8f4c"),
    ["aer"] = comp.proxy("d78431bf-622b-46f9-b041-4091751aa1ee"),
    ["ordo"] = comp.proxy("638c9496-9c2f-4b68-80d3-a11982435238")
}


function check_double_compressed()
    print("Проверяем наличие 9 дважды сжатых панелей.")
    for i = 1, trans_double_compress.getInventorySize(sides.down) do
        local item = trans_double_compress.getStackInSlot(sides.down, i)
        if item and item.label == "Double Compressed Solar Panel" and item.size >= 9 then
            print("Панели найдены. Начинаем перенос на пьедесталы.")
            trans_double_compress.transferItem(sides.down, sides.up, 9, i, i)
            return true
        end
    end
    return false
end

function activate_matrix()
    print("Отдаем команду роботу, активировать матрицу")
    redstone.setOutput(sides.down, 15)
    os.sleep(1)
    redstone.setOutput(sides.down, 0)
    ----------------
    os.sleep(10)
    while true do
        item = trans_main_pillar.getStackInSlot(sides.up, 1)
        if item and item.label == "Triple Compressed Solar Panel" then
            print("Трижды сжатая панель успешно создана. Переносим в алхимическую конструкцию.")
            trans_main_pillar.transferItem(sides.up, sides.down, _, 1, 1)
            break
        end
        os.sleep(1)
    end
end

function check_base_essential()
    print("Проверяем наличие 8 эссенции каждого базового типа.")
    while true do
        local res = true
        for key, value in pairs(base_essential) do
            if value.getEssentiaAmount(sides.up) < 8 then
                print("Нехватает эссенции: " .. key)--------------------------------заменить принт на гпу
                res = false
            end
        end
        if res then
            print("Эссенции достаточно. Начинаем процесс наполнения.")
            activate_matrix()
            break
        end
        os.sleep(5)
    end
end

function main()
    while true do
        if check_double_compressed() then
            check_base_essential()
        end
        os.sleep(5)
    end
end

main()
