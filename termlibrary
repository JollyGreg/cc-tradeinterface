-- returns buttonIndex = {y = y, button = line.button }
function Title(line, y, orientation)
    orientation = orientation or nil
    term.setTextColor(colors.blue)

    -- if orientation == "centred" then end
    term.setCursorPos(1, y)
    term.write(line.text)

    local buttonIndex = {y = y, button = line.button }
    return buttonIndex
end

-- returns buttonIndex = {y = y, button = line.button }
function Heading(line, y, orientation)
    orientation = orientation or nil
    term.setTextColor(colors.cyan)

    term.setCursorPos(1, y)
    term.write(line.text)

    local buttonIndex = {y = y, button = line.button }
    return buttonIndex
end

-- returns new scroll value
function DoScroll(scrollvalue, scrollincrement)
    scrollvalue = math.max(0, scrollvalue + scrollincrement)
    return scrollvalue
end

-- to use: initialize scroll value to 0, top and bottom variables define the bounds of the list
function ScrollableList(list, top, bottom, scrollvalue, scrollincrement)
    local w, _ = term.getSize()
    term.setTextColor(colors.white) term.setCursorPos(1, top)
    local buttonIndex = {}

    -- seperates lines by "-" returns table of strings
    local function unpackLine(descr)
        local output = {}
        local seperations = 0

        for str in string.gmatch(descr, "([^-]+)") do
            if seperations > 0 then
                table.insert(output, "- "..str)
                seperations = seperations + 1
            else
                table.insert(output, str)
                seperations = seperations + 1
            end
        end

        -- if there were no "-"'s to seperate then just return false
        if seperations < 2 then
            return false, descr
        end

        return true, output
    end

    -- writes arrows if necessary returns true if arrows written, false if not
    local function checkArrow()
        local _, oldy = term.getCursorPos()

        -- if top arrow necessary
        if (scrollvalue > 0) then 
            term.setCursorPos(w/2, oldy+1) 
            term.write("/\\") 
            table.insert(buttonIndex, {y = oldy+1, button = "scroll", scrollincrement = -scrollincrement})
            
            return true

        -- if bottom arrow necessary
        elseif (oldy == bottom-1) then
            term.setCursorPos(w/2, oldy+1) 
            term.write("\\/") 
            table.insert(buttonIndex, {y = oldy+1, button = "scroll", scrollincrement = scrollincrement})

            return true
        end

        return false
    end

    local function writeList()
    end

    if checkArrow() == false then
        local _, oldy = term.getCursorPos()
        term.setCursorPos(1, oldy+1) 
    end

    for _, entry in pairs(list) do
        local _, oldy = term.getCursorPos()
        if oldy+1 == bottom then
            break
        end

        -- each increment of offset means a list item isn't written, this behaviour allows for scrolling
        if scrollvalue > 0 then
            scrollvalue = scrollvalue - 1
        else
            
            local success, lines = unpackLine(entry.text)

            -- if there are multiple lines to write then...
            if success == true then
                for index, line in pairs(lines) do
                    local _, oldy = term.getCursorPos()
                    if index > 1 then
                        term.setTextColor(colors.lightGray)
                    else
                        term.setTextColor(colors.white)
                    end

                    -- writes arrow if necessary, then breaks
                    if checkArrow() == true then
                        break
                    end

                    term.setCursorPos(1, oldy+1) 
                    term.clearLine()
                    term.write(line)
                    table.insert(buttonIndex, {y = oldy+1, button = entry.button, text = line})
                end

            else
                term.setTextColor(colors.white)
                -- writes arrow if necessary, then breaks
                if checkArrow() == true then
                    break
                end
                term.setCursorPos(1, oldy+1) 
                term.clearLine()
                term.write(entry.text)
                table.insert(buttonIndex, {y = oldy+1, button = entry.button, text = entry.text})
            end
        end
    end

    return buttonIndex
end

-- returns functions for require
return { 

title = Title, 
heading = Heading, 
doScroll = DoScroll, 
scrollableList = ScrollableList 

}
