--перед запуском робота обязательно добавьте себя в свой приват в качестве учасника
--/rg addmember <ваш_приват> <ваш_ник>

local comp = require("component")
local robot_lib = require("robot")
local g = comp.generator

--размеры комнаты (обязательно четные!)
local x_size = 3
local y_size = 3
local z_size = 3

function eat()
    local selectedSlot = robot_lib.select()
    robot_lib.select(16)
    while robot_lib.count() < 1 do
        os.sleep(1)
        print("Нет топлива, хочу кушать!")
    end

    if g.count() < 2 then
        g.insert(8)
        robot_lib.select(selectedSlot)
    end
end

function fillChest()
    local selectedSlot = robot_lib.select()
    robot_lib.select(15)
    robot_lib.placeDown()
    for k = 1, 14 do
        robot_lib.select(k)
        robot_lib.dropDown()
    end
    robot_lib.select(selectedSlot)
end
  
function checkInv()
    if robot_lib.count(14) > 0 then
        fillChest()
    end
end

function run()
    repeat
        robot_lib.swing()
    until not robot_lib.detect()
    robot_lib.forward()
end

function rotate()
    if c % 2 == 0 then
        robot_lib.turnRight()
        run()
        robot_lib.turnRight()
    else
        robot_lib.turnLeft()
        run()
        robot_lib.turnLeft()
    end
end

function rotate_end()
    robot_lib.turnRight()
    for i = 0, y_size - 1 do        
        run()
    end
    robot_lib.turnRight()
end

function move_up()
    repeat
        robot_lib.swingUp()
    until not robot_lib.detectUp()
    robot_lib.up()
end

function main()
    c = 0
    for z = 0, z_size - 1 do
        for y = 0, y_size do
            for x = 0, x_size - 1 do
                run()
                checkInv()
                eat()
            end
            if y ~= y_size then
                rotate()
            else
                rotate_end()
            end   
            c = c + 1   
        end
        move_up()
    end
end

main()
