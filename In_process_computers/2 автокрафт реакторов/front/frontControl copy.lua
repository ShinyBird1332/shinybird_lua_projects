local frontControl = {}

local constants = dofile("constants.lua")
local frontAdditionalControl = dofile("frontAdditionalControl.lua")
local guiModuls = dofile("guiModuls.lua")

function frontControl.get_reactors_info()
    constants.modem.broadcast(4, "wait_mes")
    local _, _, _, _, _, message = constants.event.pull("modem_message")
    -- Декодируем строку обратно в таблицу
    local _, t = pcall(constants.serialization.unserialize, message)

    for _, value in pairs(t) do
        --print("Реактор №" .. value.reactor_number)
        --print("Количество топлива: " .. value.reactor_count_fluid)
        --print("Выработка энергии: " .. value.reactor_gen_energy_per_tick)
        --print("Хранимая энергия: " .. value.reactor_energy_store)
        --print("Состояние: " .. tostring(value.reactor_state))
        --print("Потребление топлива: " .. value.reactor_consumed_fuel)
        --print("Количество отходов: " .. value.reactor_waste)
        --print("=======================================")
    end
end

--отрисовка кнопок реакторов
function frontControl.draw_reactors_buttons()
    
    for i = 0, 4 do
        for j = 0, 4 do
            local reactor_number = constants.reactors[1] or "N/A"
            print(reactor_number)
        end
    end
end

function frontControl.main()
    frontControl.get_reactors_info()
    frontControl.draw_reactors_buttons()

    while true do
        local _, _, x, y = constants.event.pull("touch")
        frontControl.handle_click(x, y)
    end
end

frontControl.main()

return frontControl