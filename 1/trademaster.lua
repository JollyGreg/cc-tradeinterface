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

-- itemname enchant count - costAname enchant count - costBname enchant count
local function tradeScan(peripheralname)
    local interface = peripheral.wrap(peripheralname)
    local success, trades = interface.getTrades()
    local output = {}

    local function tradeunpack(trade)
        local description = ""
        for resultOrCost, item in pairs(trade) do

            for itemname, details in pairs(item) do
                description = description .. itemname .. " "

                for enchantsOrCount, value in pairs(details) do

                    if type(value) == "table" then
                        for enchant, level in pairs(value) do
                            description = description .. enchant .. " " .. level .. " "
                        end
                         -- means that the count isn't added to the description
                    else
                        description = description .. value .. " "
                    end    
                end         
                description = description .. ","
            end
        end
        return description
    end
    
    if success==true then 
        for index, trade in pairs(trades) do
            table.insert(output, {index = index, description = tradeunpack(trade), interface = peripheralname})
        end
    end

    return output
end

local function trytrade(tradeindex)
    local interface = peripheral.wrap("right")
    local storage = peripheral.wrap("bottom")

    if interface.trade("bottom", "bottom", tradeindex.index) == true then
       return true
    end
    return false
end

local function tradescreen(trades)
    local w, h = term.getSize()
    local scrollindex = 0

    local function unpackcomma(descr)
        local output = ""
        local index = 0
        for str in string.gmatch(descr, "([^,]+)") do
            if index == 1 then
                output = str.."-"..output
            else
               output = output.."## "..str.."-" 
            end
            index = index + 1
        end
        return output
    end

    local function unpackspace(descr)
        local output = {}
        for str in string.gmatch(descr, "([^-]+)") do
            table.insert(output, str)
        end
        return output
    end


    -- initial presentation of ores found
    local function presentTrades(scrollindex)
        local offset = scrollindex
        local tradeindex = {}
        term.clear() 

        -- writes title
        term.setCursorPos(1, 1) 
        term.write("Trade Computer Main")
        
        -- adds one line of space between titles/heading and the list for readability
        local _, oldy = term.getCursorPos()
        term.setCursorPos(1, oldy+1)

        -- writes arrow if necessary
        if (offset > 0) then 
            local _, oldy = term.getCursorPos()
            term.setCursorPos(w/2, oldy+1) 
            term.write("/\\") 
        end
        
        for i, trade in pairs(trades) do
            if offset > 0 then
                offset = offset - 1
            else
                _, oldy = term.getCursorPos()
                if (oldy == h-1) then -- if cursor is at bottom of screen
                    term.setCursorPos(w/2, oldy+1) term.write("\\/")
                else
                    local desc = unpackcomma(trade.description)
                    for _, line in pairs(unpackspace(desc)) do
                        local _, oldy = term.getCursorPos()
                        term.setCursorPos(1, oldy+1) term.clearLine()
                        term.write(line)
                        table.insert(tradeindex, {termindex = oldy+1, index = trade.index})
                    end
                end
            end
        end

        return tradeindex
    end
    local tradeindex = presentTrades(scrollindex)
    
    -- user input begins
    while true do
        local _, _, _, y = os.pullEvent("mouse_click")
        
        -- scroll down
        if y == h then
            scrollindex = scrollindex + 3
            presentTrades(scrollindex)
        -- scroll up
        elseif y == 4 then
            scrollindex = scrollindex - 3
            presentTrades(scrollindex)

        -- check if trade requested
        elseif y < h and y > 4 then
            for _, line in pairs(tradeindex) do
                if line.termindex == y then
                    trytrade(line)
                end
            end
        end
    end
end

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
debug.close()
