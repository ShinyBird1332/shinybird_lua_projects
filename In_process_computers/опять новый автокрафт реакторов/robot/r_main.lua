--Developed by ShinyBird368

--ВАЖНО!!! Программа все еще на версии беты, так что перед постройкой обязательно расчистите место для будушей структуры (15х15х19)

--Конфигурация робота:
----системный блок 3-го уровня
--процессор с видеокартой 2-й уровень
--память 2-й уровень
--диск 2-й уровень
--монитор 1-й уровень
--клавиатура
--дисковод (опционально, но желательно)
--биос
--контейнер для улучшения 2-й лвл 
--контейнер для улучшения 3-й лвл 
--улучшение инвентарь
--улучшение контроллер инвентаря
--улучшение бак
--улучшение генератор
--улучшение ангельское
--улучшение парение 1-й уровень 

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")
local reactor = dofile("reactor.lua")

function main()
    --if not functions.check_kit_start() then return end --тут надо чето вернуть компу
    --functions.move_start()
    reactor.build_floor()
    reactor.build_walls()
    reactor.build_rods()
    reactor.fill_redstone()
    reactor.build_roof_1()
    reactor.build_roof_2()
end

main()
