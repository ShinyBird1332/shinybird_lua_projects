local comp = require("component") 
local robot = require("robot")
local sides = require("sides")
local trade = comp.trading
local i_c = comp.inventory_controller

function calc_count_pearls(count, trade_size)
    if count < trade_size then
        return 0
    end
    local res = count / trade_size 
    return (res - res % 1) * trade_size
end

function grab(search_item, trade_size)
    local count = 0
    
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)
        if item and item.label == search_item then
            count = calc_count_pearls(item.size, trade_size)
            i_c.suckFromSlot(sides.front, i, count)
            if count > 1 then break end         
        end
    end

    return count / 20
end

function main()
    robot.turnLeft()
    print("Поиск жемчуга...")
    local count = grab('Polished Pearls', 20)
    print("Перенесено " .. count * 20 .. " жемчуга.")
    robot.turnRight()

    for _ = 1, count do
        trade.getTrades()[28].trade()
    end
    print("Куплено " .. count .. " зажигалок.")

    robot.turnRight()
    print("Перенос зажигалок.")
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item then
            robot.select(i)
            robot.drop()
        end
    end
    robot.turnLeft()

    robot.turnAround()
    print("Поиск камушков...")
    count = grab('Rock Chunks', 25)
    print("Перенесено " .. count * 25 .. " камушков.")
    robot.turnAround()
    for _ = 1, count do
        trade.getTrades()[35].trade()
    end
    print("Куплено " .. count .. " маулов.\nПеренос маулов...")

    robot.turnRight()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item then
            robot.select(i)
            robot.drop()
        end
    end
    robot.turnLeft()
end

while true do
    main()
    os.sleep(2)
end