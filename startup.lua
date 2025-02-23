--[[ things to add
- auto trading
- cycle trades until wanted trade
- ui changes when trade available
- restock trades at will
]]--

local function main()
    term.clear()
    local trades = {}
    local peripherals = peripheral.getNames()

    local tradeinterfaces = {}
    local storage = ""

    for _, peripheral_ in pairs(peripherals) do
        if peripheral.hasType(peripheral_, "trading_interface") then
            print(peripheral_)
            table.insert(tradeinterfaces, peripheral_)

        elseif peripheral.hasType(peripheral_, "minecraft:chest") then
            print(peripheral_)
            storage = peripheral_
        end
    end

    for _, interface in pairs(tradeinterfaces) do
        local id = multishell.launch({}, "/tradeinterface.lua", {interface = interface, storage = storage})
        multishell.setTitle(id, interface)
    end

end
main()
