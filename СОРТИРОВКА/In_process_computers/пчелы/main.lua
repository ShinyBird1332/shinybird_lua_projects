local frontMain = dofile("frontMain.lua")

function main()
    --start.check_all_func() --проверка постройки системы.
    frontMain.draw_start_interfase()
end

main()

--всего 138
--условия: биом, температура, фаза луны, блок в основе, время суток