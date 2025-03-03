local t1 = require("t1")
local t2 = require("t2")

t2.fun()
--table.insert(t1.buttons, {x = 12}) 

for i, j in pairs(t1.buttons) do
    print(i, j.x)
end