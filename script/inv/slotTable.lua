local slotTable = {}
slotTable.__index = slotTable
local spritesheet = love.graphics.newImage("img/wearPlaceholder.png")
local quads = {}
local size = 8
for x = 0, (spritesheet:getWidth()/size)-1 do
    local quad = love.graphics.newQuad(x * size , 0, size, size, spritesheet:getWidth(), spritesheet:getHeight())
    table.insert(quads, quad) -- Dodanie quada do tablicy
end
quads["armor"] = quads[2]
quads["weapon"] = quads[5]
function slotTable.new(x, y, slotSize, slotMargin, rows, columns)
  local self = setmetatable({}, slotTable)
  self.x = x
  self.y = y
  self.rows = rows
  self.columns = columns
  self.slotSize = slotSize
  self.slotMargin = slotMargin
  self.width = columns * (slotSize + slotMargin) - slotMargin
  self.height = rows * (slotSize + slotMargin) - slotMargin
  self.slots = {}
  self.items = {}
  local k=1
  for i = 1, rows do
    for j = 1, columns do
        k=k+1
        table.insert(self.slots, {})
        table.insert(self.items, {})
        print("K", k)
    end
  end
  return self
end

function slotTable:draw()
  -- Draw the grid and the items
  for i = 1, self.rows do
    for j = 1, self.columns do
      local x = self.x + (j - 1) * (self.slotSize + self.slotMargin)
      local y = self.y + (i - 1) * (self.slotSize + self.slotMargin)
      love.graphics.rectangle('line', x, y, self.slotSize, self.slotSize)
      local item = self.items[(i - 1) * self.columns + j]
      if item then
        if item.draw then
            item:draw(x, y)
        elseif self.slots[(i - 1) * self.columns + j].type then
            love.graphics.draw(spritesheet, quads[self.slots[(i - 1) * self.columns + j].type], x, y, 0, 8, 8)
        end
      end
    end
  end
end

function slotTable:update(dt)
  -- Update items if necessary
   for i, item in pairs(self.items) do
    if item.update then item:update(dt) end
  end
end

function slotTable:getItemAt(x, y)
  -- Return the index of the slot at the specified coordinates
  local column = math.floor((x - self.x) / (self.slotSize + self.slotMargin)) + 1
  local row = math.floor((y - self.y) / (self.slotSize + self.slotMargin)) + 1
  if column > 0 and column <= self.columns and row > 0 and row <= self.rows then
    return self.items[(row - 1) * self.columns + column], (row - 1) * self.columns + column
  end
end

function slotTable:setItem(item, index)
  self.items[index] = item
end

function slotTable:removeItem(index)
  self.items[index] = nil
end

return slotTable
