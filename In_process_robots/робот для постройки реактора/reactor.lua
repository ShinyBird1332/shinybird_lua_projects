local reactor = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function reactor.build_floor()
    for _ = 1, constants.SIZE do
        functions.build_row("Reactor Casing", "Reactor Casing", "Reactor Casing", constants.SIZE)
    end
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
    
    functions.build_row("Reactor Casing", "Reactor Casing", "Reactor Casing", constants.SIZE)

    for _ = 1, 3 do
        functions.build_row(block1, "Reactor Casing", block3, constants.SIZE)
    end
    functions.clear_inventory()

    functions.build_row(block2, "Reactor Casing", block4, constants.SIZE)
    
    for _ = 1, 5 do
        functions.build_row(block1, "Reactor Casing", "Reactor Casing", constants.SIZE)
    end
    functions.clear_inventory()

    functions.build_row(block2, "Reactor Casing", "Reactor Casing", constants.SIZE)

    for _ = 1, 3 do
        functions.build_row(block1, "Reactor Casing", "Reactor Casing", constants.SIZE)
    end

    functions.build_row("Reactor Casing", "Reactor Casing", "Reactor Casing", constants.SIZE)
    functions.clear_inventory()
end

return reactor