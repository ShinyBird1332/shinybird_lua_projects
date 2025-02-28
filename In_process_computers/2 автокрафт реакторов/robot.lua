local comp = require("component")
local tunnel = comp.tunnel
local event = require("event")

function check()
    tunnel.send("yes", 1)
end

while true do
    local _, _, _, _, _, message, command = event.pull("modem_message")
    print("Получена команда: " .. message)

    if message == "check" then
        check()
    else
        print("Неизвестная команда: " .. tostring(message))
    end
end
