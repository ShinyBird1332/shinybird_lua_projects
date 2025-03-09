local comp = require("component") 
local modem = comp.modem

local reactors = {}

for i in pairs(comp.list("br_reactor")) do
    table.insert(reactors, comp.proxy(i))
end

for i, value in pairs(reactors) do
    print("Реактор №" .. i)
    print("Количество топлива: " .. value.getFuelAmount())
    print("Выработка энергии: " .. value.getEnergyProducedLastTick())
    print("Температура корпуса: ")
    print("Температура ядра: ")
    print("Хранимая энергия в реакторе: " .. value.getEnergyStored())
    print("Состояние: " .. tostring(value.getActive()))
    print("Потребление топлива: " .. value.getFuelConsumedLastTick())
    print("Количество отходов: " .. value.getWasteAmount())
    print("=======================================")
end