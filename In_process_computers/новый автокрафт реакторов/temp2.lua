--[[
opencomputers управление для big reactors
автор: Differin
http://pastebin.com/sjJi0bum  --загрузчик
 
совместил с апи в одну прогу для удобства.
перевел интерфейс на русский.
 
использование:
подключить кабелем из opencomputers
к компьютерному порту реактора, или
поставить системник в притык как у автора.
по умолчанию экран 3х2 третьего уровня.
установить минимальное и максимальное
значения аккумулятора реактора в процентах.
кнопка Q(Й) для выхода из программы.
]]--
 
local filesystem = require("filesystem")
local component = require("component")
local keyboard = require("keyboard")
local event = require("event")
local gpu = component.gpu
local reactor = component.br_reactor
 
local colors = { blue = 0x4286F4, purple = 0xB673d6, red = 0xC14141, green = 0xDA841,
  black = 0x000000, white = 0xFFFFFF, grey = 0x47494C, lightGrey = 0xBBBBBB}
-- установить размер экрана для уровня 3
gpu.setResolution(132,38)
gpu.setBackground(colors.black)
gpu.fill(1, 1, 132, 38, " ")
 
local sections = {}
local graphs = {}
local infos = {}
local button = {}
 
-- начальные значения
reactor["stats"] = {}
local running = true
local maxRF = 0
local currentRodLevel = 0
local currentRf = 0
local currentRfTick = 0
local currenFuel = 0
local minPowerRod = 0
local maxPowerRod = 100
 
-- функции
function clearTable()
  button = {}
end
 
function setTable(name, func, xmin, ymin, xmax, ymax, text, colors)
  button[name] = {}
  button[name]["text"] = text
  button[name]["func"] = func
  button[name]["active"] = false
  button[name]["xmin"] = xmin
  button[name]["ymin"] = ymin
  button[name]["xmax"] = xmax
  button[name]["ymax"] = ymax
  button[name]["colors"] = colors
end
 
function fill(bData)
  local yspot = math.floor((bData["ymin"] + bData["ymax"]) /2)
  local xspot = math.floor((bData["xmin"] + bData["xmax"]) /2) - math.floor((string.len(bData["text"])/2))
  local oldColor = gpu.getBackground()
  local curColor = bData["colors"].on
  if bData["active"] then
    curColor = bData["colors"].off
  end
  gpu.setBackground(curColor)
  gpu.fill(bData["xmin"], bData["ymin"], bData["xmax"] - bData["xmin"] + 1, bData["ymax"] - bData["ymin"] + 1, " ")
  gpu.set(xspot, yspot, bData["text"])
  gpu.setBackground(oldColor)
end
 
function screen()
  for name,data in pairs(button) do
     fill(data)
  end
end
 
function toggleButton(name)
  button[name]["active"] = not button[name]["active"]
  screen()
end
 
function checkxy(_, _, x, y, _, _)
  for name, data in pairs(button) do
    if y >= data["ymin"] and y <= data["ymax"] then
      if x >= data["xmin"] and x <= data["xmax"] then
        data["func"]()
        return true
      end
    end
  end
  return false
end
 
function setSections()
  sections["graph"] = { x = 5, y = 3, width = 78, height= 33, title = "  инфо  "}
  sections["controls"] = { x = 88, y = 3, width = 40, height = 20, title = "  управление  "}
  sections["info"] = { x = 88, y = 26, width = 40, height= 10, title = "  значения  "}
end
 
function setGraphs()
  graphs["tick"] = { x = 8, y = 6, width = 73, height= 8, title = "ЭНЕРГИИ ЗА ТИК"}
  graphs["stored"] = { x = 8, y = 16, width = 73, height = 8, title = "НАКОПЛЕНО ЭНЕРГИИ"}
  graphs["rods"] = { x = 8, y = 26, width = 73, height= 8, title = "УРОВЕНЬ СТЕРЖНЕЙ"}
end
 
function setInfos()
  infos["tick"] = { x = 92, y = 28, width = 73, height= 1, title = "энергии за тик    : ", unit = " RF"}
  infos["stored"] = { x = 92, y = 30, width = 73, height = 1, title = "накоплено энергии : ", unit = " RF"}
  infos["rods"] = { x = 92, y = 32, width = 73, height= 1, title = "уровень стержней  : ", unit = "%"}
  infos["fuel"] = { x = 92, y = 34, width = 73, height= 1, title = "расход топлива    : ", unit = " Mb/t"}
end
 
function setButtons()
  setTable("ON", powerOn, 91, 5, 106, 7,"ВКЛ", {on = colors.green, off = colors.green})
  setTable("OFF", powerOff, 109, 5, 125, 7,"ВЫКЛ", {on = colors.red, off = colors.red})
  setTable("lowerMinLimit", lowerMinLimit, 91, 15, 106, 17,"-10", {on = colors.blue, off = colors.blue})
  setTable("lowerMaxLimit", lowerMaxLimit, 109, 15, 125, 17,"-10", {on = colors.purple, off = colors.purple})
  setTable("augmentMinLimit", augmentMinLimit, 91, 19, 106, 21,"+10", {on = colors.blue, off = colors.blue})
  setTable("augmentMaxLimit", augmentMaxLimit, 109, 19, 125, 21,"+10", {on = colors.purple, off = colors.purple})
end
 
function printBorders(sectionName)
  local s = sections[sectionName]
  gpu.setBackground(colors.grey)
  gpu.fill(s.x, s.y, s.width, 1, " ")
  gpu.fill(s.x, s.y, 1, s.height, " ")
  gpu.fill(s.x, s.y + s.height, s.width, 1, " ")
  gpu.fill(s.x + s.width, s.y, 1, s.height + 1, " ")
  gpu.setBackground(colors.black)
  gpu.set(s.x + 2, s.y, s.title)
end
 
function printGraphs(graphName)
  local g = graphs[graphName]
  gpu.setBackground(colors.lightGrey)
  gpu.fill(g.x, g.y, g.width, g.height, " ")
  gpu.setBackground(colors.black)
  gpu.set(g.x, g.y - 1, g.title)
end
 
function printActiveGraphs(activeGraph)
  local g = activeGraph
  gpu.setBackground(colors.green)
  gpu.fill(g.x, g.y, g.width, g.height, " ")
  gpu.setBackground(colors.black)
end
 
function printStaticControlText()
  gpu.setForeground(colors.blue)
  gpu.set(97,12, "MIN")
  gpu.setForeground(colors.purple)
  gpu.set(116,12, "MAX")
  gpu.setForeground(colors.white)
  gpu.set(100,10, "авто - управление")
  gpu.set(107,13, "--")
end
 
function printControlInfos()
  gpu.setForeground(colors.blue)
  gpu.set(97,13, minPowerRod .. "% ")
  gpu.setForeground(colors.purple)
  gpu.set(116,13, maxPowerRod .. "% ")
  gpu.setForeground(colors.white)
end
 
function printInfos(infoName)
  local maxLength = 15
  local i = infos[infoName]
  local spaces = string.rep(" ", maxLength - string.len(reactor.stats[infoName] .. i.unit))
  gpu.set(i.x, i.y , i.title .. reactor.stats[infoName] .. i.unit .. spaces)
end
 
function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end
 
function getInfoFromReactor()
  reactor.stats["tick"] = math.ceil(reactor.getEnergyProducedLastTick())
  reactor.stats["stored"] = reactor.getEnergyStored()
  reactor.stats["rods"] = math.ceil(reactor.getControlRodLevel(0))
  reactor.stats["fuel"] = round(reactor.getFuelConsumedLastTick(), 2);
  currentRf = reactor.stats["stored"]
end
 
function augmentMinLimit()
  modifyRods("min", 10)
end
 
function lowerMinLimit()
  modifyRods("min", -10)
end
 
function augmentMaxLimit()
  modifyRods("max", 10)
end
 
function lowerMaxLimit()
  modifyRods("max", -10)
end
 
function powerOn()
  reactor.setActive(true)
end
 
function powerOff()
  reactor.setActive(false)
end
 
function modifyRods(limit, number)
  local tempLevel = 0
  if limit == "min" then
    tempLevel = minPowerRod + number
    if tempLevel <= 0 then
      minPowerRod = 0
    end
    if tempLevel >= maxPowerRod then
      minPowerRod = maxPowerRod -10
    end
    if tempLevel < maxPowerRod and tempLevel > 0 then
      minPowerRod = tempLevel
    end
  else
    tempLevel = maxPowerRod + number
    if tempLevel <= minPowerRod then
      maxPowerRod = minPowerRod +10
    end
    if tempLevel >= 100 then
      maxPowerRod = 100
    end
    if tempLevel > minPowerRod and tempLevel < 100 then
      maxPowerRod = tempLevel
    end
  end
  setInfoToFile()
  adjustRodsLevel()
end
 
--расчитать и отрегулировать положение стержней
function adjustRodsLevel()
  local rfTotalMax = 10000000
  currentRf = reactor.stats["stored"]
  differenceMinMax = maxPowerRod - minPowerRod
  local maxPower = (rfTotalMax/100) * maxPowerRod
  local minPower = (rfTotalMax/100) * minPowerRod
  if currentRf >= maxPower then
    currentRf = maxPower
  end
  if currentRf <= minPower then
    currentRf = minPower
  end
  currentRf = currentRf - (rfTotalMax/100) * minPowerRod
  local rfInBetween = (rfTotalMax/100) * differenceMinMax
  local rodLevel = math.ceil((currentRf/rfInBetween)*100)
  reactor.setAllControlRodLevels(rodLevel)
end
 
function draw()
  if maxRF < reactor.stats["tick"] then
    maxRF = reactor.stats["tick"]
  end
  if currentRfTick ~= reactor.stats["tick"] then
    currentRfTick = reactor.stats["tick"]
    local max = math.ceil(graphs["tick"].width * (currentRfTick/maxRF))
    local currentRFTickObj = {x = graphs["tick"].x, y = graphs["tick"].y, width = max, height = graphs["tick"].height}
    printInfos("tick")
    printGraphs("tick")
    printActiveGraphs(currentRFTickObj)
  end
  if currentRF ~= reactor.stats["stored"] then
    currentRF = reactor.stats["stored"]
    local max = math.ceil(graphs["stored"].width * (currentRF/10000000))
    local currentRFObj = {x = graphs["stored"].x, y = graphs["stored"].y, width = max, height = graphs["stored"].height}
    printInfos("stored")
    printGraphs("stored")
    printActiveGraphs(currentRFObj)
  end
  if currentRodLevel ~= reactor.stats["rods"] then
    currentRodLevel = reactor.stats["rods"]
    local max = math.ceil(graphs["rods"].width * (currentRodLevel/100))
    local currentRodObj = {x = graphs["rods"].x, y = graphs["rods"].y, width = max, height = graphs["rods"].height}
    printInfos("rods")
    printGraphs("rods")
    printActiveGraphs(currentRodObj)
  end
  if currenFuel ~= reactor.stats["fuel"] then
    currenFuel = reactor.stats["fuel"]
    printInfos("fuel")
  end
  printControlInfos()
end
 
function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return false else return true end
end
 
function getInfoFromFile()
  if file_exists("reactor.txt") then
    file = io.open("reactor.txt","w")
    file:write("0")
    file:write("\n")
    file:write("100")
    file:close()
  else
    file = io.open("reactor.txt","r")
    minPowerRod = tonumber(file:read("*l"))
    maxPowerRod = tonumber(file:read("*l"))
    file:close()
  end
end
 
function setInfoToFile()
  file = io.open("reactor.txt","w")
  file:write(minPowerRod .. "\n" .. maxPowerRod)
  file:flush()
  file:close()
end
 
function startup()
  getInfoFromFile()
  getInfoFromReactor()
  setSections()
  setGraphs()
  setInfos()
  setButtons()
  for name, data in pairs(sections) do
    printBorders(name)
  end
  for name, data in pairs(graphs) do
    printGraphs(name)
  end
  for name, data in pairs(infos) do
    printInfos(name)
  end
  printStaticControlText()
end
 
startup()
screen()
event.listen("touch", checkxy)
 
while event.pull(0.1, "interrupted") == nil do
  getInfoFromReactor()
  adjustRodsLevel()
  draw()
  local event, address, arg1, arg2, arg3 = event.pull(1)
  if type(address) == "string" and component.isPrimary(address) then
    if event == "key_down" and arg2 == keyboard.keys.q then
      os.exit()
    end
  end
end