--! file: enemy.lua
local stats = require("script.enemy.stats")
Enemy = {}

function Enemy:new(id, x, y, type)
    local enemy = {
        id = id,
        x = x or 0,
        y = y or 0,
        hp = stats[type or "testEnemy"].hp or 0,
        type = type or "testEnemy",

    }
    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)

end

function Enemy:draw()
    local img = stats[self.type].image
    love.graphics.rectangle("line", self.x+((img:getWidth()-60)/2), self.y+img:getHeight(), 60, 10)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x+((img:getWidth()-60)/2)+1, self.y+img:getHeight()+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x+((img:getWidth()-60)/2)+1, self.y+img:getHeight()+1, 59*(self.hp/stats[self.type].hp), 9)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, img:getWidth(), img:getHeight())
    love.graphics.draw(img, self.x, self.y)
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
