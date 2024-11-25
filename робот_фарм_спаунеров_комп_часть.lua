local component = require("component")
local sides = require("sides")
local tunnel = component.tunnel

local reds = component.proxy("8e564fd8-4054-4224-a61f-f3c25d0d7be0")

side = sides.west

function main()
    while true do
        state = io.read()
        if state == "start" then
            reds.setOutput(side, 15)
            print("Запуск робота")
            tunnel.send("start")
        else
            reds.setOutput(side, 0)
            print("Ожидание остановки робота")
            tunnel.send("stop")
        end
    end
end

main()