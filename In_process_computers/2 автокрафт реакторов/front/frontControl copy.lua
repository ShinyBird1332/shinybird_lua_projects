local frontControl = {}

local constants = dofile("constants.lua")
local frontAdditionalControl = dofile("frontAdditionalControl.lua")
local guiModuls = dofile("guiModuls.lua")
local colors = constants.colors
local buttons = {}

function ttt()
    constants.modem.broadcast(4, "wait_mes")
    local _, _, _, _, _, message = constants.event.pull("modem_message")
    local res = {}

    local success, t = pcall(constants.serialization.unserialize, message)
    print(t[1].reactor_count_fluid, t)

    for i = 1, 24 do
        table.insert(res, {reactor_count_fluid = t[i].reactor_count_fluid} or "N/A")

    end
    return res
end

--отрисовка кнопок реакторов
function frontControl.draw_reactors_buttons()
    local reactors = ttt()


    local reactor_number = 1
    for i = 0, 4 do
        for j = 0, 4 do
            local pos_x = j * cur_w
            local pos_y = i * cur_h
            local reactor_count_fluid = reactors[1].reactor_count_fluid or  "N/A"
            local reactor_gen_energy = 5 or "N/A"

            table.insert(
                buttons, guiModuls.draw_button(
                pos_x, pos_y, cur_w, cur_h, "", colors.gray, colors.black, colors.white, function() frontAdditionalControl.main(reactor_number) end)
            )
            constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 3, "Реактор № " .. reactor_number .. "   ")
 
            constants.gpu.set(pos_x + 8, pos_y + 5, "Кол-во топлива: " .. reactor_count_fluid .. "%")
            constants.gpu.set(pos_x + 5, pos_y + 7, "Выработка энергии: " .. reactor_gen_energy .. " rf/t")
            reactor_number = reactor_number + 1 

        end
    end
end

function frontControl.main()
    frontControl.draw_reactors_buttons()
end

frontControl.main()

return frontControl