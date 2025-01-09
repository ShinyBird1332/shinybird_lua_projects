local comp = require("component")


local trans = {--тут надо указать адресс каждого транспозера
    ["Reactor Casing"] = comp.proxy("38cc7dca-f832-4cc2-8b2f-d1ca4ceb0eed"), 5
    ["Reactor Controller"] = comp.proxy("c203a636-b8c2-4d0e-9896-321d17dc3522"), 89
    ["Reactor Control Rod"] = comp.proxy("7885a746-1289-4634-a788-7df650635563"), 36
    ["Yellorium Fuel Rod"] = comp.proxy("015e9812-bff7-430b-8a49-e0c042b313e0"), 20
    ["Reactor Access Port"] = comp.proxy("0a734a88-9f52-4f0d-99b2-013a0de8625e"), 78
    ["Reactor Power Tap"] = comp.proxy("8d96cdd7-8c80-4369-a9cb-9f78103b5920"), 25
    ["main"] = comp.proxy("20a0be72-e470-4b47-8634-b4e8debb37be")
}