local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local tract = comp.tractor_beam
local i_c = comp.inventory_controller

local TIME_SLEEP = 20
local STOP_USING_BONES = 8
local STOP_USING_HOE = 0.3

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

function try_fill_bone(side, name)
    robot.turnAround()
    local inv = 27 --i_c.getInventorySize(side)
    for slot = 1, inv do 
        item = i_c.getStackInSlot(side, slot) 
        if item and item.label == name then
            robot.select(16)
            i_c.suckFromSlot(side, slot, 100)
        end
    end
    robot.turnAround()
end

function grab_item()
    for i = 1, TIME_SLEEP do
        tract.suck()
        os.sleep(1)
    end
end

function detect_block()
    _, type_block = robot.detect()
    return type_block
end

function check_durability(type_item)
    if type_item == "H" then
        print(robot.durability())
        if robot.durability() < STOP_USING_HOE then
            return false
        else
            return true
        end
    else
        if i_c.getStackInInternalSlot(16).size < STOP_USING_BONES and i_c.getStackInInternalSlot(16).label == "Bone Meal" then
            try_fill_bone(sides.front, i_c.getStackInInternalSlot(16).label)
            return false
        else
            return true
        end
    end
    
end

function check_bones()
    q1 = i_c.getStackInInternalSlot(16).label
    if q1 == "Bone Meal" then
        t("B", "Предмет вот-вот закончится")
    else
        t("H", "Предмет вот-вот сломается или разрядится")
    end
end

function t(type_item, mess)
    if check_durability(type_item) == false then
        print(mess)
        repeat
            os.sleep(1)
        until check_durability(type_item)
    end
end

function main()
    robot.select(1)
    robot.place()
    robot.select(16)

    i_c.equip()
    check_bones()

    while detect_block() ~= "solid" do
        robot.use()
        os.sleep(0.5)
    end

    i_c.equip()
    robot.swing()
    grab_item()
    robot_drop()
end

while true do
    main()
end
