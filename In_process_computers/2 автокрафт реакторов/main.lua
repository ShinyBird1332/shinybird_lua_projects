package.path = package.path .. ";/home/front/?.lua;/home/opt/?.lua"

local modules_to_reload = {
    "guiModuls",
    "craftReactor",
    "buttons",
    "frontMain",
    "constants"
}

for _, module in ipairs(modules_to_reload) do
    package.loaded[module] = nil
end

--local start = require("start")
local frontMain = dofile("frontMain.lua")

function main()
    --start.check_all_func() --проверка постройки системы.
    frontMain.draw_start_interfase()
end

main()