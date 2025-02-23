local args = {...}

-- loads termLibrary, for use in displaying trades
os.loadAPI("termlibrary.lua")  -- Load the termlibrary API
local tlib = termlibrary   -- Assign the loaded API to tlib
local scroll = 0 -- used by tlib

-- returns table of trades in nicer format
local function tradeScan(interface)
    local success, trades = peripheral.call(interface, "getTrades")
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
                description = description .. "-"
            end
        end
        return description
    end
    
    if success==true then 
        for index, trade in pairs(trades) do
            table.insert(output, {button = index, text = tradeunpack(trade)})
        end
    end

    return output
end

-- attempts trade, returns boolean for success
local function trytrade(tradeindex, interface, storage)
    local success, error = peripheral.call(interface, "trade", storage, storage, tradeindex)

    if success == true then
       return true
    else
        return false
    end
end

local function tradeFeedback(success, line)
    term.setCursorPos(1, line.y)

    -- if true then positive feedback if false then negative
    if success == true then
        term.setTextColor(colors.green)
    elseif success == false then
        term.setTextColor(colors.red)
    end

    -- rewrite line in new colour
    term.clearLine()
    term.write(line.text)
    os.sleep(0.05)
    -- then set line back to normal
    term.clearLine()
    term.write(line.text)
    
end

-- presents trades and handles user input
local function tradeScreen(trades, interface, storage)
local tradesScanned = true
while tradesScanned == true do
    local buttonIndex = {} -- used by tlib
    local w, h = term.getSize()
    term.clear()

    -- termLibrary title and headings
    table.insert(buttonIndex, tlib.Title({text = "Trade Computer Main", button = "title"}, 1))
    table.insert(buttonIndex, tlib.Heading({text = "<< click to cycle trades >>", button = "cycle"}, 2))
    table.insert(buttonIndex, tlib.Heading({text = "<< click to cycle restock >>", button = "restock"}, 3))

    -- termLibrary list
    for _, button in pairs(tlib.ScrollableList(trades, 3, h, scroll, 3)) do
        table.insert(buttonIndex, button)
    end

    -- user input handling begins
    local _, _, _, y = os.pullEvent("mouse_click")

    for _, line in pairs(buttonIndex) do
        if line.y == y then
            if line.button == "scroll" then
                scroll = tlib.DoScroll(scroll, line.scrollincrement)

            elseif line.button == "cycle" then
                peripheral.call(interface, "cycleTrades")
                tradesScanned = false

            elseif line.button == "restock" then
                peripheral.call(interface, "restock")

            elseif type(line.button) == "number" then
                tradeFeedback( trytrade(line.button, interface, storage), line )
            end
        end
    end
end
end

local function main()
    local interface = args[1].interface
    local storage = args[1].storage

    while true do
        local trades = tradeScan(interface)
        tradeScreen(trades, interface, storage)
    end
end
main()
