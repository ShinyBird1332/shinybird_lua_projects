local comp = require("component")
local sides = require("sides")
local trans = comp.transposer
local filesystem = require("filesystem")
local shell = require("shell")
local currentDir = shell.getWorkingDirectory()
local Path = filesystem.concat(currentDir, "config.lua")

side = sides.east

bee = trans.getStackInSlot(side, 1)
res = ""

function main(bee, prob)
    for i, j in pairs(bee) do
        if type(j) == "table" then
            res = res .. tostring(i) .. "\n"
            main(j, prob + 1)
        else
            res = res .. string.rep("  ", prob) .. tostring(i) .. " - " .. tostring(j) .. "\n"
        end
    end
end

function save_config()
    local file = io.open(Path, "w")
    file:write(res)
    file:close()
end

main(bee, 0)
save_config()
