--[[
Define the ZBox class with properties
and the methods .update() and .draw()
--]]
ZBox = {}
ZBox.__index = ZBox

-- Assume we use the "class" like this
-- local zBox = ZBox:new(10, 20, 30, 40, 50)

function ZBox:new(x, y, w, h, zChange)
    local zBox = {}
    setmetatable(zBox, ZBox)

    zBox.x = x
    zBox.y = y
    zBox.w = w
    zBox.h = h
    zBox.zChange = zChange

    return zBox
end

function ZBox:update(Player)
    if Player:checkBulletCollision(self) then
        Player.z = self.zChange
    end
end

function ZBox:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end
return ZBox