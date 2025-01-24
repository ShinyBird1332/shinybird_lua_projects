--транспозер сканирует сундук на наличие свитков 
--(надо сделать так, чтоб он различал изученные и неизученные)
--если в слоте есть свиток, кидает его в выбрасыватель ботании (в сундук к выбрасывателю)
--свиток попадает на книгу, там пока работает печка и качает когнитио 
--(надо сделать простой способ фарма бумаги)
--после перемещения, с задержкой в секунду, адаптер начинает сканировать книгу
--в цикле, раз в 5 секунд, смотрим, сколько осталось каждого аспекта (не важны их названия)
--если все 3 по нулям, отдается команда роботу grab

--робот забирает свиток и передает его в итоговый сундук
--потом цикл продолжается на следующие слоты

local comp = require("component")
local sides = require("sides")
local event = require("event")

local trans = comp.transposer
local book = comp.book --------------------------

local side_chest_in = sides.south
local side_chest_out = sides.west

function scan_chest_in()
    for i = 1, trans.getInventorySize(side_chest_in) do
        local slot = trans.getStackInSlot(i)
        if slot and slot.label == "Название свитков" then --------------------------
            trans.transferItem(side_chest_in, side_chest_out, 1, i, i)
            os.sleep(1)
            scan_book()
            --тут надо дать команду роботу
        end
    end
end

function scan_book()
    local stop = false
    while not stop do
        for _, value in pairs(book.function_for_scan_book1()) do --------------------------
        local count = book.function_for_scan_book2(value) --------------------------
            if count and count > 0 then 
                stop = true
            end
        end
    end
end

function main()
    --это потом в цикл всунуть
    scan_chest_in()
end

main()