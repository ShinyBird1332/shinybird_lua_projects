local robot = require("robot")
local event = require("event")

function main()
    while true do
        local _, _, _, _, _, message, command = event.pull("modem_message")
        if message == "use" then
            print("Юзаю матрицу.")
            robot.use()
        end
        os.sleep(0.1)
    end
end

main()