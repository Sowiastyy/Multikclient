local Bullet = {}
local stats = require("script.bullet.stats")
local bulletIMG= love.graphics.newImage("img/bulletSheet.png")
local quad = {
    love.graphics.newQuad(0, 3, 8, 4, bulletIMG:getDimensions()),
    love.graphics.newQuad(8, 0, 8, 8, bulletIMG:getDimensions()),
    love.graphics.newQuad(16, 0, 8, 8, bulletIMG:getDimensions()),
    love.graphics.newQuad(24, 0, 8, 8, bulletIMG:getDimensions()),
}
function Bullet:new(x, y, angle, parent, type)
    local bullet = {
    x = x,
    y = y,
    angle = angle,
    type = type or "basic",
    parent = parent or "",
    radius = 10,
    w = stats[type or "basic"].width,
    h = stats[type or "basic"].height,
    life = stats[type or "basic"].life,
    dmg =  stats[type or "basic"].damage,
    }

    setmetatable(bullet, self)
    self.__index = self
    return bullet
end

function Bullet:getAngle(x, y, targetX, targetY)
    local dx = targetX - x
    local dy = targetY - y
    return math.atan2(dy, dx)
end

function Bullet:update(dt)
    self.x = self.x + math.cos(self.angle) * stats[self.type].speed * dt
    self.y = self.y + math.sin(self.angle) * stats[self.type].speed * dt
    self.life=self.life-dt
end
function Bullet:draw()
    local scale = 4
    love.graphics.scale(scale, scale)
    love.graphics.draw(bulletIMG, quad[stats[self.type].img], self.x/scale, self.y/scale, self.angle)
    love.graphics.scale(1/scale, 1/scale)
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
    if parts[7] then
        self.parentID = parts[7]
    end
end

return Bullet
