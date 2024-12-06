local comp = require("component")
local robot = require("robot")
local i_c = comp.inventory_controller


function check_charge()
    local prev_slot = robot.select()
    if robot.durability() < NEED_CHARGE then
        
        robot.turnRight()
        robot.drop()
        os.sleep(TIME_SLEEP) 
        print(i_c.suckFromSlot(SIDE, 1, 1))
        robot.select(selected_slot)  

        robot.turnLeft() 
    end

    robot.select(prev_slot)
end