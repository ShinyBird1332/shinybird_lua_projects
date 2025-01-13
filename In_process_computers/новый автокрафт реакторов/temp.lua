local term = require("term")
local component = require("component")
local computer = require("computer")
local math = require("math")
local event = require("event")
local string = require("string")
local unicode = require("unicode")
local os = require("os") 
local fs = require('filesystem')
 
local gpu = component.gpu
gpu.setResolution(100,50)
br = component.getPrimary("br_reactor")
 
local boucle2 = 0
local a = 80
local b = 1
local lvl
local val = 0
local rod = 1
local nbrrod = br.getNumberOfControlRods()
 
local function setColor(bg,fg)
  gpu.setBackground(bg)
  gpu.setForeground(fg)
end
 
local function loadbar(x,y,width,cur,text,bg,fg)
  local raw = " " .. text ..string.rep(" ", width - unicode.len(text) - 2) .. " "
  local oldbg = gpu.setBackground(bg)
  local oldfg = gpu.setForeground(fg)
  gpu.set(x,y,unicode.sub(raw,1,cur))
  gpu.setBackground(oldbg)
  gpu.setForeground(oldfg)
  gpu.set(x+cur,y,unicode.sub(raw,cur+1,width))
end 
 
local function hexa(dec)
local B,K,OUT,I,D = 16,"0123456789ABCDEF","",0
  if dec <= 0 then
    OUT = "00"
  elseif dec > 0 and dec < 16 then
    D = dec + 1
    OUT = "0"..string.sub(K,D,D)
  elseif dec > 16 and dec < 256 then
    V1 = math.modf(dec/B)+1
    V2 = dec-V1*16
    OUT = string.sub(K,V1,V1)..string.sub(K,V2,V2)
  elseif dec >= 255 then
    OUT = "FF"
  end
  return OUT
end
 
local function round(num, dec)
  local mult = 10 ^ (dec or 0)
  return math.floor(num * mult + 0.5) / mult
end
 
local function affrod(x,y,l)
  local rodv = rod + l -1
  if rodv < 0 or rodv > nbrrod -1 then
    gpu.set(x,y,"                                         ")
  else
    local lvl = br.getControlRodLevel(rodv)
    gpu.set(x,y,"СТЕРЖЕНЬ:"..string.format("% 2s",rodv + 1).."  / ГЛУБИНА ПОГРУЖЕНИЯ : "..string.format("% 3s",lvl).."%")
  end
end
 
local function control(x,y)
  local lvl = br.getControlRodLevel(rod-1)
  local rouge = math.floor((100-lvl)*255/50)
  local vert = math.floor(lvl*255/50)
  local color = hexa(rouge)..hexa(vert).."00"
  local color2 = tonumber(string.format("%6s",color),16)
  setColor(color2,0x0000FF)
  gpu.set(22,48,string.format("% 3s",rod))
  setColor(0x0, 0xFFFFFF)
  affrod(x,y-6,-3)
  affrod(x,y-4,-2)
  affrod(x,y-2,-1)
  setColor(0x00FF00,0x0000FF)
  affrod(x,y,0)
  setColor(0x000000,0xFFFFFF)
  affrod(x,y+2,1)
  affrod(x,y+4,2)
  affrod(x,y+6,3)
end
 
local function manualrod(x,y,rod)
  local lvl
    gpu.set(a,b,"╦═══════════════════╗")
  gpu.set(a,b+1,"║ ГЛУБИНА СТЕРЖНЕЯ  ║")
  gpu.set(a,b+2,"╠═══════════════════╣") 
  gpu.set(a,b+3,"║ НОМЕР      █100█  ║")
  gpu.set(a,b+4,"║                   ║")
  gpu.set(a,b+5,"║    █-10█   █+10█  ║")
  gpu.set(a,b+6,"║                   ║")
  gpu.set(a,b+7,"║    █-1 █   █+1 █  ║")
  gpu.set(a,b+8,"║                   ║")
  gpu.set(a,b+9,"║   ██████  ███████ ║")
 gpu.set(a,b+10,"║   ОТМЕНА  ПРИНЯТЬ ║")
 gpu.set(a,b+11,"║   ██████  ███████ ║")
 gpu.set(a,b+12,"╚═══════════════════╣")
  lvl = br.getControlRodLevel(rod-1)
  gpu.set(a+12,b+3,string.format("% 3s",lvl))
  gpu.set(a+8,b+3,string.format("% 2s",rod))
  boucle2 = 1
end
 
local function manualallrod()
    gpu.set(a,b,"╦═══════════════════╗")
  gpu.set(a,b+1,"║ ГЛУБИНА СТЕРЖНЕЙ  ║")
  gpu.set(a,b+2,"╠═══════════════════╣") 
  gpu.set(a,b+3,"║ВСЕ СТЕРЖНИ █100█  ║")
  gpu.set(a,b+4,"║                   ║")
  gpu.set(a,b+5,"║    █-10█   █+10█  ║")
  gpu.set(a,b+6,"║                   ║")
  gpu.set(a,b+7,"║    █-1 █   █+1 █  ║")
  gpu.set(a,b+8,"║                   ║")
  gpu.set(a,b+9,"║   ██████ ███████  ║")
 gpu.set(a,b+10,"║   ОТМЕНА ПРИНЯТЬ  ║")
 gpu.set(a,b+11,"║   ██████ ███████  ║")
 gpu.set(a,b+12,"╚═══════════════════╣")
  gpu.set(a+12,b+3,string.format("% 3s",val))
  boucle2 = 2
end
 
local function manualoff()
  boucle2 = 0
    gpu.set(a,b,"════════════════════╗")
  gpu.set(a,b+1,"                    ║")
  gpu.set(a,b+2,"                    ║") 
  gpu.set(a,b+3,"                    ║")
  gpu.set(a,b+4,"                    ║")
  gpu.set(a,b+5,"                    ║")
  gpu.set(a,b+6,"                    ║")
  gpu.set(a,b+7,"                    ║")
  gpu.set(a,b+8,"                    ║")
  gpu.set(a,b+9,"                    ║")
 gpu.set(a,b+10,"                    ║")
 gpu.set(a,b+11,"                    ║")
 gpu.set(a,b+12,"                    ║")
end
 
local function bargraph(x,y,length,am,cap,na,col,colpol)
  local amount = am
  local capacity = cap
  local pct = amount / capacity
  local cur = math.floor(pct * length)
  local color = col
  local color2 = colpol
  local name = na
  local textfrac = string.format("%s / %s", amount, capacity)
  local textpct = string.format("%.02f%%", pct*100)
  local text = textfrac .. string.rep(" ", length - string.len(textfrac) - string.len(textpct) - 6) .. "   " .. textpct .. " "
  local text1 = "              Уровень заполнения : ("..name..")"
  loadbar(x,y,length,cur,text1,color,color2)
  loadbar(x,y+1,length,cur,text,color,color2)
end
 
function drawbars()
  amFuel = br.getFuelAmount()
  capFuel = br.getFuelAmountMax()
  naFuel = "ТОПЛИВО - Yellorium"
  colFuel = 0xFFFF00
  colpolFuel = 0x0000FF
  bargraph(2,22,98,amFuel,capFuel,naFuel,colFuel,colpolFuel)
  amWaste = br.getWasteAmount()
  capWaste = 64000
  naWaste = "ОТХОДЫ - Cyanite"
  colWaste = 0x00FFFF
  colpolWaste = 0xFF00FF
  bargraph(2,25,98,amWaste,capWaste,naWaste,colWaste,colpolWaste)
  amSteam = br.getHotFluidAmount()
  capSteam = br.getHotFluidAmountMax()
  naSteam = "ПАР"
  colSteam = 0x8F8F8F
  colpolSteam = 0xFFFF00
  bargraph(2,28,98,amSteam,capSteam,naSteam,colSteam,colpolSteam)
  amWater = br.getCoolantAmount()
  capWater = br.getCoolantAmountMax()
  naWater = "ВОДА"
  colWater = 0x71b6cb
  colpolWater = 0x0000FF
  bargraph(2,31,98,amWater,capWater,naWater,colWater,colpolWater)
  consot = br.getFuelConsumedLastTick()
  consos = consot * 20
  consoh = consos * 3.6
  consoj = consoh * 24  
  gpu.set(2,35,string.format("% 1.03f",consot).."mb/t =>"..string.format("% 1.02f",consos).."mb/s =>"..string.format("% 3.02f",consoh).."b/h =>"..string.format("% 5.02f",consoj).."b/d")
  Tcore = br.getCasingTemperature()
  Tfuel = br.getFuelTemperature()
  Reactivity = br.getFuelReactivity()
  Prod = br.getHotFluidProducedLastTick()
  gpu.set(35,38,string.format("% 4.2f",Tcore))
  gpu.set(35,40,string.format("% 4.2f",Tfuel))
  gpu.set(35,42,string.format("% 4.2f",Reactivity))
  gpu.set(35,44,string.format("% 4.2f",Prod))
end
 
local function waste()
local waste = br.getWasteAmount()
  if waste > 48000 then
    br.doEjectWaste()
  end
end
 
local function marche(x,y)
  gpu.set(x,y,"              ")
gpu.set(x,y+1,"   ВКЛЮЧИТЬ   ")
gpu.set(x,y+2,"              ")
end
 
local function arret(x,y)
  gpu.set(x,y,"              ")
gpu.set(x,y+1,"   ВЫКЛЮЧИТЬ  ")
gpu.set(x,y+2,"              ")
end
 
local function start()
local ON = br.getActive()
  if ON == true then
    setColor(0x00FF00,0x0)
    marche(60,11)
    setColor(0x0,0xFF0000)
    arret(60,15)
    setColor(0x0,0xFFFFFF)
  elseif ON == false then
    setColor(0x0,0x00FF00)
    marche(60,11)
    setColor(0xFF0000,0xFFFFFF)
    arret(60,15)
    setColor(0x0,0xFFFFFF)
  end
end
 
function allrods(val)
  for i=0, nbrrod-1 do
    level = br.getControlRodLevel(i)
    newlevel = val + level
    if newlevel > 100 then
      newlevel = 100
    elseif newlevel < 0 then
      newlevel = 0
    else
      newlevel = level + val
    end
    br.setControlRodLevel(i,newlevel)
  end
end
 
term.clear()
 gpu.set(1,1,"╔══════════════════════════════════════════════════════════════════════════════════════════════════╗")
 gpu.set(1,2,"║                                                                                                  ║")
 gpu.set(1,3,"║   ███████████████████████████████████████████████       ███████████████████                      ║")
 gpu.set(1,4,"║   ██                                           ██       █ Ручной контроль █                      ║")
 gpu.set(1,5,"║   ██                                           ██       █       всех      █                      ║")
 gpu.set(1,6,"║   ██                                           ██       █     стержней    █                      ║")
 gpu.set(1,7,"║   ██                                           ██       █                 █                      ║")
 gpu.set(1,8,"║   ██                                           ██       ███████████████████                      ║")
 gpu.set(1,9,"║   ██                                           ██                                                ║")
gpu.set(1,10,"║   ██                                           ██                                                ║")
gpu.set(1,11,"║   ██                                           ██        █████████████                           ║")
gpu.set(1,12,"║   ██                                           ██        █ВКЛЮЧИТЬ  ██                           ║")
gpu.set(1,13,"║   ██                                           ██        █████████████                           ║")
gpu.set(1,14,"║   ██                                           ██                                                ║")
gpu.set(1,15,"║   ██                                           ██        █████████████                           ║")
gpu.set(1,16,"║   ██                                           ██        █ВЫКЛЮЧИТЬ ██                           ║")
gpu.set(1,17,"║   ███████████████████████████████████████████████        █████████████                           ║")
gpu.set(1,18,"║                                                                                                  ║")
gpu.set(1,19,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,20,"║                                                                                                  ║")
gpu.set(1,21,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,22,"║                                                                                                  ║")
gpu.set(1,23,"║                                                                                                  ║")
gpu.set(1,24,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,25,"║                                                                                                  ║")
gpu.set(1,26,"║                                                                                                  ║")
gpu.set(1,27,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,28,"║                                                                                                  ║")
gpu.set(1,29,"║                                                                                                  ║")
gpu.set(1,30,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,31,"║                                                                                                  ║")
gpu.set(1,32,"║                                                                                                  ║")
gpu.set(1,33,"╠════════════════════════════════════════════════╦═════════════════════════════════════════════════╣")
gpu.set(1,34,"║ РАСХОД ТОПЛИВА                                 ║  MiliBukket/second => mb/s   Bukket/Hour => b/h ║")
gpu.set(1,35,"║                                                ║  MiliBukket/tick   => mb/t   Bukket/Day  => b/d ║")
gpu.set(1,36,"╠════════════════════════════════════════════════╩══════════════════════╦══════════════════════════╣")
gpu.set(1,37,"║                                                                       ║                          ║")
gpu.set(1,38,"║    ТЕМПЕРАТУРА РЕАКТОРА       :           °C                          ║                          ║")
gpu.set(1,39,"║                                                                       ║    ██████████████████    ║")
gpu.set(1,40,"║    ТЕМПЕРАТУРА ТОПЛИВА        :           °C                          ║    ██   ИЗВЛЕЧЬ    ██    ║")
gpu.set(1,41,"║                                                                       ║    ██   CYANITE    ██    ║")
gpu.set(1,42,"║    РАДИОАКТИВНОСТЬ ТОПЛИВА    :           %                           ║    ██████████████████    ║")
gpu.set(1,43,"║                                                                       ║                          ║")
gpu.set(1,44,"║    ПЕРЕРАБОТКА ПАРА           :           mb/t                        ║    ██████████████████    ║")
gpu.set(1,45,"╠═══════════════════════════════════════════════════════════════════════╣    ██   ИЗВЛЕЧЬ    ██    ║")
gpu.set(1,46,"║   ВЫБОР СТЕРЖНЯ                                                       ║    ██  YELLORIUM   ██    ║")
gpu.set(1,47,"║                                               ██████████████████      ║    ██████████████████    ║")
gpu.set(1,48,"║   █ -10 █  █ -1 █  rod  █ +1 █  █ +10 █       ██ ИЗМЕНИТЬ ROD ██      ║                          ║")
gpu.set(1,49,"║                                               ██████████████████      ║                          ║")
gpu.set(1,50,"╚═══════════════════════════════════════════════════════════════════════╩══════════════════════════╝")
 
start()
 
local function onTouch(event,adress,x,y,clic,pseudo)
  local tclic
  if clic == 0  then
    tclic = "НАЖИТО ЛКМ"
  elseif clic == 1 then
    tclic = "НАЖИТО ПКМ"
  else
    tclic = "НАЖИТО НЕИЗВЕСТНО"
  end
  gpu.set(6,20,"                "..tclic.." . ИГРОКОМ: "..pseudo.." ( X : "..string.format("% 3s",x).." Y: "..string.format("% 3s",y)..")")
  
  if x==1 and y==1 then
      computer.pushSignal("quit")
      term.setCursor(1,1)
      return false
      
  elseif boucle2 == 0 then
    if x > 48 and x < 67 and y > 46 and y < 50 then
      manualrod(x,y,rod)
      lvl = br.getControlRodLevel(rod-1)
    elseif x > 58 and x < 78 and y > 2 and y < 9 then
      manualallrod()
    elseif x > 77 and x < 96 and y > 38 and y < 43 then
      br.doEjectWaste()
    elseif x > 77 and x < 96 and y > 43 and y < 48 then
      br.doEjectFuel() 
    elseif x > 4 and x < 12 and y == 48 then
      if rod < 9 then
        rod = 0
      else
        rod = rod - 10
      end
    elseif x > 13 and x < 20 and y == 48 then
      if rod < 1 then
        rod = 0
      else
        rod = rod - 1
      end    
    elseif x > 27 and x < 34 and y == 48 then
      if rod > nbrrod - 1 then
        rod = nbrrod
      else
        rod = rod + 1
      end    
    elseif x > 35 and x < 42 and y == 48 then
      if rod > nbrrod - 10 then
        rod = nbrrod
      else
        rod = rod + 10
      end  
  
    elseif x > 58 and x < 73 and y > 10 and y < 14 then
      br.setActive(true)
      start()
    elseif x > 58 and x < 73 and y > 14 and y < 18 then
      br.setActive(false)
      start()
    end
 
  elseif boucle2 == 1 then
    if x > a+5 and x < a+18 and y > b+4 and y < b+8 then
      if x > a+11 and x < a+14 and y == b+5 then
        if lvl < 91 then
          lvl = lvl + 10
        else
          lvl = 100
        end
      elseif x > a+14 and x < a+18 and y == b+7 then
        if lvl < 100 then
          lvl = lvl + 1
        else
          lvl = 100
        end
      elseif x > a+5 and x < a+9 and y == b+5 then
        if lvl > 10 then
          lvl = lvl - 10
        else 
          lvl = 0
        end
      elseif x > a+5 and x < a+9 and y == b+7 then
        if lvl > 1 then
          lvl = lvl - 1
        else 
          lvl = 0
        end
      end
      gpu.set(a+14,b+3,string.format("%3s",lvl))
    elseif x > a+3 and x < a+11 and y > b+8 and y < b+12 then
      manualoff()
    elseif x > a+11 and x < a+19 and y > b+8 and y < b+12 then
      br.setControlRodLevel(rod-1,lvl)
      manualoff()
    end
  elseif boucle2 == 2 then
    if x > a+5 and x < a+17 and y > b+4 and y < b+8 then
      if x > a+13 and x < a+18 and y == b+5 then
        if val < 91 then
          val = val + 10
        else
          val = 100
        end
      elseif x > a+13 and x < a+18 and y == b+7 then
        if val < 100 then
          val = val + 1
        else
          val = 100
        end
      elseif x > a+5 and x < a+9 and y == b+5 then
        if val > -91 then
          val = val - 10
        else 
          val = -100
        end
      elseif x > a+5 and x < a+9 and y == b+7 then
        if val > -100 then
          val = val - 1
        else 
          val = -100
        end
      end
      gpu.set(a+14,b+3,string.format("%3s",val))
    elseif x > a+3 and x < a+11 and y > b+8 and y < b+12 then
      manualoff()
      val = 0
    elseif x > a+11 and x < a+19 and y > b+8 and y < b+12 then
      allrods(val)
      manualoff()
      val = 0
    end
  end
end
 
local function onTimer(_,timer)
  waste()
  control(8,10)
  drawbars()
  return true
end
 
event.listen("touch",onTouch)
local timer = event.timer(0,onTimer,math.huge)
event.pull("quit")
event.cancel(timer)
event.ignore("touch",onTouch)
component.gpu.setResolution(160,50)
term.clear()
