local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local crafting = comp.crafting 
local tract = comp.tractor_beam

--робот получил команду сделать семечко итер
--итер = мотус + терра
--мотус = аер + ордо
--итого роботу надо терра аер и ордо
--робот ожидает получения 3 семечек от пользовтеля
--проверяет имя первых 3х предметов, если они все инфузед сидс, надеемся, что пользователь положил все верно
--пользователь должен положить семена в строгом порядке: сначала первая итерация, потом вторая, третья и т д
--робот сажает первое семечко, выращивает, собирает
--забирает семечко с сундука, кладет в тот же слот, где оно и лежало
--смотрит на дроп, который выпал, помимо семечка, определяет, что это за семечко
--сажает второе, так же выращивает
--проверяет сундук, если дроп отличается вывод успешный


--новый план
--есть 6 сундуков, в каждом свое безовое семечко
--когда робот находит первую пару базовых аспектов, он берет их в строгом порядке
--ставит землю, вспахивает, сажает семечку (чтоб убрать прошлые аспекты)
--выращивает семечки и так же проверяет лут (надо в таблицу все таки записать примерный лут)
--когда нужный дроп выпал (значит, семечко вывелось), складывает его в первый слот сундука, себе запоминает, что, например lux = 1 слот
--идет дальше по рекурсии

base_seeds = {"Aer", "Perditio", "Ordo", "Terra", "Ignis", "Aqua"}

craft_acpects = {
    ["Vacuous"] = {essential = {"Aer", "Perditio"}, drop = ""},
    ["Lux"] = {essential = {"Aer", "Ignis"}, drop = ""},
    ["Tempestas"] = {essential = {"Aer", "Aqua"}, drop = ""},
    ["Motus"] = {essential = {"Aer", "Ordo"}, drop = "Rail"},
    ["Gelum"] = {essential = {"Perditio", "Ignis"}, drop = ""},
    ["Viterus"] = {essential = {"Terra", "Ordo"}, drop = ""},
    ["Victus"] = {essential = {"Aqua", "Terra"}, drop = ""},
    ["Venenum"] = {essential = {"Perditio", "Aqua"}, drop = ""},
    ["Potentia"] = {essential = {"Ordo", "Ignis"}, drop = ""},
    ["Permutatio"] = {essential = {"Perditio", "Ordo"}, drop = ""},
    ["Metallum"] = {essential = {"Viterus", "Terra"}, drop = ""},
    ["Mortuus"] = {essential = {"Perditio", "Victus"}, drop = ""},
    ["Volatus"] = {essential = {"Motus", "Aer"}, drop = ""},
    ["Terebrae"] = {essential = {"Lux", "Vacuous"}, drop = ""},
    ["Spiritus"] = {essential = {"Victus", "Mortuus"}, drop = ""},
    ["Sano"] = {essential = {"Victus", "Ordo"}, drop = ""},
    ["Iter"] = {essential = {"Motus", "Terra"}, drop = "Arcane"},
    ["Alienis"] = {essential = {"Vacuous", "Terebrae"}, drop = ""},
    ["Praecantatio"] = {essential = {"Vacuous", "Potentia"}, drop = ""},
    ["Auram"] = {essential = {"Aer", "Praecantatio"}, drop = ""},
    ["Vitium"] = {essential = {"Perditio", "Praecantatio"}, drop = ""},
    ["Limus"] = {essential = {"Aqua", "Victus"}, drop = ""},
    ["Herba"] = {essential = {"Victus", "Terra"}, drop = ""},
    ["Bestia"] = {essential = {"Victus", "Motus"}, drop = ""},
    ["Corpus"] = {essential = {"Bestia", "Mortuus"}, drop = ""},
    ["Exanimis"] = {essential = {"Mortuus", "Motus"}, drop = ""},
    ["Cognitio"] = {essential = {"Ignis", "Spiritus"}, drop = ""},
    ["Sensus"] = {essential = {"Aer", "Spiritus"}, drop = ""},
    ["Humanus"] = {essential = {"Cognitio", "Bestia"}, drop = ""},
    ["Messis"] = {essential = {"Humanus", "Herba"}, drop = ""},
    ["Perfodio"] = {essential = {"Humanus", "Terra"}, drop = ""},
    ["Instrumentum"] = {essential = {"Humanus", "Ordo"}, drop = ""},
    ["Meto"] = {essential = {"Instrumentum", "Messis"}, drop = ""},
    ["Telum"] = {essential = {"Instrumentum", "Ignis"}, drop = ""},
    ["Tutamen"] = {essential = {"Instrumentum", "Terra"}, drop = ""},
    ["Fames"] = {essential = {"Vacuous", "Victus"}, drop = ""},
    ["Lucrum"] = {essential = {"Fames", "Humanus"}, drop = ""},
    ["Fabrico"] = {essential = {"Humanus", "Instrumentum"}, drop = ""},
    ["Pannus"] = {essential = {"Instrumentum", "Bestia"}, drop = ""},
    ["Machina"] = {essential = {"Instrumentum", "Motus"}, drop = ""},
    ["Vinculum"] = {essential = {"Perditio", "Motus"}, drop = ""},
    ["Luxuria"] = {essential = {"Corpus", "Fames"}, drop = ""},
    ["Infernus"] = {essential = {"Praecantatio", "Ignis"}, drop = ""},
    ["Superbia"] = {essential = {"Vacuous", "Volatus"}, drop = ""},
    ["Gula"] = {essential = {"Vacuous", "Fames"}, drop = ""},
    ["Invidia"] = {essential = {"Fames", "Sensus"}, drop = ""},
    ["Dedisia"] = {essential = {"Spiritus", "Vinculum"}, drop = ""},
    ["Tempus"] = {essential = {"Vacuous", "Ordo"}, drop = ""},
    ["Terminus"] = {essential = {"Lucrum", "Alienis"}, drop = ""}
}

function tree_craft_seed(seed)
    print("Поиск семян: ".. seed)
    
    for key, value in pairs(craft_acpects) do
        if key == seed then
            print("Искомая пара: " .. value.essential[1] .. ", " .. value.essential[2])
            local c = {}
            for _, unknown_essential in pairs(value.essential) do
                local req = true
        
                for _, base_essential in pairs(base_seeds) do
                    if unknown_essential == base_essential then
                        req = false
                    end
                end
                if req then
                    tree_craft_seed(unknown_essential)
        
                else
                    table.insert(c, unknown_essential)
                end
            end
            if c[1] and c[2] then
                craft_new_seed(c[1], c[2])
            end
        end
    end
end

function craft_new_seed(seed_1, seed_2)
    while true do
        print("Требуется поместить в первый слот семечко " .. seed_1 .. ", во второй " .. seed_2)
        print("После установки семечек, нажмите Enter")
        local ready = io.read()
        if i_c.getStackInInternalSlot(1) and i_c.getStackInInternalSlot(1).label:find("Infused")
        and i_c.getStackInInternalSlot(2) and i_c.getStackInInternalSlot(2).label:find("Infused") then
            print("Семена успешно найдены, надеюсь, вы положили те семена :)")
            break
        else
            print("Семена не найдены, попробуйте еще")
        end
    end

    local c = 1
    local i = 1
    while true do
        sort_seeds()
        robot.select(i)

        robot.place()
        fertilizer()
        grab_res()
        if scan_new_drop() then return end
        c = c + 1
        if c % 2 == 0 then i = 2
        else i = 1 end
    end
end

function sort_seeds()
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label == "Infused Seeds" then
            robot.select(i)
            local t1 = i_c.getStackInInternalSlot(1)
            if t1 and t1.label ~= "Infused Seeds" and t1.size > 0 then
                robot.transferTo(1) 
            else
                robot.transferTo(2)
            end
        end
    end
end

function fertilizer()
    robot.turnLeft()
    robot.swing()
    robot.turnRight()
    for _ = 1, 3 do
        robot.use()
    end
    robot.turnRight()
    robot.swing()
    robot.turnLeft()
end

function grab_res()
    robot.up()
    robot.fill()
    os.sleep(0.3)
    robot.drain()
    robot.down()
    os.sleep(0.5)
    for _ = 1, 3 do
        tract.suck()
        os.sleep(1)
    end
end

function scan_new_drop()
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label ~= "Infused Seeds" then
            for key, value in pairs(craft_acpects) do
                if value.drop:find(robot_slot.label) then
                    print("Вывелось новое семечко: " .. key)
                    return true
                end
            end
            return false
        end
    end
end

function main()
    tree_craft_seed("Humanus")
end

main()