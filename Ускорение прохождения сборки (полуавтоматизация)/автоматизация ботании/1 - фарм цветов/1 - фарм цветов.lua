local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local crafting = comp.crafting

local flower_name = "Mystical"

--начинаем с того, что справа есть 2 цветка и ступка, а сзади только кости


--повернуться направо --готово
--скинуть в сундук справа все цветы (надо придумать ортировку, чтоб они стакались все) --готово
--(мб сначала забирать все цветы, потом складывать их орбратно) -- готово

--взять с сундука первый стак в цветками (в 1-й слот)
--скрафтить лепестков столько, сколько цветков (но не больше 64) (минимум 2 цветка)
--взять с сундука справа ступку и положить во второй слот
--скрафтить пыли столько, сколько лепестков
--убрать ступку в сундук справа
--вовернуться направо
--проверить, есть ли костная мука в сундуке сзади
--если костной муки меньше стака, скрафтить стак
--взять n костной муки, где n = кол-во цветков / 4
--разделить пыль на 4 и заскидать её на 2 3 4 и 5 слоты
--скрафтить предметов столько, сколько костной муки
--поместить её в слот инструмента#############################################
--запустить цикл столько раз, сколько удобрений

--вперед на 3
--заюзить удобрение########################################
--назад, 2 прямо, направо, 3 прямо, направо
--в цикле проходим 7 на 7
--назад, 3 прямо, налево, 1 прямо, разворот


function grab_all_flowers()
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(flower_name) then
            i_c.suckFromSlot(sides.front, i, _)
        end
    end
end

function suck_all_flowers()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)

        if item and item.label:find(flower_name) then
            robot.select(i)
            robot.drop()
        end
    end
    robot.select(1)
end

function grab_one_flower()
    local count_flowers = 0
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(flower_name) and count_flowers < 2 then
            i_c.suckFromSlot(sides.front, i, 1)
            count_flowers = count_flowers + 1
        end
    end
end

function grab_one_stack_flower()
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(flower_name) then
            
            if item.size > 1 then
                if item.size // 2 * 2 > 32 then c = 32 else c = item.size // 2 * 2 end
                i_c.suckFromSlot(sides.front, i, c)
                return "same"
            else
                grab_one_flower()
                return "different"
            end
        end
    end
end

function craft_dust(param)
    if param == "same" then
        crafting.craft()
    elseif param == "different" then
        robot.select(2)
        robot.transferTo(4)
        robot.select(8)
        crafting.craft()
        robot.select(4)
        robot.transferTo(1)
        crafting.craft()
        robot.select(8)
        robot.transferTo(2)
        robot.select(1)

        for i = 1, i_c.getInventorySize(sides.front) do
            local item = i_c.getStackInSlot(sides.front, i)

            if item and item.label:find("Pestle and Mortar") then
                i_c.suckFromSlot(sides.front, i, 1)
                break
            end
        end
        robot.select(8)
        crafting.craft()
        robot.select(4)
        robot.transferTo(2)
        crafting.craft()
        robot.select(1)
        robot.drop()
        robot.select(4)
        robot.transferTo(2, 1)
        robot.transferTo(3, 1)
        robot.select(8)
        robot.transferTo(5, 1)
        robot.transferTo(6, 1)
    end
end

function main()
    robot.select(1)
    robot.turnRight()
    grab_all_flowers()
    suck_all_flowers()
    local param = grab_one_stack_flower()
    craft_dust(param)



    robot.turnLeft()
end

main()
