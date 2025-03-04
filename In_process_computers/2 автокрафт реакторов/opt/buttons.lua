local buttons = {}

local constants = dofile("constants.lua")
local frontControl = dofile("frontControl.lua")
local craftReactor = dofile("craftReactor.lua")

buttons.button = {}

function buttons.btn_new_reactor()
    craftReactor.main()
end

function buttons.btn_info_reactors()
    frontControl.main()
end

return buttons