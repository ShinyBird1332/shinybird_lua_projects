--перед запуском робота обязательно добавьте себя в свой приват в качестве учасника
--/rg addmember <ваш_приват> <ваш_ник>
--rg addmember -n <ваш_приват> <ваш_ник>-robot
--rg addmember -n <ваш_приват> [OpenComputers]

local comp = require("component")
local robot = require("robot")

local SIZE = 15 -- размеры квадратной комнаты
local COUNT_FLOOR = 1 -- количество этажей для фарма
local NEED_CHARGE = 0.2 -- процент прочности лопаты для замены
local TIME_SLEEP = 20 -- время ожидания новых волокон

constants.actions = {
    ["func_forward"] = {constants.robot.swing, constants.robot.detect, constants.robot.forward},
    ["func_up"] = {constants.robot.swingUp, constants.robot.detectUp, constants.robot.up},
    ["func_down"] = {constants.robot.swingDown, constants.robot.detectDown, constants.robot.down}
}


function check_charge()
    if robot.durability() < NEED_CHARGE then
        robot.turnLeft()
        robot.drop()
        os.sleep(TIME_SLEEP)
        print(i_c.suckFromSlot(SIDE, 1, 1))
        robot.select(selected_slot)
        robot.turnRight()  
    end
end
  
function transfer_shards()
    robot.turnLeft() 
    for i = 1, robot.getInventorySize() do 
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnRight()
end

function run(distance, direct) 
    for _ = 1, distance do repeat_swing(direct) end
end

function repeat_swing(direction)
    local action = actions["func_" .. direction] 
    local swing_func, detect_func, move_func = table.unpack(action)

    repeat
        swing_func()
        os.sleep(0.2)
    until not detect_func()
    move_func()
end

function farm_shards()
    for _ = 1, COUNT_FLOOR do
        for _ = 1, SIZE do
            run(SIZE, "forward")
            robot.turnAround()
            run(SIZE, "forward")

            robot.turnRight()
            run(1, "forward")
            robot.turnRight()
        end
        robot.turnLeft()
        run(SIZE, "forward")
        robot.turnRight()

        run(3, "up")
    end
    run(3 * COUNT_FLOOR, "down")
end

function main()
    while true do
        farm_shards()
        transfer_shards()
        check_charge()
        os.sleep(TIME_SLEEP)
    end
end

main()
