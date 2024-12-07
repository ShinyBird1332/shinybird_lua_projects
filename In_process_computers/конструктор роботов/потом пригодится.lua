--на экране графический интерфейс со всеми компонентами для робота
--при наведении цвет рамки меняется на 1, при нажатии на 2
--пока не будут выбраны все важные компоненты, кнопка старт неактивна
--после выбора всех компонентов, нажимается кнопка старт
--когда компонент выбирается, переменная с его значением становится тру
--после нажатия на старт, для начала хотя бы вывести все эти названия предметов

--compareStacks-function(slotA:number, slotß:number):boolean -- Compare the two item stacks in the specified slots for equality., 
--getAllStacks-function():table -- Get a list of descriptions for all iten stacks in this inventory., 
--getAugPowerInjection=function():number -- Get the average power injection into the network., 
--getAugPowerVsage=function():number -- Get the average power usage of the network., 
--getCpus-function():table -- Get a list of tables representing the available CPUs in the network., 
--getCraftables=function([filter:table]):table --- Get a list of knoun iten recipes. These can be used to issue crafting requests., 
--getfluidsInNetwork=function():table -- Get a list of the stored fluids in the network., 
--getGasesInNetwork=function():table -- Get a list of the stored gases in the network., 
--getIdlePowerUsage=function():number -- Get the idle power usage of the network.,







local component = require("component")
local me_interface = component.me_interface
local sides = require("sides")
local os = require("os")
local export_bus = component.me_exportbus




for name, method in pairs(component.methods(export_bus.address)) do
    print(name, method)
end

-- Список необходимых компонентов
local required_components = {
    "Computer Case (Tier 1)",
}

-- Функция для проверки наличия предмета в ME-системе
function check_item_in_me(item_name)
    local items = me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name then
            return item.size  -- Возвращаем количество найденного предмета
        end
    end
    return 0  -- Предмет не найден
end

-- Функция для запроса автокрафта
function request_craft(item_name)
    local craftables = me_interface.getCraftables()
    for _, craft in ipairs(craftables) do
        if craft.label == item_name then
            local success = craft.request(1)  -- Заказываем 1 предмет
            if success then
                print("Запрос на крафт отправлен: " .. item_name)
                return true
            end
        end
    end
    print("Ошибка: крафт невозможен для " .. item_name)
    return false
end

-- Функция для экспорта предмета с помощью ME Export Bus
function transfer_item_with_export_bus(item_name)
    -- Ищем предмет в ME-сети
    local items = component.me_interface.getItemsInNetwork()
    for _, item in ipairs(items) do
        if item.label == item_name then
            print("Найдено: " .. item_name)

            -- Устанавливаем конфигурацию шины экспорта
            print(export_bus.getExportConfiguration(sides.west, 1))
            export_bus.setExportConfiguration(1, item)
            print(export_bus.getExportConfiguration(sides.west, 1))

            -- Экспортируем предмет в инвентарь на стороне 'sides.down'
            local success = export_bus.exportIntoSlot(sides.west, 1)
            if success and success > 0 then
                print("Успешно экспортировано: " .. item_name)
                return true
            else
                print("Не удалось экспортировать: " .. item_name)
                return false
            end
        end
    end
    print("Предмет не найден в ME-сети: " .. item_name)
    return false
end

-- Основная функция для обработки компонентов
function process_components()
    for _, component in ipairs(required_components) do
        print("Обрабатываем компонент: " .. component)

        -- Проверка наличия предмета
        local item_count = check_item_in_me(component)
        if item_count > 0 then
            print("Найдено " .. item_count .. " шт. " .. component)
            -- Перемещаем в сундук
            if not transfer_item_with_export_bus(component) then
                print("Не удалось переместить: " .. component)
            end
        else
            -- Предмет не найден, отправляем запрос на автокрафт
            print("Предмет не найден: " .. component .. ", отправляем запрос на крафт")
            if request_craft(component) then
                os.sleep(5)  -- Ждём завершения крафта (можно настроить время ожидания)
                -- Повторная проверка и перемещение после крафта
                if not transfer_item_with_export_bus(component) then
                    print("Не удалось переместить после крафта: " .. component)
                end
            end
        end
    end
    print("Обработка компонентов завершена.")
end

-- Запуск обработки компонентов
process_components()
