local comp = require("component")
local robot_lib = require("robot")

--первый этап - раскопка местности 3 на 3 чанка

local START_POS_Y = 2 --79 --Тут важно указать высоту, на которой располагается робоот!
local CHUNK = 2
local CHUNK_COUNT = 3



function main()
    for i = 1, CHUNK * CHUNK_COUNT - 1 do
        for J = 1, CHUNK * CHUNK_COUNT - 1 do
            
        end
    end
end

main()