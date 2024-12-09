local functions = {}

local constants = dofile("constants.lua")

function functions.check_kit_start()
    constants.robot.select(constants.SLOT_CHEST)
    constants.robot.turnAround()
    local result = true

    for name, count in pairs(constants.resourses) do
        local res_count = 0
        for j = 1, constants.i_c.getInventorySize(constants.sides.front) do
            local chest_item = constants.i_c.getStackInSlot(constants.sides.down, j)
            if chest_item ~= nil then
                if chest_item.label == name then
                    res_count = res_count + chest_item.size
                end
            end
        end

        if res_count < count then
            print("Недостаточно " .. name .. " предметов: " .. count - res_count)
            result = false
        end
    end
    constants.robot.select(constants.SLOT_CHEST)
    functions.repeat_swing("forward")
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

function functions.end_build_row(iter)
    constants.robot.turnAround()
    functions.run(iter)
    constants.robot.turnLeft()
    functions.run(1)
    constants.robot.turnLeft()
end

function functions.build_row(block1, block2, block3, iter)
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

    for i = 1, iter do
        functions.eat() 

        if i == 1 then
            functions.place_block(block2)
        elseif i == iter then
            functions.place_block(block3)
        elseif block1 == "криотеум" then
            handle_cryotheum() 
        else
            functions.place_block(block1)
        end

        functions.repeat_swing("forward") 
    end

    functions.end_build_row(iter)
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

function functions.replace_coolant_ports(reverse_mode)
    local function place_port_pair()
        functions.place_block("Reactor Coolant Port")
        if reverse_mode then functions.swith_key() end
        functions.run(4)
        functions.place_block("Reactor Coolant Port")
        if not reverse_mode then functions.swith_key() end
    end

    local function process_side()
        place_port_pair()
        functions.run(4)
        place_port_pair()
    end

    functions.repeat_swing("down")
    constants.robot.turnRight()
    functions.repeat_swing("forward")
    constants.robot.turnLeft()
    functions.repeat_swing("forward")

    process_side()

    constants.robot.turnRight()
    functions.run(8)
    constants.robot.turnRight()

    process_side()
end

return functions