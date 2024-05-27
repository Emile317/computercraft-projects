function table.contains(table, element, key)
    key = key or false -- default key to false if key is not given

    if key then
        for k, _ in pairs(table) do
            if element == k then
                return true
            end
        end

        return false
    elseif not key then
        for _, v in pairs(table) do
            if element == v then
                return true
            end
        end
        
        return false
    end
end

function table.length(table)
    local c = 0
    for k in pairs(table) do
        c = c + 1
    end
    return c
end

function string.replace(string, character, replacement)
    local replacedString = ""
    for i = 1, #string do
        local char = string:sub(i, i) -- set char to character in string at current index
        if char ~= character then
            replacedString = replacedString .. char
        else
            replacedString = replacedString .. replacement
        end
    end

    return replacedString
end

function string.title(string, breakpoint)
    local titledString = ""
    local uppercase = true
    for i = 1, #string do
        local char = string:sub(i, i)
        
        if uppercase then
            titledString = titledString .. char:upper()
        else
            titledString = titledString .. char:lower()
        end
        
        -- check if character on next iteration should be uppercase or not
        if char ~= breakpoint then
            uppercase = false
        else
            uppercase = true
        end
    end

    return titledString
end

local function getChestItems(chest)
    local chestSlots = chest.list()

    local itemToAmount = {}
    for _, slot in pairs(chestSlots) do
        -- if item has already been counted in another slot, add the counts of both together
        if table.contains(itemToAmount, slot.name, true) then
            itemToAmount[slot.name] = itemToAmount[slot.name] + slot.count
        -- otherwise make a new 'key, value pair' for the item
        else
            itemToAmount[slot.name] = slot.count
        end
    end

    return itemToAmount
end

local function printItemsToMonitor(items, monitor)
    local function getXPosition(monitorWidth, stringLength)
        return monitorWidth / 2 - stringLength / 2
    end

    local function getYPosition(monitorHeight, itemsAmount)
        local linesCount = itemsAmount * 2 + itemsAmount - 1
        return math.ceil(monitorHeight / 2 - linesCount / 2)
    end

    monitor.clear()

    local w, h = monitor.getSize()
    local cursorYPos = getYPosition(h, table.length(items))
    for name, count in pairs(items) do
        local cleanName = name:sub(11):replace("_", " "):title(" ")
        local cleanCount = ("%sx"):format(count)

        nameX = getXPosition(w, #cleanName)
        countX = getXPosition(w, #cleanCount)

        -- write name to monitor
        monitor.setCursorPos(nameX, cursorYPos)
        monitor.setTextColor(colors.white)
        cursorYPos = cursorYPos + 1
        monitor.write(cleanName)

        -- write count to monitor
        monitor.setCursorPos(countX, cursorYPos)
        monitor.setTextColor(colors.lightGray)
        cursorYPos = cursorYPos + 2
        monitor.write(cleanCount)
    end

    return 0
end

while true do
    local chest = peripheral.wrap("left")
    local monitor = peripheral.wrap("right")
    if (not chest) or (not monitor) then
        print("Error: Peripheral setup is not correct. Make sure there is a chest attached to the left and a monitor attached to the right of the computer.")
        return
    end

    local chestItems = getChestItems(chest)
    printItemsToMonitor(chestItems, monitor)

    sleep(5)
end
