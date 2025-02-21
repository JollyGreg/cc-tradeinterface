--debugging using fs.write
local function main()
    local trades = {}
    local peripherals = peripheral.getNames()
    for _, peripheral_ in pairs(peripherals) do
        if peripheral.hasType(peripheral_, "trading_interface") then
            print(peripheral_)
            
            local id = multishell.launch({}, "/tradeinterface.lua", peripheral_)
            multishell.setTitle(id, peripheral_)
        end
    end
end
main()
