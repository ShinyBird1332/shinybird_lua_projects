--powered by ShinyBird368
local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local tract = comp.tractor_beam
local i_c = comp.inventory_controller

local TIME_GRAB = 2 --количество секунд, сколько робот будет собирать выпавшие предметы
local COUNT_HITS = 25 --количество ударов за 1 цикл
local NEED_CHARGE = 0.3 --уровень прочности меча, на котором требуется зарядка
local TIME_SLEEP = 15
local SIDE = sides.west
local NAME_SWORD = "Diamond Pickaxe"

function attack()
    for _ = 1, COUNT_HITS do
        robot.swing()
        os.sleep(0.5)
    end
end

function grab_item()
    for _ = 1, TIME_GRAB do
        tract.suck()
        os.sleep(1)
    end
end

function check_storage()
    for i = 1, robot.getInventorySize() do
        robot.select(i)
        if robot.count() == 0 then return true end
    end
end

function check_charge() -- надо добавить правильный поиск сабли в сундуке b akfrcf
    local function t()
        for i = 1, i_c.getInventorySize(3) do
            local item = i_c.getStackInSlot(3, i)
            if item and item.label == NAME_SWORD then
                i_c.suckFromSlot(3, 1, 1)
                return true
            end
        end
        return false
    end
    local selected_slot = robot.select()
    robot.select(16)

    print(robot.durability())

    if robot.durability() < NEED_CHARGE then
        i_c.equip()
        robot.turnRight()
        robot.drop()

        while t() == false do
            os.sleep(3)
        end

        robot.select(selected_slot)  
        robot.turnLeft()  
        i_c.equip()
    end
end

function transfer_to_storage()
    robot.turnLeft()
    for i = 1, 15 do -- добавить проверку есть ли кондер в ласт слоте
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnLeft()
end

function main()
    while check_storage() do
        attack()
        grab_item()
        check_charge()
    end
    transfer_to_storage()
end

while true do
    main()
end
