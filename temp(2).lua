local comp = require("component") 
local sides = require("sides")
local robot = require("robot")
local g = comp.generator

local function coord_floor()
    local tbl = {}
    for z = 0, 5 do
        for x = 1, 5 do
            table.insert(tbl, {x, 0, z})
        end
    end
    return tbl
end

local function eat() --добавить поиск угля в сундуке
    local selectedSlot = robot.select()
    robot.select(16)
    while robot.count() < 1 do
        os.sleep(10)
        print("Нет топлива!")
    end

    if g.count() < 2 then
        g.insert(4)
        robot.select(selectedSlot)
    end
end

local function rotate(c)
    if c > -5 then
        if c % 2 == 0 then
            robot.turnRight()
            run()
            robot.turnRight()
        else
            robot.turnLeft()
            run()
            robot.turnLeft()
        end
    else
        robot.turnRight()
        for i = 1, size - 1 do
            run()
        end
        robot.turnRight()
    end
end

local function run(direct) -- добавить движение по координатам относительно сундука с ресами, циклы!!
    eat()
    if direct == "forw" then
        repeat
            robot.swing()
        until not robot.detect()
        robot.forward()
    elseif direct == "up" then
        repeat
            robot.swingUp()
        until not robot.detectUp()
    end
end

local function build(block) --циклы
    robot.select(block)
    eat()
    robot.placeDown()
    run("forw")
end

local function clear_area()
    robot.forward()
    for z = 1, size do
        for y = 1, size do
            for i = 1, size - 1 do
                run("forw")
            end
            print("rotate", y)
            if y ~= size then rotate(y - 1)
            else rotate(-10)
            end
        end
        print("up", z)
        run("up")
    end
    for i = 1, size - 1 do
        robot.down()
    end
end

local function build_reactor()
    local function build_floor()
        for x = 1, 15 do
            for y = 1, 15 do
                build(1)
            end
            robot.turnAround()

        end
    end

    build_floor()

end

local function main()
    --clear_area()
    build_reactor()
end

main()