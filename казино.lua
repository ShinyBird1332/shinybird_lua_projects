local component = require("component")
local sides = require("sides")
local math = require("math")
local os = require("os")
local term = require("term")

local side_1 = sides.north
local side_3 = sides.south

local gpu = component.gpu
local w, h = gpu.getResolution()

local trans = {
    component.proxy("34112f58-10d5-498a-87ba-4d0649ac5046"), -- для поиска монеток
    component.proxy("b0c87d03-61b3-4cfb-9f49-b85218950431") -- для выдачи приза
}

local list_items = {
    [1] = { 
        {name = "Cobblestone", min = 0, max = 150, color = 0x00FF00},
        {name = "Dirt", min = 150, max = 300, color = 0x00FF00},
        {name = "Oak Wood", min = 300, max = 400, color = 0x00FF00},
        {name = "Ruby", min = 400, max = 500, color = 0x00FF00},
        {name = "Raw Rubber", min = 500, max = 600, color = 0x00FF00},
        {name = "Iron Ingot", min = 600, max = 750, color = 0x00FF00},
        {name = "Gold Ingot", min = 750, max = 850, color = 0x00FF00},
        {name = "Diamond", min = 850, max = 950, color = 0x00FF00},
        {name = "Nether Star", min = 950, max = 1000, color = 0x00FF00}
    },
    [2] = { 
        {name = "Eden Soul", min = 0, max = 250, color = 0x00FF00},
        {name = "Skythern Soul", min = 250, max = 450, color = 0x00FF00},
        {name = "Block of Diamond", min = 450, max = 550, color = 0x00FF00},
        {name = "Electronic Circuit", min = 550, max = 650, color = 0x00FF00},
        {name = "Molecular Assembler", min = 650, max = 700, color = 0x00FF00},
        {name = "Shiny Ingot", min = 700, max = 750, color = 0x00FF00},
        {name = "Basic Energy Cube", min = 750, max = 920, color = 0x00FF00},
        {name = "Draconium Block", min = 920, max = 970, color = 0x00FF00},
        {name = "Mob Soul", min = 970, max = 1000, color = 0x00FF00}
    },
    [3] = { 
        {name = "Thaumium Ingot", min = 0, max = 200, color = 0x00FF00},
        {name = "Neutronium Ingot", min = 200, max = 400, color = 0x00FF00},
        {name = "Enderium Ingot", min = 400, max = 550, color = 0x00FF00},
        {name = "Terrasteel Ingot", min = 550, max = 650, color = 0x00FF00},
        {name = "Shadow Metal Ingot", min = 650, max = 750, color = 0x00FF00},
        {name = "Void metal Ingot", min = 750, max = 850, color = 0x00FF00},
        {name = 'Mobius "Unstable/Stable" Ingot', min = 850, max = 900, color = 0x00FF00},
        {name = "Raw Meat Ingot", min = 900, max = 970, color = 0x00FF00},
        {name = "Fiery Ingot", min = 970, max = 1000, color = 0x00FF00}
    },
    [4] = { 
        {name = "Ichor", min = 0, max = 200, color = 0x00FF00},
        {name = "Gaia Spirit", min = 200, max = 400, color = 0x00FF00},
        {name = "Replicator", min = 400, max = 550, color = 0x00FF00},
        {name = "Block of Bedrockium", min = 550, max = 650, color = 0x00FF00},
        {name = "Charged Draconium Block", min = 650, max = 750, color = 0x00FF00},
        {name = "Order Infused Triple Compressed Solar Panel", min = 750, max = 850, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 850, max = 900, color = 0x00FF00},
        {name = "Молекулярный преобразователь", min = 900, max = 970, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 970, max = 1000, color = 0x00FF00}
    },
    [5] = { 
        {name = "Ichor", min = 0, max = 200, color = 0x00FF00},
        {name = "Gaia Spirit", min = 200, max = 400, color = 0x00FF00},
        {name = "Replicator", min = 400, max = 550, color = 0x00FF00},
        {name = "Block of Bedrockium", min = 550, max = 650, color = 0x00FF00},
        {name = "Charged Draconium Block", min = 650, max = 750, color = 0x00FF00},
        {name = "Order Infused Triple Compressed Solar Panel", min = 750, max = 850, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 850, max = 900, color = 0x00FF00},
        {name = "Молекулярный преобразователь", min = 900, max = 970, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 970, max = 1000, color = 0x00FF00}
    },
    [6] = { --ботания
        {name = "Livingrock", min = 0, max = 150, color = 0x00FF00},
        {name = "Искра Фрейи", min = 150, max = 300, color = 0x00FF00},
        {name = "Tiny Potato", min = 350, max = 450, color = 0x00FF00},
        {name = "Mana Diamond", min = 450, max = 600, color = 0x00FF00},
        {name = "Mana Pearl", min = 600, max = 750, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 750, max = 800, color = 0x00FF00},
        {name = "Terrasteel Ingot", min = 800, max = 950, color = 0x00FF00},
        {name = "Gaya Spirit Ingot", min = 950, max = 995, color = 0x00FF00},
        {name = "Infinitato", min = 995, max = 1000, color = 0x00FF00}
    },
    [7] = { --таум
        {name = "Thaumium Ingot", min = 0, max = 150, color = 0x00FF00},
        {name = "Balanced Shard", min = 150, max = 300, color = 0x00FF00},
        {name = "Nitor", min = 300, max = 400, color = 0x00FF00},
        {name = "Enchanted Fabric", min = 400, max = 550, color = 0x00FF00},
        {name = "Primal Charm", min = 550, max = 650, color = 0x00FF00},
        {name = "Void metal Ingot", min = 650, max = 800, color = 0x00FF00},
        {name = "Eldritch Eye", min = 800, max = 900, color = 0x00FF00},
        {name = "Pride Shard", min = 900, max = 970, color = 0x00FF00},
        {name = "Primordial Pearl", min = 970, max = 1000, color = 0x00FF00}
    },
    [8] = { --джекпот
        {name = "Iron Ingot", min = 0, max = 990, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 990, max = 1000, color = 0x00FF00}
    },
}

local cases = {"Медная монетка", "Серебряная монетка", "Золотая монетка", "Алмазная монетка", "Бесконечная монетка", "", "", ""}

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
