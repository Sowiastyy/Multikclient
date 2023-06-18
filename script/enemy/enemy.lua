--! file: enemy.lua
local stats = require("script.enemy.stats")
Enemy = {}
function Enemy:new(id, x, y, type)
    local enemy = {
        id = id,
        x = x or 0,
        y = y or 0,
        hp = stats[type or "testEnemy"].hp,
        type = type or "testEnemy",
        w = stats[type or "testEnemy"].width,
        h = stats[type or "testEnemy"].height,
    }
    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)

end

function Enemy:draw()
    local img = stats[self.type].image
    local x, y = self.x-(stats[self.type].width/2), self.y-(stats[self.type].height/2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((img:getWidth()-60)/2)+1, y+img:getHeight()+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((img:getWidth()-60)/2)+1, y+img:getHeight()+1, 59*(self.hp/stats[self.type].hp), 9)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(img, x, y)
    local r1 = {
        x = self.x-(self.w/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.h/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w,
        h = self.h,
        angle = self.angle or 0
    }
    love.graphics.rectangle("line", r1.x, r1.y, r1.w, r1.h)
end

function Enemy:fromString(str)
    local parts = {}
    for part in str:gmatch("([^|]+)") do
    table.insert(parts, part)
    end
    self.id = tonumber(parts[2])
    self.x = tonumber(parts[3])
    self.y = tonumber(parts[4])
    self.hp = tonumber(parts[5])
    self.type = parts[6]
end

return Enemy
