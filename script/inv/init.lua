local slotTable = require('script.inv.slotTable') -- Assuming slotTable.lua is in the same directory
local Item = require("script.inv.item")
local Items = require("script.inv.items")
local client = require("script.client")
local inventory = {}
inventory.class="Archer"
-- The two slotTables
inventory.slotTables = {}
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local storageSlotsPositionX = screenWidth -(4*64)
local equipmentSlotsPositionX = storageSlotsPositionX-196

-- We'll keep your initial row & columns for `slotTable.new`
inventory.slotTables.equipmentSlots = slotTable.new(equipmentSlotsPositionX, screenHeight-96, 64, 0, 1, 2) -- Example values
inventory.slotTables.storageSlots = slotTable.new(storageSlotsPositionX, screenHeight-128, 64, 0, 2, 4) -- Example values

--Making reference so it's more readable
local equipment = inventory.slotTables.equipmentSlots
local storage = inventory.slotTables.storageSlots

--Setting the types of the slots
equipment.slots[1].type = "weapon"
equipment.slots[2].type = "armor"

--Adding the items to inventory
storage:setItem(Items.stafft6, 2)
storage:setItem(Items.togat6, 3)
storage:setItem(Items.swordt6, 4)
storage:setItem(Items.heavyt6, 5)
storage:setItem(Items.leathert6, 6)
storage:setItem(Items.bowt6, 7)
storage:setItem(Items.bowt2, 1)
equipment:setItem(Items.bowt1, 1)
--Setting fields in Player for stats
function inventory:setPlayerEquipment(Player)
  Player.weapon =  equipment.items[1].stats
  Player.armor =  equipment.items[2].stats
  inventory.spawnX = Player.x
  inventory.spawnY = Player.y
  inventory.class=Player.hero
end

function inventory:onResolutionChange()
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  storageSlotsPositionX = screenWidth -(4*64)
  equipmentSlotsPositionX = storageSlotsPositionX-196

  storage.x, storage.y = storageSlotsPositionX, screenHeight-128
  equipment.x, equipment.y = equipmentSlotsPositionX, screenHeight-96

end
function inventory:getSlotAt(x, y)
  for key, slotTable in pairs(self.slotTables) do
    local item, id = slotTable:getItemAt(x, y)
    if item then
      return item, id, key
    end
  end
end
function inventory:setLoot(lootTable)
  if lootTable then
    inventory.slotTables.lootTable = lootTable.slotTable
    inventory.lootKey = lootTable.id
  else
    inventory.slotTables.lootTable = nil
    if inventory.draggedKey=="lootTable" then
      inventory.draggedItem = nil
    end
  end
end
function inventory:getLoot()
  if inventory.slotTables.lootTable and inventory.lootKey then
    return inventory.lootKey, inventory.slotTables.lootTable
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

function inventory:mousereleased(x, y, button, sendLootData)
  if button == 1 then -- Assuming '1' is the left mouse button
    print("ZACZYNAMY")
    if self.draggedKey and self.draggedID and self.draggedItem then
      local droppedItem, droppedID, droppedKey = self:getSlotAt(x, y)
      if droppedID and droppedKey then
        print("Znaleziono droppeda")
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

        if droppedKey=="equipmentSlots" and self.draggedItem.stats then
          success=false
          if self.draggedItem.stats.class==self.class then
            success=true
          end
        end
        
        if success then

          self.slotTables[droppedKey].items[droppedID] = self.draggedItem
          self.slotTables[self.draggedKey].items[self.draggedID] = droppedItem
          if self.draggedKey or droppedKey then
            sendLootData(self.lootKey)
          end
        else
          print("SWITCH")
          self.slotTables[droppedKey].items[droppedID] = droppedItem
          self.slotTables[self.draggedKey].items[self.draggedID] = self.draggedItem
        end
        self.draggedItem = nil
      else
        print("Nie znaleziono droppeda")
        --client:send(string.format("LOOT_CREATE|%d|%d|%s",
        --self.spawnX, self.spawnY, self.draggedItem.stats.name))
        --self.slotTables[self.draggedKey].items[self.draggedID] =nil
        --self.draggedItem = nil
        print(self.draggedID, self.draggedKey)
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
    self.draggedItem:draw(x-32, y-32)
  end
end

function inventory:update(dt)
  for _, slotTable in pairs(self.slotTables) do
    slotTable:update(dt)
  end
end

return inventory
