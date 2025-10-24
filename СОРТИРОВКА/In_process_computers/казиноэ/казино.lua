

-- Функция для поиска позиции предмета в сундуке по имени
function findItemSlot(side, itemName)
    local slotCount = trans[2].getInventorySize(side)
    for slot = 1, slotCount do
        local item = trans[2].getStackInSlot(side, slot)
        if item and item.label == itemName then
            return slot
        end
    end
    return nil
end

-- Функция для отрисовки рамок с предметами
function drawItems(items, highlightIndex)
    local startX = 5
    local startY = 5
    local width = 20
    local height = 3

    for i, item in ipairs(items) do
        local color = 0xFFFFFF
        if i == highlightIndex then
            color = item.color
        end
        gpu.setForeground(color)
        gpu.fill(startX, startY + (i - 1) * (height + 1), width, height, " ")
        gpu.set(startX + 2, startY + (i - 1) * (height + 1) + 1, item.name .. " - " .. (item.max - item.min) / 10 .. " %")
    end
end

-- Функция для вывода сообщений на экран
function displayMessage(message)
    local msgX = 30
    local msgY = 2
    gpu.setForeground(0xFFFFFF)
    gpu.fill(msgX, msgY, w - msgX, 1, " ")
    gpu.set(msgX, msgY, message)
end

function play(level)
    gpu.fill(1, 1, w, h, " ")
    displayMessage("Игра на уровне: " .. level)
    
    local items = list_items[level]
    local number = math.random(1000)
    local winnerIndex = nil

    for i, item in ipairs(items) do
        if number > item.min and number <= item.max then
            winnerIndex = i
            break
        end
    end

    for i = 1, 10 do
        local highlightIndex = (i % #items) + 1
        drawItems(items, highlightIndex)
        os.sleep(0.1)
    end

    drawItems(items, winnerIndex)
    os.sleep(1)

    if winnerIndex then
        local slot = findItemSlot(side_3, items[winnerIndex].name)
        if slot then
            trans[2].transferItem(side_3, side_1, 1, slot, 1)
            displayMessage("Вы выиграли: " .. items[winnerIndex].name)
        else
            displayMessage("Предмет " .. items[winnerIndex].name .. " не найден в сундуке.")
        end
    end
    end_play(level)
end

function end_play(level)
    pcall(function()
        trans[1].transferItem(side_1, side_3, 1, level, 1)
    end)
end

function sell() 
    for i = 1, #cases do
        local success, stack = pcall(function() return trans[1].getStackInSlot(side_1, i) end)
        if success and stack and stack.size > 1 then
            displayMessage("Игра на уровне: " .. i .. " (" .. cases[i] .. ")")
            play(i)
            break
        end
    end
end

function main()
    gpu.fill(1, 1, w, h, " ")
    while true do
        sell()
        os.sleep(1)
    end
end

main()
