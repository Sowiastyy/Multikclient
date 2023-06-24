local Bullet = {}
local stats = require("script.bullet.stats")
local shotPattern = require("script.bullet.shotPattern")
local bulletIMG= love.graphics.newImage("img/bulletSheet.png")
local bulletBatch = love.graphics.newSpriteBatch(bulletIMG, 1000) -- 1000 to maksymalna liczba bulletów

local quad = {
    love.graphics.newQuad(0, 3, 8, 4, bulletIMG:getDimensions()),
    love.graphics.newQuad(8, 1, 8, 6, bulletIMG:getDimensions()),
    love.graphics.newQuad(16, 2, 8, 3, bulletIMG:getDimensions()),
    love.graphics.newQuad(24, 2, 7, 4, bulletIMG:getDimensions()),
    love.graphics.newQuad(32, 0, 6, 4, bulletIMG:getDimensions()),
    love.graphics.newQuad(40, 0, 8, 7, bulletIMG:getDimensions()),
    love.graphics.newQuad(48, 0, 5, 3, bulletIMG:getDimensions()),
}
function Bullet:new(x, y, angle, parent, type)
    print("type", type)
    local bullet = {
    x = x,
    y = y,
    ox = x, --Origin X
    oy= y, --Origin Y
    angle = angle,
    type = type or "basic",
    parent = parent or "",
    radius = 10,
    w = stats[type or "basic"].width,
    h = stats[type or "basic"].height,
    life = stats[type or "basic"].life,
    dmg =  stats[type or "basic"].damage,
    speed = stats[type or "basic"].speed,
    hasClicked = false, --If bool value is needed for shotPattern
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
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
    if shotPattern[stats[self.type].updatePattern] then
        shotPattern[stats[self.type].updatePattern](self)
    end
    self.life=self.life-dt
end

local scale = 4
function Bullet:draw()
    bulletBatch:add(quad[stats[self.type].img], self.x, self.y, self.angle, scale, scale)
end
function Bullet:drawBatch()
    love.graphics.draw(bulletBatch)
    bulletBatch:clear()
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
    self.w = stats[self.type or "basic"].width
    self.h = stats[self.type or "basic"].height
    self.life = stats[self.type or "basic"].life
    self.dmg =  stats[self.type or "basic"].damage
    self.speed = stats[self.type or "basic"].speed
    if parts[7] then
        self.parentID = parts[7]
    end

end

return Bullet
