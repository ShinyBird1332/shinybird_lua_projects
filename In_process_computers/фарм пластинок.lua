
--powered by ShinyBird368
local fs = require("filesystem")
local comp = require("component") 
local sides = require("sides")
local gpu = comp.gpu
local reds = comp.redstone

--down = 0
--up = 1 
--north = 2 
--south = 3
--west = 4
--east = 5

local side_dump = sides.north
local side_clear = sides.east
local side_count = sides.west

local time_restart_start = 59
local time_restart_stop = 10


function getHostTime(timezone)
    timezone = timezone or 2
    local file = io.open("/HostTime.tmp", "w")
    
    file:write("")
    file:close()

    local timeCorrection = timezone * 3600
    local lastModified = tonumber(string.sub(fs.lastModified("/HostTime.tmp"), 1, -4)) + timeCorrection
    fs.remove("/HostTime.tmp")

    local year = os.date("%Y", lastModified)
    local month = os.date("%m", lastModified)
    local day = os.date("%d", lastModified)
    local hour = os.date("%H", lastModified)
    local minute = os.date("%M", lastModified)
    local second = os.date("%S", lastModified)

    return tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute), tonumber(second)
end

function real_time() 
    local text = string.format("%02d:%02d:%02d", host_time[4], host_time[5], host_time[6]) 
    return text
end

function clear_monitor(color_bg, color_fg)
    local w,h = gpu.getResolution()
    local oldbg = gpu.getBackground()
    local oldfg = gpu.getForeground()

    gpu.setBackground(color_bg)
    gpu.setForeground(color_fg)
    gpu.fill(1, 1, w, h, " ")
    gpu.setBackground(oldbg)
    gpu.setForeground(oldfg)
end

function check_clear()
    local mobs = reds.getInput(side_count)
    if mobs == 0 then
        gpu.set(1, 1, "[" .. real_time() .. "] Отчистка!")
        reds.setOutput(side_clear, 15)
    else
        gpu.set(1, 1, "[" .. real_time() .. "]")
        reds.setOutput(side_clear, 0)
    end
end

function restart()
    if (host_time[4] == 15 and host_time[5] == 59 and host_time[6] > time_restart_start) or 
    (host_time[4] == 16 and host_time[5] == 00 and host_time[6] < time_restart_stop) or 
    (host_time [4] == 00 and host_time[5] == 00 and host_time[6] > time_restart_start)  or 
    (host_time[4] == 00 and host_time[5] == 00 and host_time[6] < time_restart_stop) then 
        gpu.set(2, 1, "[Рестарт, смываем криперов]")
        reds.setOutput(side_dump, 15)
    else
        reds.setOutput(side_dump, 0)
  end
end

function main()
    while true do 
        host_time = {getHostTime(3)} 
        clear_monitor(1, 1) 
        check_clear()
        --restart()
        os.sleep(1)
    
    end
end

main()