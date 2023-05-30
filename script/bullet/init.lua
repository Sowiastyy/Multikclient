local Bullet = {}
local stats = require("script.bullet.stats")

function Bullet:new(x, y, targetX, targetY, parent, type)
    local angle = self:getAngle(targetX, targetY)
    local bullet = {
    x = x,
    y = y,
    angle = angle,
    type = type or "basic",
    parent = parent or ""
    }
    setmetatable(bullet, self)
    self.__index = self
    return bullet
end

function Bullet:getAngle(targetX, targetY)
    local dx = targetX - self.x
    local dy = targetY - self.y
    return math.atan2(dy, dx)
end

function Bullet:update(dt)
    self.x = self.x + math.cos(self.angle) * stats[self.type].speed * dt
    self.y = self.y + math.sin(self.angle) * stats[self.type].speed * dt
end

function Bullet:draw()
    love.graphics.setColor(stats[self.type].color)
    love.graphics.circle("fill", self.x, self.y, 3)
end
function Bullet:toString()
    return string.format("BULLET|%f|%f|%f|%s|%s", self.x, self.y, self.angle, self.type, self.parent)
end

function Bullet:fromString(str)
    local parts = {}
    for part in str:gmatch("([^|]+)") do
        table.insert(parts, part)
    end
    self.x = tonumber(parts[2])
    self.y = tonumber(parts[3])
    self.angle = tonumber(parts[4])
    self.type = parts[5]
    self.parent = parts[6]
end

return Bullet
