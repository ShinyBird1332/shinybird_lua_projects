local reactor = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function reactor.build_floor()
    for _ = 1, constants.SIZE do
        for _ = 1, constants.SIZE do
            functions.place_block("Reactor Casing")
            functions.repeat_swing("forward")
        end
        functions.end_build_row(constants.SIZE)
    end
    constants.robot.turnLeft() 
    functions.run(constants.SIZE)
    constants.robot.turnRight()
    functions.repeat_swing("up")
end

function reactor.build_walls()
    local function buid_wall(i)
        for j = 1, constants.SIZE - 1 do
            for _ = 1, 31 do
                functions.place_block("Reactor Casing")
                functions.repeat_swing("up")
            end
            functions.run(1)
            if i ~= 4 or j ~= constants.SIZE - 1 then
                for _ = 1, 31 do
                    functions.repeat_swing("down")
                end
            end
        end
    end
    for i = 1, 4 do
        buid_wall(i)
        constants.robot.turnRight()
        print(i)
    end
    functions.clear_inventory()
end

function reactor.build_rods()
    functions.run(1)
    constants.robot.turnRight()
    functions.run(1)
    constants.robot.turnLeft()
    for _ = 1, 31 do functions.repeat_swing("down") end

    for i = 1, 7 do
        for _ = 1, constants.SIZE - 3 do
            for _ = 1, 30 do
                functions.place_block("Yellorium Fuel Rod")
                functions.repeat_swing("up")
            end
            functions.repeat_swing("forward")
            for _ = 1, 30 do functions.repeat_swing("down") end
        end
        for _ = 1, 30 do
            functions.place_block("Yellorium Fuel Rod")
            functions.repeat_swing("up")
        end
    
        constants.robot.turnAround()
        functions.run(constants.SIZE - 3)
        if i ~= 7 then
            constants.robot.turnLeft()
            functions.run(2)
            constants.robot.turnLeft()
            for _ = 1, 30 do functions.repeat_swing("down") end
        else
            constants.robot.turnRight()
            functions.run(11) -- идем до первого пустого места для заполнения редстоуном
            constants.robot.turnRight()
            functions.repeat_swing("down")
        end
    end 
end

function handle_liquid()
    if constants.robot.tankLevel() <= 1000 then
        constants.robot.select(constants.SLOT_TANK)
        repeat
            constants.robot.swingUp()
            os.sleep(0.2)
        until not constants.robot.detectUp()

        constants.robot.placeUp()
        constants.robot.drainUp(16000)

        repeat
            constants.robot.swingUp()
            os.sleep(0.2)
        until not constants.robot.detectUp()
    end

    repeat
        constants.robot.swingDown()
        os.sleep(0.2)
    until not constants.robot.detectDown()
    constants.robot.fillDown()
end

function reactor.fill_redstone()
    for i = 1, 7 do
        for _ = 1, constants.SIZE - 3 do
            handle_liquid()
            functions.repeat_swing("forward")
        end
        handle_liquid()
    
        constants.robot.turnAround()
        functions.run(constants.SIZE - 3)
        if i ~= 7 then
            constants.robot.turnLeft()
            functions.run(2)
            constants.robot.turnLeft()
        else
            
        end
    end 
    constants.robot.turnRight()
    functions.run(13)
    constants.robot.turnRight()
    functions.repeat_swing("up")
end

function reactor.build_roof_1()
    for i = 1, 7 do
        for _ = 1, constants.SIZE - 3 do
            functions.place_block("Reactor Control Rod")
            functions.repeat_swing("forward")
        end
        functions.place_block("Reactor Control Rod")
    
        constants.robot.turnAround()
        functions.run(constants.SIZE - 3)
        if i ~= 7 then
            constants.robot.turnLeft()
            functions.run(2)
            constants.robot.turnLeft()
        else
            
        end
    end 
    constants.robot.turnRight()
    functions.run(11)
    constants.robot.turnRight()
end

function reactor.build_roof_2()
    for _ = 1, 6 do
        for _ = 1, constants.SIZE - 3 do
            functions.place_block("Reactor Casing")
            functions.repeat_swing("forward")
        end
        functions.place_block("Reactor Casing")
    
        constants.robot.turnAround()
        functions.run(constants.SIZE - 3)

        constants.robot.turnLeft()
        functions.run(2)
        constants.robot.turnLeft()
    end 

    for _ = 1, constants.SIZE - 6 do
        functions.place_block("Reactor Casing")
        functions.repeat_swing("forward")
    end
    functions.place_block("Reactor Controller")
    functions.repeat_swing("forward")

    functions.place_block("Reactor Access Port")
    functions.repeat_swing("forward")

    functions.place_block("Reactor Access Port")
    functions.swith_key()
    functions.repeat_swing("forward")

    functions.place_block("Reactor Power Tap")
    functions.repeat_swing("forward")
end

return reactor