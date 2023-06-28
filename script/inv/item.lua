-- Item class
local Item = {}
Item.__index = Item  -- Needed for OOP in Lua
local spritesheet = love.graphics.newImage("img/itemSheet.png")
local quads = {}
local j = 0
local size = 8
for y = 0, spritesheet:getHeight()/size do
    for x = 0, (spritesheet:getWidth()/size)-1 do
        local quad = love.graphics.newQuad(x * size , y*size, size, size, spritesheet:getWidth(), spritesheet:getHeight())
        j=j+1
        print(j)
        table.insert(quads, quad) -- Dodanie quada do tablicy
    end
end
-- Item constructor
function Item.new(type, quadID, stats)
  local newItem = {}
  setmetatable(newItem, Item)
  
  newItem.type = type
  newItem.size = 64
  newItem.quadID = quadID
  newItem.stats = stats or {}
  
  return newItem
end

-- Draw method
function Item:draw(x, y)
  -- Assuming that there is a spritesheet with different quads for each type of item
  -- Quad indices match with self.quadID
  love.graphics.scale(8, 8)
  love.graphics.draw(spritesheet, quads[self.quadID], x/8, y/8)
  love.graphics.scale(1/8, 1/8)
end

return Item
