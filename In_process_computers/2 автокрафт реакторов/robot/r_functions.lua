local functions = {}

local constants = dofile("constants.lua")

function functions.check_kit_start()
    constants.robot.select(constants.SLOT_CHEST)
    constants.robot.turnAround()
    constants.robot.swing() 
    constants.robot.turnLeft()
    constants.robot.select(constants.SLOT_TANK)
    constants.robot.swing()
    constants.robot.turnLeft()
    constants.robot.select(1)
    return result
end

function functions.eat()
    if constants.g.count() >= constants.COUNT_COAL then return end

    constants.robot.select(constants.SLOT_COAL)
    if constants.robot.count() < constants.COUNT_COAL - 1 then
        print("Нет топлива! Ожидание...")
        while constants.robot.count() < constants.COUNT_COAL - 1 do
            os.sleep(1)
        end
    end
    constants.g.insert(8)
end

function functions.run(direct)
    for _ = 1, direct do
        functions.eat()
        functions.repeat_swing("forward")
    end
end

function functions.move_start()
    local x = 1 -- это кол-во реакторов на шаги
    functions.run(4)
    constants.robot.turnLeft()
    functions.run(11)
    constants.robot.turnRight()

    for i = 1, 35 do functions.repeat_swing("up") end
    functions.run(x)
    for i = 1, 35 do functions.repeat_swing("down") end
end

function functions.end_build_row(iter)
    constants.robot.turnAround()
    functions.run(iter)
    constants.robot.turnLeft()
    functions.run(1)
    constants.robot.turnLeft()
end

function functions.clear_inventory()
    local selected_slot = constants.robot.select()
    for i = 1, constants.robot.inventorySize() do
        constants.robot.select(i)
        local stack = constants.i_c.getStackInInternalSlot(i)
        if stack and stack.label == "Snowball" then
            constants.robot.drop()
        end
    end
    constants.robot.select(selected_slot)
end

function functions.repeat_swing(direction)
    local action = constants.actions["func_" .. direction] 
    local swing_func, detect_func, move_func = table.unpack(action)

    repeat
        swing_func()
        os.sleep(0.2)
    until not detect_func()
    move_func()
end

function functions.check_or_replenish_item(item)
    for i = 1, constants.robot.inventorySize() do
        local robot_slot = constants.i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label == item then
            constants.robot.select(i)
            return
        end
    end

    local selected_slot = constants.robot.select()
    constants.robot.select(constants.SLOT_CHEST)
    functions.repeat_swing("up")
    constants.robot.placeDown()

    for i = 1, constants.i_c.getInventorySize(constants.sides.down) do
        local chest_item = constants.i_c.getStackInSlot(constants.sides.down, i)
        if chest_item and chest_item.label == item then
            constants.robot.select(1)
            constants.i_c.suckFromSlot(constants.sides.down, i, constants.COUNT_ITEM_GRAB)
            break
        end
    end

    constants.robot.select(constants.SLOT_CHEST)
    functions.repeat_swing("down")
    constants.robot.select(selected_slot)

    functions.check_or_replenish_item(item)
end

function functions.place_block(block)
    functions.eat()
    functions.check_or_replenish_item(block)
    repeat
        constants.robot.swingDown()
        os.sleep(0.2)
    until not constants.robot.detectDown()
    constants.robot.placeDown()
end

function functions.swith_key()
    local prev_slot = constants.robot.select()
    constants.robot.select(constants.SLOT_KEY)
    constants.i_c.equip()
    constants.robot.useDown()
    constants.i_c.equip()
    constants.robot.select(prev_slot)
end

return functions