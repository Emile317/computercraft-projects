-- mines a block infront, moves in and mines a block upwards
function MineFront()
    --[[
        check if block that's about to be mined is a diamond ore,
        if so keeps in inventory, otherwise drops mined block
    ]]
    local s, d = turtle.inspect()
    if (s) and (CheckDia(d['name'])) then
        turtle.dig()
        turtle.transferTo(16)
    else
        turtle.dig()
        turtle.drop()
    end

    turtle.forward()

    -- ,,
    s, d = turtle.inspectUp()
    if (s) and (CheckDia(d['name'])) then
        turtle.digUp()
        turtle.transferTo(16)
    else
        turtle.digUp()
        turtle.drop()
    end
end

function Do180()
    turtle.turnLeft()
    turtle.turnLeft()
end

-- checks for if block name contains 'diamond'
function CheckDia(name)
    if not not string.match(name, 'dirt') then
        return true
    end
    return false
end

-- Inspects a block. If it's a diamond ore, adds coords to table
function InspectAndAdd(inspectType)
    local s, d
    if inspectType == 'forward' then
        s, d = turtle.inspect()
    elseif inspectType == 'up' then
        s, d = turtle.inspectUp()
    elseif inspectType == 'down' then
        s, d = turtle.inspectDown()
    else
        print("Wrong inspectType input")
    end

    if (s) and (CheckDia(d['name'])) then
        table.insert(DiaLocations, { x = InputXLevel + XOffset, z = InputZLevel + ZOffset })
    end
end

function CheckLayer()
    turtle.turnLeft()
    InspectAndAdd('forward')
    Do180()
    InspectAndAdd('forward')
    turtle.turnLeft()
end

function CheckFullLayer()
    CheckLayer()
    InspectAndAdd('down')
    turtle.up()
    CheckLayer()
    InspectAndAdd('up')
    turtle.down()
end

-- makes a turn by going left or right 3 blocks then facing the opposite direction
local function turn(direction)
    if direction == 'right' then
        TurnFunc = turtle.turnRight
    else
        TurnFunc = turtle.turnLeft
    end

    TurnFunc()
    for i = 1, 3 do
        MineFront()
        UpdateOffset('x', XDirection)
        CheckFullLayer()
    end
    TurnFunc()

    ZDirection = not ZDirection -- inverts ZDirection because of the turn
    TurnsCount = TurnsCount + 1
end

local function returnToSpawn()
    -- changes direction if not facing spawn
    if ZDirection == InitialZDirection then
        Do180()
    end

    while ZOffset > 0 do
        if turtle.detect() then
            turtle.dig()
        end
        turtle.forward()
        ZOffset = ZOffset - 1
    end

    turtle.turnRight()
    while XOffset ~= 0 do
        if turtle.detect() then
            turtle.dig()
        end
        turtle.forward()
        XOffset = XOffset + 1
    end
end

-- returns distance away from starting point
local function getDistFromSpawn()
    return ZOffset + -XOffset
end

-- updates X or Z offset value
function UpdateOffset(type, direction)
    if (type == 'z') and (direction) then
        ZOffset = ZOffset + 1
    elseif type == 'z' then
        ZOffset = ZOffset - 1
    elseif (type == 'x') and (direction) then
        XOffset = XOffset + 1
    elseif type == 'x' then
        XOffset = XOffset - 1
    else
        print('wrong UpdateOffset input')
    end
end

XOffset = 0
ZOffset = 0

XDirection = false
ZDirection = true
InitialZDirection = true

TurnsCount = 0

DiaLocations = {}

InputXLevel = tonumber(arg[1])
InputZLevel = tonumber(arg[2])

while (getDistFromSpawn() < turtle.getFuelLevel()) and (turtle.getItemCount() ~= 3) do
    MineFront()
    UpdateOffset('z', ZDirection)
    CheckFullLayer()

    if ZOffset == 5 then
        turn('right')
    elseif (ZOffset == 0) and (TurnsCount > 0) then
        turn('left')
    end
end
returnToSpawn()

for i, location in pairs(DiaLocations) do
    print(string.format('%d - X: %d, Z: %d', i, location.x, location.z))
end
