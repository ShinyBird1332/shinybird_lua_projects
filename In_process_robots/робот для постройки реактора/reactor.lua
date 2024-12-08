local reactor = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function reactor.build_floor()
    for _ = 1, constants.SIZE do
        reactor.build_row("Reactor Casing")
    end
end

function reactor.build_row(block1, block2, block3)
    block2 = block2 or "Reactor Casing"
    block3 = block3 or "Reactor Casing"

    local function handle_cryotheum()
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

    for i = 1, constants.SIZE do
        functions.eat() 

        if i == 1 then
            functions.place_block(block2)
        elseif i == constants.SIZE then
            functions.place_block(block3)
        elseif block1 == "криотеум" then
            handle_cryotheum() 
        else
            functions.place_block(block1)
        end

        functions.repeat_swing("forward") 
    end

    constants.robot.turnAround()
    functions.run(constants.SIZE)

    constants.robot.turnLeft()
    constants.robot.forward()
    constants.robot.turnLeft()
end

function reactor.move_up()
    constants.robot.turnLeft() 
    functions.run(constants.SIZE)
    constants.robot.turnRight()
    functions.repeat_swing("up")
end

function reactor.filling_or_roof_reactor(block1, block2, block3, block4)
    block2 = block2 or "Reactor Casing"
    block3 = block3 or "Reactor Casing"
    
    reactor.build_row("Reactor Casing")

    for i = 1, 3 do
        reactor.build_row(block1, "Reactor Casing", block3)
    end

    reactor.build_row(block2, "Reactor Casing", block4)
    
    for i = 1, 5 do
        reactor.build_row(block1)
    end

    reactor.build_row(block2)

    for i = 1, 3 do
        reactor.build_row(block1)
    end

    reactor.build_row("Reactor Casing")
end

return reactor