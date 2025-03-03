package.path = package.path .. ";./front/?.lua;./back/?.lua;./opt/?.lua"

local start = require("start")
local frontMain = require("frontMain")

function main()
    --start.check_all_func() --проверка постройки системы.
    frontMain.draw_start_interfase()
end

main()