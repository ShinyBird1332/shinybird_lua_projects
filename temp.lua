local component = require("component")
local me_interface = component.me_interface

-- Проверка наличия предмета в МЭ
function check_item_in_me(item_name)
    local items = me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name and item.size > 0 then
            print("\nПредмет найден в МЭ: " .. item_name .. " - " .. item.size .. " штук")
            return true
        end
    end
    return false
end

-- Функция запуска автокрафта с проверкой
function start_autocraft(item_name)
    -- Сначала проверяем наличие предмета
    if check_item_in_me(item_name) then
        print("Крафт не требуется. Предмет уже есть: " .. item_name)
        return true
    end

    -- Получаем список доступных крафтов
    local craftables = me_interface.getCraftables()
    if not craftables then
        print("Ошибка: нет доступных шаблонов для крафта.")
        return false
    end

    -- Ищем шаблон и запускаем крафт
    for _, craftable in ipairs(craftables) do
        local item = craftable.getItemStack()
        if item.label == item_name then
            print("Шаблон найден. Запуск автокрафта для: " .. item_name)
            local request = craftable.request(1)

            -- Проверка успешности запроса
            if request.isCanceled() then
                print("Ошибка: автокрафт отменён. Недостаточно ресурсов.")
                return false
            end

            -- Ожидаем завершения крафта
            print("Ожидание завершения крафта...")
            while not request.isDone() do
                os.sleep(1)
                print("...")
            end

            print("Автокрафт завершён для: " .. item_name)
            return true
        end
    end

    print("Ошибка: не найден шаблон для: " .. item_name)
    return false
end

local pressed_buttons = {
    "Computer Case (Tier 3)", 
    "Battery Upgrade (Tier 3)", 
    "Crafting Upgrade",
    "Inventory Controller Upgrade", 
    "Trading Upgrade",
    "Screen (Tier 1)", 
    "Disk Drive", 
    "Keyboard", 
    "EEPROM (Lua BIOS)"
}

for _, item in ipairs(pressed_buttons) do
    start_autocraft(item)
end
