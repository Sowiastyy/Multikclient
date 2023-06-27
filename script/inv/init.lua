-- inventory.lua
local Item = require('script.inv.item')

local inventory = {
  slots = {},
  weapon = nil,
  armor = nil,
  boots = nil,
  hat = nil,
  maxSlots = 8,
  slotSize = 80,
  slotMargin = 15,
  equipmentTypes = {"weapon", "armor", "boots", "hat"}
}

local function drawSlot(i, itemType, item)
  local iconLeft = love.graphics.getWidth() / 2 + inventory.slotMargin / 2 
                    + (inventory.slotSize + inventory.slotMargin) * (i - 1)
  local iconTop = love.graphics.getHeight() - inventory.slotSize - inventory.slotMargin
  love.graphics.rectangle('line', iconLeft, iconTop, inventory.slotSize, inventory.slotSize)
  if item then
    item:draw(iconLeft, iconTop, inventory.slotSize, inventory.slotSize)
  end
end

function inventory:addItem(item)
  if self[item.type] then
    self[item.type] = item
  elseif #self.slots < self.maxSlots then
    table.insert(self.slots, item)
  else
    print("Inventory is full!")
  end
end

function inventory:removeItem(index, type)
  if self[type] then
    self[type] = nil
  else
    table.remove(self.slots, index)
  end
end

function inventory:update(dt)
  --... your entire update function was here ...
end

function inventory:draw()
  for i, type in ipairs(self.equipmentTypes) do
    drawSlot(i, type, self[type])
  end

  for i = 1, self.maxSlots do
    drawSlot(i + #self.equipmentTypes, nil, self.slots[i])
  end
end

-- Add items
local sword = Item.new("weapon", 1)
local shield = Item.new("armor", 2)
local boots = Item.new("boots", 3)
local hat = Item.new("hat", 4)

inventory:addItem(sword)
inventory:addItem(shield)
inventory:addItem(boots)
inventory:addItem(hat)

-- To fill up the inventory with more items, here's an example
for i = 1, 8 do
    local item = Item.new("Item" .. i, i)
    inventory:addItem(item)
end

return inventory
