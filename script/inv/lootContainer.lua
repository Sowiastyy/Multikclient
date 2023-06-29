-- LootContainer.lua
local SlotTable = require('script.inv.slotTable') -- Required for creating a slotTable object

local LootContainer = {}
LootContainer.__index = LootContainer

-- Constructor for the LootContainer
function LootContainer.new(x, y, quadID, slotTable)
    local lootContainerInstance = {}
    setmetatable(lootContainerInstance, LootContainer)
    
    -- Set the lootContainer field values
    lootContainerInstance.x = x
    lootContainerInstance.y = y
    lootContainerInstance.quadID = quadID
    lootContainerInstance.width = 100
    lootContainerInstance.height = 100
    lootContainerInstance.xOffset = 20
    lootContainerInstance.yOffset = 20

    
    -- If a slotTable object is not provided, create a new one
    if slotTable then
        lootContainerInstance.slotTable = slotTable
    else
        lootContainerInstance.slotTable = SlotTable.new(50, 200, 64, 0, 1, 4) -- Example values
    end
    
    return lootContainerInstance
end

-- Define the draw method
function LootContainer:draw()
    love.graphics.rectangle('line', self.x+self.xOffset, self.y+self.yOffset, self.width, self.height)
end

-- Define the update method
function LootContainer:update(dt)

end

-- Return the LootContainer class
return LootContainer
