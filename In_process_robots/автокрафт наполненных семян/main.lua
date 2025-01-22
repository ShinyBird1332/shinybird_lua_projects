local comp = require("component")
--local robot = require("robot")
local sides = require("sides")
--local i_c = comp.inventory_controller
--local crafting = comp.crafting 

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
    ["Arbor"] = {"Aer", "Herba"},
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
    ["Ira"] = {"Telum", "Ignis"},
    ["Tempus"] = {"Vacuous", "Ordo"},
    ["Terminus"] = {"Lucrum", "Alienis"}
}
function t(value)
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
        print(c[1], c[2])
    end
    
end

function tree_craft_seed(seed)
    print("Поиск семян: ".. seed)
    
    for key, value in pairs(craft_acpects) do
        if key == seed then
            print("Искомая пара: " .. value[1] .. ", " .. value[2])
            t(value)
        end
    end
end

function check_need_seeds()
    
end

function main()
    tree_craft_seed("Terminus")
end

main()