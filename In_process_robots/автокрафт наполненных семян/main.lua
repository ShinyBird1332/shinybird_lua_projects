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
    ["Vacuous"] = {"Aer", "Perditio"},
    ["Lux"] = {"Aer", "Ignis"},
    ["Tempestas"] = {"Aer", "Aqua"},
    ["Motus"] = {"Aer", "Ordo"},
    ["Gelum"] = {"Perditio", "Ignis"},
    ["Viterus"] = {"Terra", "Ordo"},
    ["Victus"] = {"Aqua", "Terra"},
    ["Venenum"] = {"Perditio", "Aqua"},
    ["Potentia"] = {"Ordo", "Ignis"},
    ["Permutatio"] = {"Perditio", "Ordo"},
    ["Metallum"] = {"Viterus", "Terra"},
    ["Mortuus"] = {"Perditio", "Victus"},-----------------
    ["Volatus"] = {"Motus", "Aer"},
    ["Terebrae"] = {"Lux", "Vacuous"},
    ["Spiritus"] = {"Victus", "Mortuus"},
    ["Sano"] = {"Victus", "Ordo"},
    ["Iter"] = {"Motus", "Terra"},
    ["Alienis"] = {"Vacuous", "Terebrae"},
    ["Praecantatio"] = {"Vacuous", "Potentia"},
    ["Auram"] = {"Aer", "Praecantatio"},
    ["Vitium"] = {"Perditio", "Praecantatio"},
    ["Limus"] = {"Aqua", "Victus"},
    ["Herba"] = {"Victus", "Terra"},
    ["Bestia"] = {"Victus", "Motus"},
    ["Corpus"] = {"Bestia", "Mortuus"},
    ["Exanimis"] = {"Mortuus", "Motus"},
    ["Cognitio"] = {"Ignis", "Spiritus"},
    ["Sensus"] = {"Aer", "Spiritus"},
    ["Humanus"] = {"Cognitio", "Bestia"},
    ["Messis"] = {"Humanus", "Herba"},
    ["Perfodio"] = {"Humanus", "Terra"},
    ["Instrumentum"] = {"Humanus", "Ordo"},
    ["Meto"] = {"Instrumentum", "Messis"},
    ["Telum"] = {"Instrumentum", "Ignis"},
    ["Tutamen"] = {"Instrumentum", "Terra"},
    ["Fames"] = {"Vacuous", "Victus"},
    ["Lucrum"] = {"Fames", "Humanus"},
    ["Fabrico"] = {"Humanus", "Instrumentum"},
    ["Pannus"] = {"Instrumentum", "Bestia"},
    ["Machina"] = {"Instrumentum", "Motus"},
    ["Vinculum"] = {"Perditio", "Motus"},
    ["Luxuria"] = {"Corpus", "Fames"},
    ["Infernus"] = {"Praecantatio", "Ignis"},
    ["Superbia"] = {"Vacuous", "Volatus"},
    ["Gula"] = {"Vacuous", "Fames"},
    ["Invidia"] = {"Fames", "Sensus"},
    ["Dedisia"] = {"Spiritus", "Vinculum"},
    ["Tempus"] = {"Vacuous", "Ordo"},
    ["Terminus"] = {"Lucrum", "Alienis"}
}

function tree_craft_seed(seed)
    print("Поиск семян: ".. seed)
    
    for key, value in pairs(craft_acpects) do
        if key == seed then
            print("Искомая пара: " .. value[1] .. ", " .. value[2])
            local c = {}
            for _, unknown_essential in pairs(value) do
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
            if robot.count(1) > 0 then --и имя не семечко
                robot.transferTo(2) 
            else
                robot.transferTo(1)
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
                if value[3] == robot_slot.label then
                    print("Вывелось новое семечко: " .. key)
                    return true
                end
            end
            return false
        end
    end
end

function main()
    tree_craft_seed("Terminus")
end

main()