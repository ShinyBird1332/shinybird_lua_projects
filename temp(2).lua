local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local tract = comp.tractor_beam
local i_c = comp.inventory_controller

--можно сделать массив со всеми способами, а потом, по надобности, нажать кнопку и поменять режим
--режим изменится только по завершению итерации цикла
--Bone Meal, Hoe of Grouth, Electric Hoe of Grouth
local TYPE_FERTILIZER = "Bone Meal"
local BONE_MEAL_THRESHOLD = 8 -- Минимальное количество костной муки перед пополнением

function fertilizer()
    if TYPE_FERTILIZER == "Bone Meal" then
        for i = 1, i_c.getInventorySize(sides.down) do
            
        end
        for i = 2, robot.getInventorySize() do
            local curr_slot = i_c.getStackInInternalSlot(i)
            if curr_slot and curr_slot.label == TYPE_FERTILIZER and curr_slot.size < BONE_MEAL_THRESHOLD then
                --не то
            end
        end
    end
end

function place_sapling()
    robot.select(1)
    robot.place()
end

function main()
    place_sapling()
end
  
main()
