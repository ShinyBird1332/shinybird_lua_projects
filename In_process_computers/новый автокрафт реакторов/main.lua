local constants = dofile("constants.lua")


--идея: сделать программу, которая будет контролировать существующие реакторы, контролировать генераторы материи, которые обеспечивают его ураном
-- и создавать новые реакторы с моментальной привязкой к программе
--надо роботу добавить режим раскопки (в интерфейсе создания реактора флажок "расчистить местность")


--сначала сканируем основной сундук на наличие всех блоков
--если что-то есть, создаем этого блока меньше 

--проблемы:
--придется ставить робота вручную, где будет расположен новыей реактор
--как сразу привязывать новый реактор к системе реакторов?
--надо как-то передавать удаленно информацию от реакторов
--мб поставить снизу комп и связать связанными картами?


--показатели для мониторинга реакторов:
--температура корпуса и ядра - шкала с процентом нагрева
--кол-во топлива - шкала
--буфер энергии - шкала
--выработка энергии в тик
--потребление топлива


function check_order()
    for i = 1, #trans_list do
        local name_slot_item = trans_list[i][1]
        local name_trans = com.proxy(trans_list[i][2])
        local fluid_cost = trans_list[i][3]
        local count = 0

        for slot = 1, trans_main.getInventorySize(SIDE_IN) do
            if trans_main.getStackInSlot(SIDE_IN, slot) then
                local current_item = trans_main.getStackInSlot(SIDE_IN, slot).label

                if current_item == name_slot_item then
                    local c = trans_main.transferItem(SIDE_IN, SIDE_OUT, 64, slot, slot)
                    count = count + c
                end
            end
        end
        print("Заказ: ", count, name_slot_item)
        transfer_fluid(count, name_trans, fluid_cost)
    end
end

function main()
    
end

main()