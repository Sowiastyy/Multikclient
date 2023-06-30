-- LootContainer.lua
local SlotTable = require('script.inv.slotTable') -- Required for creating a slotTable object
local Items = require("script.inv.items")
local client = require("script.client")
local LootContainer = {}
LootContainer.__index = LootContainer
local LootContainers = {}
local spritesheet=love.graphics.newImage("img/characters/chests.png")
local quads = {}
local size = 20
for x = 0, (spritesheet:getWidth()/size)-1 do
    local quad = love.graphics.newQuad(x * size , 0, size, size, spritesheet:getWidth(), spritesheet:getHeight())
    table.insert(quads, quad) -- Dodanie quada do tablicy
end
local got = false
-- Constructor for the LootContainer
function LootContainer.new(id, x, y, quadID, slotTable)
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
    instance.yOffset = 0

    instance.slotTable = SlotTable.new(50, 200, 64, 0, 2, 4) -- Example values\f
    if slotTable then
        instance.stringTable= slotTable
        for key, value in pairs(slotTable) do
            if Items[value] then
                instance.slotTable:setItem(Items[value], key)
            end
        end
    end
    LootContainers[id]=instance
    return instance
end

-- Define the draw method
function LootContainer:draw()
    love.graphics.rectangle('line', self.x+self.xOffset, self.y+self.yOffset, self.width, self.height)
    love.graphics.draw(spritesheet, quads[self.quadID], self.x, self.y, 0, 4, 4)
end

function LootContainer:getContainerbyPlayer(Player)
    for key, value in pairs(LootContainers) do
        if Player:checkBulletCollision(value) then
            return value
        end
    end
end
function LootContainer.sendData(key)
    print(LootContainers[key]:toString())
    client:send(LootContainers[key]:toString())
end
function LootContainer:toString()
    local str = "LOOT|"..self.id.."|"..self.x.."|"..self.y.."|"..self.quadID
    for key, value in pairs(self.slotTable.items) do
        if value.stats then
            str = str .. "|"..value.stats.name
        else
            str = str .. "|nil"
        end
    end
    print(str)
    return str
end
function LootContainer:getContainers()
    return LootContainers
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
    local quadID = tonumber(values[3]) -- convert to int as quadID is an int

    -- Remove these from the values table so that only items remain
    table.remove(values, 1)
    table.remove(values, 1)
    table.remove(values, 1)
    local newLootContainer = LootContainer.new(id, x, y, quadID, values)
    if id then
        LootContainers[id]=newLootContainer
    end
    return newLootContainer
end

-- Return the LootContainer class
return LootContainer
