local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local tract = comp.tractor_beam
local i_c = comp.inventory_controller

local TIME_SLEEP = 20
local STOP_USING_HOE = 0.2

local SLOT_SAPLING = 1 -- слот для саженца. На момент начала работы, должно быть 2 и более.
local SLOT_HOE = 16 -- слот для мотыги роста

function robot_drop()
    robot.turnAround()
    for i = 2, 15 do
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnAround()
end

function grab_item()
    for _ = 1, TIME_SLEEP do
        tract.suck()
        os.sleep(1)
    end
end

function detect_block()
    _, type_block = robot.detect()
    return type_block
end

function check_charge()
    local prev_slot = robot.select()
    local durability = robot.durability()

    if durability and durability < STOP_USING_HOE then
        print("Прочность инструмента: " .. (durability * 100) .. "%. Необходимо зарядить.")

        robot.turnAround()

        print("Инструмент отправлен на зарядку. Ожидание...")
        i_c.equip()
        robot.drop()

        repeat
            os.sleep(time_sleep)
        until i_c.getStackInSlot(sides.front, 1)
        i_c.suckFromSlot(sides.front, 1, 1)
        i_c.equip()

        print("Инструмент успешно заряжен и возвращён.")
        robot.turnAround()
    else
        print("Инструмент в хорошем состоянии. Прочность: " .. (durability and (durability * 100) or "недоступно") .. "%")
    end
    robot.select(prev_slot)
end

function main()
    robot.select(SLOT_SAPLING)
    robot.place()
    robot.select(SLOT_HOE)

    i_c.equip()
    check_charge()

    while detect_block() ~= "solid" do
        robot.use()
        os.sleep(0.5)
    end

    i_c.equip()
    check_charge()
    robot.swing()
    grab_item()
    robot_drop()
end

while true do
    main()
end
