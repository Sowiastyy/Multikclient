--! file: enemy.lua
local stats = require("script.enemy.stats")
local anim8 = require("lib.anim8")
local loggerSheet = love.graphics.newImage("img/characters/loggers.png")
local quadTest = love.graphics.newQuad(0, 0, 32, 32, loggerSheet:getDimensions())
local g =anim8.newGrid(32, 32, loggerSheet:getDimensions()) 
local animation = anim8.newAnimation(g('1-2',1), 0.1)
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
    if self.animation then
        self.animation:update(dt)
        self.animation:flipV()

    end

end

function Enemy:draw()
    local img = stats[self.type].image
    local x, y = self.x-(stats[self.type].width/2), self.y-(stats[self.type].height/2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((img:getWidth()-60)/2)+1, y+img:getHeight()+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((img:getWidth()-60)/2)+1, y+img:getHeight()+1, 59*(self.hp/stats[self.type].hp), 9)
    love.graphics.setColor(1, 1, 1)
    if stats[self.type].draw then
        print(self.animation.position)
        self.animation:draw(loggerSheet, x, y, 0, 5, 5)
    else
        --love.graphics.draw(img, x, y)
    end

    local r1 = {
        x = self.x-(self.w/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.h/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w,
        h = self.h,
        angle = self.angle or 0
    }
    
    love.graphics.rectangle("line", r1.x, r1.y, r1.w, r1.h)
    animation:draw(loggerSheet, x+100, y, 0, 5, 5)
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
    if stats[self.type].init then
        stats[self.type].init(self)
    end
end

return Enemy
