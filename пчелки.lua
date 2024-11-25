local component = require("component")
local sides = require("sides")
local transposer = component.transposer
local filesystem = require("filesystem")
local shell = require("shell")
local term = require("term")
local event = require("event")
local currentDir = shell.getWorkingDirectory()
local beeTreePath = filesystem.concat(currentDir, "bees.lua")
local bee_tree = dofile(beeTreePath)

--===========ВАЖНО==================
--бывают случаи, когда программа находит двух трутней или двух принцесс, из-за чего ломается

local target_bee = "Imperial" -- Выбранная пользователем пчела (без типа, только основное имя)

local bee_storage_side = sides.west -- сторона, на которой находится сундук с пчелами
local breeding_side = sides.north   -- сторона, на которой находится сундук для вывода пчел
local new_bee_side = sides.east     -- сторона, на которой находится сундук с новыми пчелами
local TIME_SLEEP = 40               -- Примерное время для вывода пчелы
--==================================

local bee_storage_size = transposer.getInventorySize(bee_storage_side)
local bee_storage = {
    ["drone"] = {},
    ["princess"] = {}
}

function scanBeeStorage() --функция сканирования хранилища с пчелами
    local function bee_find(name_hight, name_low, bee_name)
        bee_name = bee_name:gsub(name_hight, "")
        if not bee_storage[name_low][bee_name] then
            bee_storage[name_low][bee_name] = 0
        end
        bee_storage[name_low][bee_name] = bee_storage[name_low][bee_name] + 1
    end

    bee_storage["drone"] = {}
    bee_storage["princess"] = {}

    for slot = 1, bee_storage_size do
        local stack = transposer.getStackInSlot(bee_storage_side, slot)
        if stack then
            local bee_name = stack.label

            if bee_name:find("Drone") then
                bee_find(" Drone", "drone", bee_name)
            elseif bee_name:find("Princess") then
                bee_find(" Princess", "princess", bee_name)
            end
        end
    end
end

function targetBeeExists(target_bee) -- функция проверки на наличие целевой пчелы
    if bee_storage["drone"][target_bee] and bee_storage["drone"][target_bee] > 0 then
        return true
    end
    if bee_storage["princess"][target_bee] and bee_storage["princess"][target_bee] > 0 then
        return true
    end
    return false
end

function findBeePair(target_bee) --функция поиска пары пчел для разведения
    print("Поиск пары для выведения:", target_bee)
    if not bee_tree[target_bee] then
        print("Нет информации о выведении:", target_bee)
        return nil, nil
    end

    for parent1, _ in pairs(bee_tree[target_bee]) do
        for parent2, _ in pairs(bee_tree[target_bee]) do

            if parent1 ~= parent2 then              
                print("Проверяем наличие пчел:", parent1, parent2)
                if bee_storage["drone"][parent1] and bee_storage["princess"][parent2] then
                    print("Пара найдена:", parent1, parent2)
                    return parent1, parent2

                elseif bee_storage["drone"][parent2] and bee_storage["princess"][parent1] then
                    print("Пара найдена:", parent2, parent1)
                    return parent2, parent1
                end
            end
        end
    end
    print("Не найдена пара для вывода:", target_bee)
    return nil, nil
end

function moveBeesForBreeding(parent1, parent2) --функция переноса пары пчел для разведения
    local function move_bee_from_slot(parent, slot, type_bee1)
        transposer.transferItem(bee_storage_side, breeding_side, 1, slot)
        bee_storage[type_bee1][parent] = bee_storage[type_bee1][parent] - 1
        if bee_storage[type_bee1][parent] == 0 then
            bee_storage[type_bee1][parent] = nil
        end
    end

    print("Перенос пчел в пасеку:", parent1, parent2)
    local drone_moved = false
    local princess_moved = false

    for slot = 1, bee_storage_size do
        if drone_moved and princess_moved then break end

        local stack = transposer.getStackInSlot(bee_storage_side, slot)
        if stack then
            local bee_name = stack.label

            if bee_name == parent1 .. " Drone" and not drone_moved then
                print("Переносим ", bee_name, "из слота", slot)
                move_bee_from_slot(parent1, slot, "drone")
                drone_moved = true

            elseif bee_name == parent2 .. " Princess" and not princess_moved then
                print("Переносим", bee_name, "из слота", slot)
                move_bee_from_slot(parent2, slot, "princess")
                princess_moved = true
            end

        end
    end
end

function collectNewBees() -- функция перемещения новых пчел в хранилище
    print("Собираем новых пчел")
    
    for slot = 1, transposer.getInventorySize(new_bee_side) do
        local stack = transposer.getStackInSlot(new_bee_side, slot)
        if stack then
            local bee_name = stack.label
            if bee_name:find("Drone") then
                local name = bee_name:gsub(" Drone", "")
                if not bee_storage["drone"][name] then
                    bee_storage["drone"][name] = 0
                end
                bee_storage["drone"][name] = bee_storage["drone"][name] + 1
            elseif bee_name:find("Princess") then
                local name = bee_name:gsub(" Princess", "")
                if not bee_storage["princess"][name] then
                    bee_storage["princess"][name] = 0
                end
                bee_storage["princess"][name] = bee_storage["princess"][name] + 1
            end
            transposer.transferItem(new_bee_side, bee_storage_side, 1, slot)
        end
    end
end

function breedUntilTarget(target_bee) --рекурсивная функция поиска нужной пчелы
    while true do
        scanBeeStorage()
        if targetBeeExists(target_bee) then
            print("Целевая пчела найдена:", target_bee)
            return true
        end

        local parent1, parent2 = findBeePair(target_bee)
        if parent1 and parent2 then
            moveBeesForBreeding(parent1, parent2)
  
            repeat
                local stack = transposer.getSlotStackSize(new_bee_side, 1)
                os.sleep(TIME_SLEEP)
            until stack > 0

            collectNewBees()
        else
            print("Невозможно найти комбинацию для вывода этой пчелы, попытка обхода")

            local success = false
            for parent1, _ in pairs(bee_tree[target_bee]) do
                for parent2, _ in pairs(bee_tree[target_bee]) do
                    if parent1 ~= parent2 then
                        if not targetBeeExists(parent1) or not targetBeeExists(parent2) then
                            if breedUntilTarget(parent1) and breedUntilTarget(parent2) then
                                success = true
                                break
                            end
                        end
                    end
                end
                if success then break end
            end

            if not success then
                print("Error: Все попытки обхода провалились.")
                return false
            end
        end
    end
end

function main()  
    local success = breedUntilTarget(target_bee)
    if not success then
        print("Не удалось вывести целевую пчелу:", target_bee)
    else
        print("Целевая пчела успешно выведена:", target_bee)
    end
end

local function displayMenu()
    local bee_list = {}
    for bee, _ in pairs(bee_tree) do
        table.insert(bee_list, bee)
    end

    local screen_height = 50
    local items_per_page = screen_height - 2
    local current_page = 1
    local total_pages = math.ceil(#bee_list / items_per_page)

    while true do
        term.clear()
        print("Выберите целевую пчелу (Страница " .. current_page .. " из " .. total_pages .. "):")

        local start_index = (current_page - 1) * items_per_page + 1
        local end_index = math.min(current_page * items_per_page, #bee_list)

        for i = start_index, end_index do
            print(string.format("%d. %s", i, bee_list[i]))
        end

        print("Введите номер пчелы, 'n' для следующей страницы, 'p' для предыдущей страницы:")

        local input = io.read()
        if input == "n" and current_page < total_pages then
            current_page = current_page + 1
        elseif input == "p" and current_page > 1 then
            current_page = current_page - 1
        else
            local choice = tonumber(input)
            if choice and choice >= 1 and choice <= #bee_list then
                target_bee = bee_list[choice]
                print("Вы выбрали: " .. target_bee)
                main()
                return
            end
        end
    end

end

displayMenu()
