local guiBackend = {}
local guiConstants = dofile("guiConstants.lua")

function guiBackend.btn_new_window(buttons) 
    while true do
        local _, _, x, y = guiConstants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then
                if btn.switch_button then
                    
                else
                    buttons = {}
                    btn.btn_func()
                end
                break
            end
        end
    end
end

return guiBackend
