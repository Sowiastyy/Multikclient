local slotTable = require('script.inv.slotTable') -- Assuming slotTable.lua is in the same directory
local Item = require("script.inv.item")
local inventory = {}
-- The two slotTables
inventory.slotTables = {}
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
-- Calculate positions for `equipmentSlots` and `storageSlots`
-- screenWidth/4 ensures that the equipmentSlots are placed to the left of the center screen
-- screenWidth*3/4 ensures that the storageSlots are placed to the right center screen.
local equipmentSlotsPositionX = screenWidth / 4
local storageSlotsPositionX =( screenWidth / 4)+400

-- We'll keep your initial row & columns for `slotTable.new`
inventory.slotTables.equipmentSlots = slotTable.new(equipmentSlotsPositionX, screenHeight-100, 64, 0, 1, 4) -- Example values
inventory.slotTables.storageSlots = slotTable.new(storageSlotsPositionX, screenHeight-140, 64, 0, 2, 4) -- Example values

for i = 1, inventory.slotTables.equipmentSlots.columns do
  local item = Item.new("Item for equipmentSlot:" .. i, i, 64)
  inventory.slotTables.equipmentSlots:setItem(item, i)
end
inventory.slotTables.equipmentSlots.slots[1].type = "weapon"
local item = Item.new("weapon", 11, {gowno="XD"})
inventory.slotTables.storageSlots:setItem(item, 2)
function inventory:getSlotAt(x, y)
  for key, slotTable in pairs(self.slotTables) do
    local item, id = slotTable:getItemAt(x, y)
    if item then
      return item, id, key
    end
  end
end

function inventory:mousepressed(x, y, button)
  if button == 1 then
    self.draggedItem, self.draggedID, self.draggedKey = self:getSlotAt(x, y)
    if self.draggedItem then
      if not self.draggedItem.quadID then
        self.draggedItem, self.draggedID, self.draggedKey = nil, nil, nil
      else
        self.slotTables[self.draggedKey].items[self.draggedID].draw =nil
      end
    end
  end
end

function inventory:mousereleased(x, y, button)
  if button == 1 then -- Assuming '1' is the left mouse button
    if self.draggedKey and self.draggedID then
      local droppedItem, droppedID, droppedKey = self:getSlotAt(x, y)
      if droppedID then
        local success = true
        local typeDropped = self.slotTables[droppedKey].slots[droppedID].type
        if typeDropped then
          success=false
          if self.draggedItem.type then
            if self.draggedItem.type==typeDropped then
              success=true
            end
          end
        end
        if success then
          self.slotTables[droppedKey].items[droppedID] = self.draggedItem
          self.slotTables[self.draggedKey].items[self.draggedID] = droppedItem
        else
          self.slotTables[droppedKey].items[droppedID] = droppedItem
          self.slotTables[self.draggedKey].items[self.draggedID] = self.draggedItem
        end
        self.draggedItem = nil
      end
    end
  end
end

function inventory:draw()
  for _, slotTable in pairs(self.slotTables) do
    slotTable:draw()
  end

  -- Draw the dragged item separately at mouse position
  if self.draggedItem then
    local x, y = love.mouse.getPosition()
    self.draggedItem:draw(x, y)
  end
end

function inventory:update(dt)
  for _, slotTable in pairs(self.slotTables) do
    slotTable:update(dt)
  end
end

return inventory
