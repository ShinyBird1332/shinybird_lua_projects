--верх: описание программы в рамочке
--левая 2/3 матрица кнопок с компонентами
-- правая 1/3 статус работы программы (консоль)
--низ: старт, стоп, сброс, настройка сторон, ввод айпишника транспозера (последние два выводятся справа в консоли)

















local filesystem = require("filesystem")
local serialization = require("serialization")
local shell = require("shell")

local currentDir = shell.getWorkingDirectory()
local Path = filesystem.concat(currentDir, "config.lua")
local trans_list = dofile(Path)

function save_config()
    local file = io.open(Path, "w")
    file:write("return " .. serialization.serialize(trans_list))
    file:close()
end