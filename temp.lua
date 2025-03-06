--принимает
local event = require("event")
local comp = require("component") 
local modem = comp.modem

modem.open(4)


local _, _, from, port, _, message = event.pull("modem_message")
print("Got a message from " .. from .. " on port " .. port .. ": " .. tostring(message))
