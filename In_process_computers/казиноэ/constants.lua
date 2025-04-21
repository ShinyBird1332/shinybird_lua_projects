local constants = {}

constants.component = require("component")
constants.sides = require("sides")
constants.math = require("math")
constants.os = require("os")
constants.term = require("term")

constants.side_1 = sides.north
constants.side_3 = sides.south

constants.gpu = component.gpu
constants.w, constants.h = gpu.getResolution()

constants.trans = {
    component.proxy("34112f58-10d5-498a-87ba-4d0649ac5046"), -- для поиска монеток
    component.proxy("b0c87d03-61b3-4cfb-9f49-b85218950431") -- для выдачи приза
}

constants.list_items = {
    [1] = { 
        {name = "Cobblestone", min = 0, max = 150, color = 0x00FF00},
        {name = "Dirt", min = 150, max = 300, color = 0x00FF00},
        {name = "Oak Wood", min = 300, max = 400, color = 0x00FF00},
        {name = "Ruby", min = 400, max = 500, color = 0x00FF00},
        {name = "Raw Rubber", min = 500, max = 600, color = 0x00FF00},
        {name = "Iron Ingot", min = 600, max = 750, color = 0x00FF00},
        {name = "Gold Ingot", min = 750, max = 850, color = 0x00FF00},
        {name = "Diamond", min = 850, max = 950, color = 0x00FF00},
        {name = "Nether Star", min = 950, max = 1000, color = 0x00FF00}
    },
    [1] = { 
        {name = "Cobblestone", min = 0, max = 150, color = 0x00FF00},
        {name = "Dirt", min = 150, max = 300, color = 0x00FF00},
        {name = "Oak Wood", min = 300, max = 400, color = 0x00FF00}, --великое дерево


        {name = "Iron Ingot", min = 600, max = 750, color = 0x00FF00},
        {name = "Gold Ingot", min = 750, max = 850, color = 0x00FF00},
        {name = "Diamond", min = 850, max = 950, color = 0x00FF00},
        {name = "Nether Star", min = 950, max = 1000, color = 0x00FF00}
    },
    [2] = { 
        {name = "Eden Soul", min = 0, max = 250, color = 0x00FF00},
        {name = "Skythern Soul", min = 250, max = 450, color = 0x00FF00},
        {name = "Block of Diamond", min = 450, max = 550, color = 0x00FF00},
        {name = "Electronic Circuit", min = 550, max = 650, color = 0x00FF00},
        {name = "Molecular Assembler", min = 650, max = 700, color = 0x00FF00},
        {name = "Shiny Ingot", min = 700, max = 750, color = 0x00FF00},
        {name = "Basic Energy Cube", min = 750, max = 920, color = 0x00FF00},
        {name = "Draconium Block", min = 920, max = 970, color = 0x00FF00},
        {name = "Mob Soul", min = 970, max = 1000, color = 0x00FF00}
    },
    [3] = { 
        {name = "Thaumium Ingot", min = 0, max = 200, color = 0x00FF00},
        {name = "Neutronium Ingot", min = 200, max = 400, color = 0x00FF00},
        {name = "Enderium Ingot", min = 400, max = 550, color = 0x00FF00},
        {name = "Terrasteel Ingot", min = 550, max = 650, color = 0x00FF00},
        {name = "Shadow Metal Ingot", min = 650, max = 750, color = 0x00FF00},
        {name = "Void metal Ingot", min = 750, max = 850, color = 0x00FF00},
        {name = 'Mobius "Unstable/Stable" Ingot', min = 850, max = 900, color = 0x00FF00},
        {name = "Raw Meat Ingot", min = 900, max = 970, color = 0x00FF00},
        {name = "Fiery Ingot", min = 970, max = 1000, color = 0x00FF00}
    },
    [4] = { 
        {name = "Ichor", min = 0, max = 200, color = 0x00FF00},
        {name = "Gaia Spirit", min = 200, max = 400, color = 0x00FF00},
        {name = "Replicator", min = 400, max = 550, color = 0x00FF00},
        {name = "Block of Bedrockium", min = 550, max = 650, color = 0x00FF00},
        {name = "Charged Draconium Block", min = 650, max = 750, color = 0x00FF00},
        {name = "Order Infused Triple Compressed Solar Panel", min = 750, max = 850, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 850, max = 900, color = 0x00FF00},
        {name = "Молекулярный преобразователь", min = 900, max = 970, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 970, max = 1000, color = 0x00FF00}
    },
    [5] = { 
        {name = "Ichor", min = 0, max = 200, color = 0x00FF00},
        {name = "Gaia Spirit", min = 200, max = 400, color = 0x00FF00},
        {name = "Replicator", min = 400, max = 550, color = 0x00FF00},
        {name = "Block of Bedrockium", min = 550, max = 650, color = 0x00FF00},
        {name = "Charged Draconium Block", min = 650, max = 750, color = 0x00FF00},
        {name = "Order Infused Triple Compressed Solar Panel", min = 750, max = 850, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 850, max = 900, color = 0x00FF00},
        {name = "Молекулярный преобразователь", min = 900, max = 970, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 970, max = 1000, color = 0x00FF00}
    },
    [6] = { --ботания
        {name = "Livingrock", min = 0, max = 150, color = 0x00FF00},
        {name = "Искра Фрейи", min = 150, max = 300, color = 0x00FF00},
        {name = "Tiny Potato", min = 350, max = 450, color = 0x00FF00},
        {name = "Mana Diamond", min = 450, max = 600, color = 0x00FF00},
        {name = "Mana Pearl", min = 600, max = 750, color = 0x00FF00},
        {name = "Бассейн маны Фрейи", min = 750, max = 800, color = 0x00FF00},
        {name = "Terrasteel Ingot", min = 800, max = 950, color = 0x00FF00},
        {name = "Gaya Spirit Ingot", min = 950, max = 995, color = 0x00FF00},
        {name = "Infinitato", min = 995, max = 1000, color = 0x00FF00}
    },
    [7] = { --таум
        {name = "Thaumium Ingot", min = 0, max = 150, color = 0x00FF00},
        {name = "Balanced Shard", min = 150, max = 300, color = 0x00FF00},
        {name = "Nitor", min = 300, max = 400, color = 0x00FF00},
        {name = "Enchanted Fabric", min = 400, max = 550, color = 0x00FF00},
        {name = "Primal Charm", min = 550, max = 650, color = 0x00FF00},
        {name = "Void metal Ingot", min = 650, max = 800, color = 0x00FF00},
        {name = "Eldritch Eye", min = 800, max = 900, color = 0x00FF00},
        {name = "Pride Shard", min = 900, max = 970, color = 0x00FF00},
        {name = "Primordial Pearl", min = 970, max = 1000, color = 0x00FF00}
    },
    [8] = { --джекпот
        {name = "Iron Ingot", min = 0, max = 990, color = 0x00FF00},
        {name = "Квантовая солнечная панель", min = 990, max = 1000, color = 0x00FF00}
    },
}

local cases = {"Медная монетка", "Серебряная монетка", "Золотая монетка", "Алмазная монетка", "Бесконечная монетка", "", "", ""}

return constants