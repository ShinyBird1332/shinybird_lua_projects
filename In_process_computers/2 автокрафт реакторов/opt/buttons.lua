local buttons = {}

local constants = require("constants")
local frontControl = require("frontControl")

buttons.button = {}

function buttons.btn_new_reactor()
    constants.gpu.setBackground(constants.colors.white)
    constants.gpu.fill(150, 40, 20, 20, " ")
end

function buttons.btn_info_reactors()
    frontControl.main()
end

return buttons