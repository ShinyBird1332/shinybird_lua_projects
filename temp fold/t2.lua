local t2 = {}
local t1 = require("t1")

function t2.fun()
    table.insert(t1.buttons, {x = 12}) 
end

return t2