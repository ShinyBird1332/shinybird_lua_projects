local component = require("component")
local event = require("event")
local robot = require("robot")

function move_me_bus_export()
    robot.turnRight()
    for _ = 1, 3 do
        robot.forward()
    end
    robot.turnLeft()
    robot.up()
end

function move_trash()
    robot.down()
    robot.turnLeft()
    robot.forward()
    robot.turnLeft()
    for i = 1, robot.getInventorySize() do
        local item = robot.getStackInSlot(i)
        if item and item.size > 1 then
            robot.drop(item.size - 1)
        end
    end
end

function move_assembler()
    robot.turnLeft()
    robot.forward()
    robot.forward()
    for i = 1, robot.getInventorySize() do
        local item = robot.getStackInSlot(i)
        if item and item.label:find("Computer Case") then
            robot.select(i)
            robot.drop()
            break
        end
    end 
    robot.select(1)
    for i = 1, robot.getInventorySize() do
        local item = robot.getStackInSlot(i)
        if item then
            robot.select(i)
            robot.drop()
        end
    end 

end

function move_grab()
    robot.turnLeft()
    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.turnRight()
    --ждем завершения сборки робота и забираем

end

function grab_robot()
    robot.suck()
    robot.turnRight()
    robot.forward()
    robot.turnLeft()
    for _ = 1, 4 do
        robot.forward()
    end
    robot.turnRight()
    for _ = 1, 3 do
        robot.forward()
    end
    robot.place()
end

while true do
    local _, _, _, _, _, message, command = event.pull("modem_message")
    if message == "robot_move_me_bus_export" then
        move_me_bus_export()
    elseif message == "robot_move_trash" then
        move_trash()
    elseif message == "robot_move_assembler" then
        move_assembler()
    elseif message == "robot_move_grab" then
        move_grab()
    elseif message == "robot_grab_robot" then
        grab_robot()
    end
end