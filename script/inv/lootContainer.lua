-- LootContainer.lua
local SlotTable = require('script.inv.slotTable') -- Required for creating a slotTable object
local Items = require("script.inv.items")
local client = require("script.client")
local LootContainer = {}
LootContainer.__index = LootContainer
local LootContainers = {}
local SingleContainers ={}
local spritesheet=love.graphics.newImage("img/characters/chests.png")
local quads = {}
local size = 20
for x = 0, (spritesheet:getWidth()/size)-1 do
    local quad = love.graphics.newQuad(x * size , 0, size, size, spritesheet:getWidth(), spritesheet:getHeight())
    table.insert(quads, quad) -- Dodanie quada do tablicy
end
function TableConcat(t1,t2)
    local copyTab = {}
    for key, value in pairs(t1) do
        copyTab[key] = t1[key]
    end
    for i=1,#t2 do
        copyTab[#copyTab+1] = t2[i]
    end
    return copyTab
end
local chosen = 1
-- Constructor for the LootContainer
function LootContainer.new(id, x, y, quadID, slotTable, z)
    local instance = {}
    setmetatable(instance, LootContainer)
    
    -- Set the lootContainer field values
    instance.id=id
    instance.x = x
    instance.y = y
    instance.quadID = quadID
    instance.width = 80
    instance.height = 80
    instance.w = 80
    instance.h = 80
    instance.xOffset = 0
    instance.yOffset = -20
    instance.z = z or 0
    instance.slotTable = SlotTable.new(50, 200, 64, 0, 2, 4) -- Example values\f
    if slotTable then
        instance.stringTable= slotTable
        for key, value in pairs(slotTable) do
            if Items[value] then
                instance.slotTable:setItem(Items[value], key)
            end
        end
    end
    if id==-1 then
        instance.life = 10
        table.insert(SingleContainers, instance)
    else
        LootContainers[id]=instance
    end

    return instance
end
function LootContainer:resetLoot()
    LootContainers = {}
end
function LootContainer.deleteSingleContainers(dt)
    for key, value in pairs(SingleContainers) do
        value.life = value.life - dt
        if value.life<0 then
            table.remove(SingleContainers, key)
        end
    end
end
-- Define the draw method
function LootContainer:draw(x, y)
    x = x or self.x
    y = y or self.y
    love.graphics.draw(spritesheet, quads[self.quadID], x, y+self.yOffset, 0, 4, 4)
end
function LootContainer:setData(key, slotTable)
    if key then
        if key>-1 and LootContainers[key].toString then
            LootContainers[key].slotTable.items = slotTable.items
        end
    end
end
function LootContainer:getContainerbyPlayer(Player)
    for key, value in pairs(TableConcat(LootContainers, SingleContainers)) do
        if Player:checkBulletCollision({
            x=value.x, y=value.y+value.yOffset, w=value.w, h=value.h
        }) then
            return value
        end
    end
end
function LootContainer.sendData(key)
    if key then
        if key>-1 and LootContainers[key].toString then
            client:send(LootContainers[key]:toString())
        end
    end

end
function LootContainer:toString()
    local str = "LOOT|"..self.id.."|"..self.x.."|"..self.y.."|"..self.z.."|"..self.quadID
    for key, value in pairs(self.slotTable.items) do
        if value.stats then
            str = str .. "|"..value.stats.name
        else
            str = str .. "|nil"
        end
    end
    return str
end
function LootContainer:getContainers()
    return TableConcat(LootContainers, SingleContainers)
end
-- fromString method for deserializing a string into LootContainer
-- Input format: "LOOT|{x}|{y}|{quadID}|{item1}|{item2}|...|{itemn}"
function LootContainer.fromString(str)
    local values = {}
    for value in string.gmatch(str, "[^|]+") do
        table.insert(values, value)
    end
    -- Remove the first item "LOOT"
    table.remove(values, 1)
    local id =  tonumber(values[1])
    table.remove(values, 1)
    local x = tonumber(values[1])
    local y = tonumber(values[2])
    local z = tonumber(values[3])
    local quadID = tonumber(values[4]) -- convert to int as quadID is an int

    -- Remove these from the values table so that only items remain
    table.remove(values, 1)
    table.remove(values, 1)
    table.remove(values, 1)
    table.remove(values, 1)
    LootContainer.new(id, x, y, quadID, values, z)
end

-- Return the LootContainer class
return LootContainer
