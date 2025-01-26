--пользователь покупает жетон в обменнике
--будут жетоны разных номинатов:
--1 исследование - 20 монет
--5 исследований - 90 монет
--10 исследований - 180 монет
--20 исследований - 360 монет

local comp = require("component")
local sides = require("sides")

local tunnel = comp.tunnel
local redstone = comp.redstone
local book = comp.blockknowledgebook
local gpu = comp.gpu

local trans_sell = comp.proxy("be58a6a3-7241-4db7-bc27-b7186f16c3b8")
local trans_craft = comp.proxy("3e8df3a4-b961-4f26-914c-ff4f804adcd0")

local side_sell_in = sides.east
local side_sell_out = sides.north
local side_sell_back = sides.west
local side_sell_coin = sides.south

local side_chest_in = sides.south
local side_chest_out = sides.west

w, h = gpu.getResolution()

colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a
}

function scan_chest_in()
    for i = 1, trans_craft.getInventorySize(side_chest_in) do
        local slot = trans_craft.getStackInSlot(side_chest_in, i)
        if slot and slot.label == "Research Notes" then
            gpu.set(8, 10, "Начинаем изучение свитка...")

            trans_craft.transferItem(side_chest_in, side_chest_out, 1, i, i)
            os.sleep(1)
            scan_book()
            tunnel.send("grab", 1)
        end
    end
    os.sleep(7)
end

function scan_book()
    while true do
        gpu.set(8, 12, "Идет изучение свитка. Это долгий процесс. Осталось:")
        local res = 0
        for i, value in pairs(book.getAspects()) do 
            
            local count = book.getAspectCount(value) 
            gpu.set(8, 12 + i, value .. ": " .. count)
            res = res + count
        end

        os.sleep(5)
        if res == 0 then 
            gpu.set(8, 16, "Исследование изучилось! Оно должно появиться позади вас.")
            break
        end
    end
end

function draw_interface()
    gpu.setForeground(colors.white)
    gpu.setBackground(colors.black)
    gpu.fill(1, 1, w, h, " ")
    gpu.set(8, 2, "Ожидаю жетоны исследований...")
end

function wait_coins()
    while true do
        draw_interface()
        local size = trans_sell.getStackInSlot(side_sell_coin, 1).size - 1

        if size + 1 > 1 then
            gpu.set(8, 4, "Получено " .. size .. " жетонов. Ожидаю свтики...")
            trans_sell.transferItem(side_sell_coin, side_sell_out, size, 1, trans_sell.getInventorySize(side_sell_in) - 1)
            gpu.set(8, 6, "После того, как вы сложите все свитки, нажмите на кнопку")
            repeat
                os.sleep(0/5)
            until redstone.getInput(sides.east) > 0

            local count = 0
            for i = 1, trans_sell.getInventorySize(side_sell_in) do
                if trans_sell.getStackInSlot(side_sell_in, i) then count = count + 1 end
            end

            if size > count then
                gpu.set(8, 8, "Вы заплатили за " .. size " свитков, но было получено только " .. count .. " свитков. Вы уверены?\nЕсли да, нажмите кнопку еще раз")
                repeat
                    os.sleep(0.5)
                until redstone.getInput(sides.east) > 0
            else
                gpu.set(8, 8, "Идет перенос " .. size .. " свитков. Остальные вылетят левее от вас.")
            end
            
            for i = 1, size do
                trans_sell.transferItem(side_sell_in, side_sell_out, 1, i, i)
            end
            for i = 1, trans_sell.getInventorySize(side_sell_in) do
                local item = trans_sell.getStackInSlot(side_sell_in, i)
                if item then
                    trans_sell.transferItem(side_sell_in, side_sell_back, 64, i, i)
                end
            end
        end
        scan_chest_in()
        os.sleep(1)
    end
end

while true do
    wait_coins()
    os.sleep(1)
end

--!ребят, открываю уникальный warp tc! Автоматическо изучение любых свитков из таумкрафта!