--отправляет
local comp = require("component") 
local modem = comp.modem

modem.broadcast(4, "hello")