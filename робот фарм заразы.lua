--перед запуском робота обязательно добавьте себя в свой приват в качестве учасника
--/rg addmember <ваш_приват> <ваш_ник>
--rg addmember -n <ваш_приват> <ваш_ник>-robot
--rg addmember -n <ваш_приват> [OpenComputers]

local comp = require("component")
local robot = require("robot")

local SIZE = 15 --размеры комнаты (обязательно НЕчетные!)
local COUNT_FLOOR = 1 --недоработанная тема, работает только с 1 этажом
local NEED_CHARGE = 0.2 --процент прочности лопаты для замены
local TIME_SLEEP = 20 --время ожидания новых волокон


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
  
function transfer()
    robot.turnLeft() 
    for i = 1, 16 do 
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnRight()
end

function run(distance) 
    for _ = 1, distance do
        repeat
            robot.swing()
        until not robot.detect()
        robot.forward()
    end
end

function move_up()
    for _ = 1, 3 do
        repeat
            robot.swingUp()
        until not robot.detectUp()
        robot.up()
    end
end

function move_down(i)
    for _ = 1, 3 do
        repeat
            robot.swingDown()
        until not robot.detectDown()
        robot.down()
    end
end

function farm()
    for _ = 1, COUNT_FLOOR do
        for _ = 1, SIZE do
            run(SIZE - 1)
            robot.turnAround()
            run(SIZE - 1)

            robot.turnLeft()
            run(1)
            robot.turnLeft()
        end
        robot.turnLeft()
        run(SIZE)
        robot.turnRight()

        move_up()
    end
    move_down(SIZE * 3)
end

function main()
    while true do
        farm()
        transfer()
        check_charge()
        os.sleep(COUNT_FLOOR * SIZE * 1)
    end
end

main()
