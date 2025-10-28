local guiBackend = {}

local guiConstants = dofile("guiConstants.lua")

function guiBackend.switch_button()
    print(1)
    os.exit()
end

function guiBackend.hold_button()
    print(2)
    os.exit()
end

function guiBackend.btn_new_window(buttons)
    while true do
        local _, _, x, y = guiConstants.event.pull("touch")

        for _, btn in ipairs(buttons) do
            if x >= btn.x and x < btn.btn_w and y >= btn.y and y < btn.btn_h then
                buttons = {}
                btn.btn_func()
                break
            end
        end
    end
end

return guiBackend
