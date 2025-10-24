local backClearBee = {}
--Привести пчелу до состояния: 1 чистая принцесса и 64 трутня в стаке
--1) просканировать сундук для составления списка всех доступных пчел (предусмотреть все возможные дубликаты)
--2) выбрать пчелу из списка (возможно, так же, сделать поиск)
--3) если есть только половина пары, нужно по сломарю смотреть, как не потерять пчелу

local constants = dofile("constants.lua")

local side_storage = constants.sides.west

function backClearBee.main()
    for i = 1, constants.trans_main.getInventorySize(side_storage) do
        local item = constants.trans_main.getStackInSlot(side_storage, i)
        if item then
            print(item.label)
        end
    end
end

backClearBee.main()

return backClearBee
