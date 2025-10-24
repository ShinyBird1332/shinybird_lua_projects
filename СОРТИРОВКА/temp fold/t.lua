local temp = {}

temp.comp = require("component") 
temp.modem = temp.comp.modem
temp.modem.open(4)

return temp