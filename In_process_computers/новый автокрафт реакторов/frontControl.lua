local frontControl = dofile("frontControl.lua")

--показатели для мониторинга реакторов:
--температура корпуса и ядра - шкала с процентом нагрева
--кол-во топлива - шкала
--буфер энергии - шкала
--выработка энергии в тик
--потребление топлива

local constants = dofile("constants.lua")
cur_w = math.floor(constants.w / 4)
cur_h = math.floor(constants.h / 4)

function t(pos_x, pos_y, reactor_number, r_corp_temp, r_core_temp, r_count_fuel,
            r_count_energy, r_gen_energy, r_grab_fuel)
    
    constants.gpu.setBackground(constants.colors.white)
    for i = 1, cur_w do
        for j = 1, cur_h do
            if i == 1 or i == cur_w or j == 1 or j == cur_h then
                constants.gpu.fill(i + pos_x, j + pos_y, 1, 1, " ")
            end
        end
    end
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 2, "Реактор № " .. reactor_number)
    constants.gpu.set((pos_x + cur_w / 2) - 7, pos_y + 3, "Реактор № " .. reactor_number)
    --constants.gpu.fill(pos_x, pos_y, r_corp_temp, 10, " ")
end

function main()
    c = 1
    
    constants.gpu.setForeground(constants.colors.white)
    constants.gpu.setBackground(constants.colors.black)
    constants.gpu.fill(1, 1, constants.w, constants.h, " ")
    

    for i = 0, 3 do
        for j = 0, 3 do
            t(i * cur_w, j * cur_h, c)
            c = c + 1
        end
    end

end

main()

return frontControl