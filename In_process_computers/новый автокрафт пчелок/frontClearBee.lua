local frontClearBee = {}
--Привести пчелу до состояния: 1 чистая принцесса и 64 трутня в стаке

local constants = dofile("constants.lua")
local guiModuls = dofile("guiModuls.lua")
local backClearBee = dofile("backClearBee.lua")

function frontClearBee.terminal()
    guiModuls.draw_border(10, 5, constants.w - 20, constants.h - 10, "  TERMINAL   ")

    backClearBee.main()
end

return frontClearBee