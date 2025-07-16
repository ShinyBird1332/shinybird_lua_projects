
scan_names = {1, 2, 3, 4, 5}

function check_orb()
    

    for _, orb in ipairs(scan_names) do
        if item.name == orb then
            print("наш сундук с орбами")
            table.remove(chest_scan, chest_scan_side)
            return true
        end
    end
end

local success = false
for _, chest_scan_side in ipairs(chest_scan) do
  razmer = transposer.getInventorySize(chest_scan_side)
--    for b=1, razmer do
      b=1
      item = transposer.getStackInSlot(chest_scan_side, b)
      if item ~= nil then

        if success then
            
        else
            success = check_orb()
        end

        

      else
        print("пустой сундук")  
        break
      end

  print(razmer)
end