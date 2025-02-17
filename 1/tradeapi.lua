--debugging using fs.write
local debug = fs.open("debug", "w")

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function refactTradeStruct(t, num)
    local function subtable(t)
        for i, v in pairs(t) do
            if not (type(i)=="table") then debug.write(i.."\n") else subtable(i) end
            if not (type(v)=="table") then debug.write(v.."\n") else subtable(v) end
        end
    end
    subtable(t)
end

function addTrades(t)
end
-- iterate over peripherals to find trade interfaces
local perilist = peripheral.getNames()
--[[ 
{ 
    {
    address, trades { 
    {result, count, {enchants}, 
    costA, count, {enchants}, 
    costB, count, {enchants}},

    {result, count, {enchants}, 
    costA, count, {enchants}, 
    costB, count, {enchants}}}
    }

    {
    wrap, trades { 
    {result, count, {enchants}, 
    costA, count, {enchants}, 
    costB, count, {enchants}},

    {result, count, {enchants}, 
    costA, count, {enchants}, 
    costB, count, {enchants}}}
    }
}
]]--
local tradeTable = {peripheral.wrap("right"), { {"iron_leggings", 1, {}, "emeralds", 7, {}, "air", 0, {}}, {"iron_boots", 1, {}, "emeralds", 4, {}, "air", 0} } }
print(tradeTable[1])

for i = 1, #perilist do
    debug.write("type "..peripheral.getType(perilist[i]).." address "..perilist[i].."\n")

    if peripheral.getType(perilist[i]) then
        local interface = peripheral.wrap(perilist[i])
        table.insert(tradeTable, peripheral.wrap(perilist[i]))
        local success, trades = peripheral.getTrades(interface)

        if success==true then 
            debug.write("\n--Trades--\n")
            refactTradeStruct(trades)
            debug.write(dump(trades))
            print(trades[1]["costA"][1])
            interface.cycleTrades()
        end
        
        table.insert(tradeTable, peripheral.wrap(perilist[i]))
    end
end
-- pack trade info into data structure
-- display data structures
debug.close()
