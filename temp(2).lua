--отправляет
local comp = require("component") 
local event = require("event")
local modem = comp.modem

modem.open(4)
modem.broadcast(4, "wait_mes")

local _, _, _, _, _, message = event.pull("modem_message")

for key, value in pairs(message) do
    print(key, value)
end







--принимает
local event = require("event")
local comp = require("component") 
local modem = comp.modem
modem.open(4)

local _, _, _, _, _, message = event.pull("modem_message")

if message == "wait_mes" then
    t = {}
    reactors = {}

    for i in pairs(comp.list("br_reactor")) do
        table.insert(reactors, comp.proxy(i))
    end

    for j, value in pairs(reactors) do
            
        table.insert(t, {
            reactor_number = j,
            reactor_count_fluid = value.getFuelAmount(),
            reactor_gen_energy_per_tick = value.getEnergyProducedLastTick(),
            reactor_energy_store = value.getEnergyStored(),
            reactor_state = value.getActive(),
            reactor_consumed_fuel = value.getFuelConsumedLastTick(),
            reactor_waste = value.getWasteAmount()
        })
    end
    modem.broadcast(4, t)
end



