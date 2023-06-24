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
        bulletCollisionOffsetY = stats[type or "testEnemy"].bulletCollisionOffsetY or 0,
        bulletCollisionOffsetX = stats[type or "testEnemy"].bulletCollisionOffsetX or 0,
        ox = stats[type or "testEnemy"].offsetX,
        oy = stats[type or "testEnemy"].offsetY,
    }
    setmetatable(enemy, self)
    self.__index = self
    return enemy
end

function Enemy:update(dt)
end

function Enemy:draw()
    local x, y = self.x-(stats[self.type].width/2), self.y-(stats[self.type].height/2)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((stats[self.type].image:getWidth()-60)/2)+1, y+stats[self.type].image:getHeight()+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((stats[self.type].image:getWidth()-60)/2)+1, y+stats[self.type].image:getHeight()+1, 59*(self.hp/stats[self.type].hp), 9)
    love.graphics.setColor(1, 1, 1)
    if stats[self.type].drawableData then
        if self.rotate==-1 then
            if self.type=="logTwins" then
                x = x+self.w
            else
                x=x+160
            end
            
        end
        local drawable, quad = stats[self.type].drawableData(self.frame)
        love.graphics.draw(drawable, quad, x-40, y, 0, self.rotate*5, 5,self.ox,self.oy)
    else
        love.graphics.draw(stats[self.type].image, x, y)
    end
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
    if self.id>0 then
        local parts = {}
        for part in str:gmatch("([^|]+)") do
        table.insert(parts, part)
        end

        self.x = tonumber(parts[3])
        self.y = tonumber(parts[4])
        self.hp = tonumber(parts[5])
        self.rotate = tonumber(parts[7])
        self.frame = tonumber(parts[8])
        return
    end
    local parts = {}
    for part in str:gmatch("([^|]+)") do
    table.insert(parts, part)
    end
    self.id = tonumber(parts[2])
    self.x = tonumber(parts[3])
    self.y = tonumber(parts[4])
    self.hp = tonumber(parts[5])
    self.type = parts[6]
    self.rotate = tonumber(parts[7])
    self.frame = tonumber(parts[8])
    self.w = stats[self.type or "testEnemy"].width
    self.h = stats[self.type or "testEnemy"].height
    self.bulletCollisionOffsetY = stats[self.type or "testEnemy"].bulletCollisionOffsetY
    self.bulletCollisionOffsetX = stats[self.type or "testEnemy"].bulletCollisionOffsetX
    self.ox = stats[self.type or "testEnemy"].offsetX
    self.oy = stats[self.type or "testEnemy"].offsetY
end
return Enemy
