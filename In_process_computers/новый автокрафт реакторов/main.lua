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