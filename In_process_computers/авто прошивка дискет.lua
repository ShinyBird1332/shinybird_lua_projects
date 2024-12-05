local component = require("component")
local event = require("event")
local fs = require("filesystem")
local term = require("term")
local shell = require("shell")
local sides = require("sides")
local reds = component.redstone
local diskDrive = component.disk_drive

local side_reds = sides.north

-- Путь к папке с программами
local programsPath = "/home/programs/"

-- Функция для вывода списка файлов в папке
local function listPrograms()
  local programs = {}
  for file in fs.list(programsPath) do
    if not fs.isDirectory(programsPath .. file) then
      table.insert(programs, file)
    end
  end
  return programs
end

-- Функция для копирования файла
local function copyFile(src, dest, program)
  --local success, err = fs.copy(src, dest)
  dest = string.sub(dest, 1, 3)
  local success, err = fs.copy(src, "/mnt/" .. dest .. "/" .. program)
  if not success then
    print("Ошибка при копировании файла: " .. err)
    return false
  end
  return true
end

-- Основная программа
local function main()
  while true do
    term.clear()
    print("Ожидание дискеты...")
    while diskDrive.isEmpty() do
      os.sleep(1)
    end

    local diskPath = diskDrive.media()
    if not diskPath then
      print("Ошибка: не удалось получить путь к дискете.")
      return
    end

    term.clear()
    local programs = listPrograms()
    print("Доступные программы:")
    for i, program in ipairs(programs) do
      print(i .. ". " .. program)
    end
    print(#programs + 1 .. ". Вернуть дискету без изменений")

    print("Выберите действие: ")
    local choice = tonumber(io.read())

    if choice >= 1 and choice <= #programs then
      -- Копируем выбранную программу на дискету
      local program = programs[choice]
      local success = copyFile(programsPath .. program, diskPath .. "/" .. program, program)
      if success then
        print("Программа записана на дискету!")

      else
        print("Ошибка при копировании программы на дискету.")
      end

    elseif choice == #programs + 1 then
      print("Дискета возвращена без изменений.")

    else
      print("Неверный выбор.")
    end

    os.sleep(1)
    diskDrive.eject()
    print("Дискета извлечена. Ожидание новой дискеты...")
  end
end

main()
