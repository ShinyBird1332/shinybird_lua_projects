local comp = require("component")
local robot = require("robot")
local event = require("event")

local tractor_beam = comp.tractor_beam

function grab_discovery()
    tractor_beam.suck()
    robot.turnLeft()
    for _ = 1, robot.inventorySize() do
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnRight()
end

function main()
    while true do
        local _, _, _, _, _, message, command = event.pull("modem_message")
        if message == "grab" then
            grab_discovery()
        end
        os.sleep(0.1)
    end
end

main()
