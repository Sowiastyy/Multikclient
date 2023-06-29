local Player = {}



local img = {}
img["Warrior"] = love.graphics.newImage("img/characters/Warrior.png")
img["Archer"] = love.graphics.newImage("img/characters/Archer.png")
img["Wizard"] = love.graphics.newImage("img/characters/Wizard.png")
local frames = {}
for x = 0, 3 do
    local quad = love.graphics.newQuad(x * 32, 0, 32, 32, img["Warrior"]:getDimensions())
    table.insert(frames, quad)
end
function Player:new(x, y, size, hero)
    local player = {
        x = x,
        y = y,
        size = size or 80,
        hero = hero,
        hp = 100,
        maxHp = 100,
        def = 0,
        mp = 100,
        maxMp = 200,
        regenatate = 0.2,
        xp = 0,
        maxXp = 100,
        lvl = 1,
        spd = 500,
        vx = 0,
        vy = 0,
        dexterity = 0.2,
        w=40,
        h=50,
        bulletCollisionOffsetY = 10,
        bulletCollisionOffsetX = 0,
        rotate = 5,
        frame =  1,
        dmgMulti = 1
    }
    setmetatable(player, self)
    self.__index = self
    return player
end




local function rotatedRectanglesCollide(r1X, r1Y, r1W, r1H, r1A, r2X, r2Y, r2W, r2H, r2A)
local r1HW = r1W / 2
local r1HH = r1H / 2
local r2HW = r2W / 2
local r2HH = r2H / 2

local r1CX = r1X + r1HW
local r1CY = r1Y + r1HH
local r2CX = r2X + r2HW
local r2CY = r2Y + r2HH

local cosR1A = math.cos(r1A)
local sinR1A = math.sin(r1A)
local cosR2A = math.cos(r2A)
local sinR2A = math.sin(r2A)

local r1RX =  cosR2A * (r1CX - r2CX) + sinR2A * (r1CY - r2CY) + r2CX - r1HW
local r1RY = -sinR2A * (r1CX - r2CX) + cosR2A * (r1CY - r2CY) + r2CY - r1HH
local r2RX =  cosR1A * (r2CX - r1CX) + sinR1A * (r2CY - r1CY) + r1CX - r2HW
local r2RY = -sinR1A * (r2CX - r1CX) + cosR1A * (r2CY - r1CY) + r1CY - r2HH

local cosR1AR2A = math.abs(cosR1A * cosR2A + sinR1A * sinR2A)
local sinR1AR2A = math.abs(sinR1A * cosR2A - cosR1A * sinR2A)
local cosR2AR1A = math.abs(cosR2A * cosR1A + sinR2A * sinR1A)
local sinR2AR1A = math.abs(sinR2A * cosR1A - cosR2A * sinR1A)

local r1BBH = r1W * sinR1AR2A + r1H * cosR1AR2A
local r1BBW = r1W * cosR1AR2A + r1H * sinR1AR2A
local r1BBX = r1RX + r1HW - r1BBW / 2
local r1BBY = r1RY + r1HH - r1BBH / 2

local r2BBH = r2W * sinR2AR1A + r2H * cosR2AR1A
local r2BBW = r2W * cosR2AR1A + r2H * sinR2AR1A
local r2BBX = r2RX + r2HW - r2BBW / 2
local r2BBY = r2RY + r2HH - r2BBH / 2

return r1X < r2BBX + r2BBW and r1X + r1W > r2BBX and r1Y < r2BBY + r2BBH and r1Y + r1H > r2BBY and
        r2X < r1BBX + r1BBW and r2X + r2W > r1BBX and r2Y < r1BBY + r1BBH and r2Y + r2H > r1BBY
end

function Player:checkBulletCollision(bullet)
    local r1 = {
        x = self.x-(self.w/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.h/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w,
        h = self.h,
        angle = self.angle or 0
    }
    local r2 = {
        x = bullet.x,
        y = bullet.y,
        w = bullet.w,
        h = bullet.h,
        angle = self.angle or 0
    }
    if rotatedRectanglesCollide(r1.x, r1.y, r1.w, r1.h, r1.angle, r2.x, r2.y, r2.w, r2.h, r2.angle) then
        return true
    end

    return false
end
function Player:draw(x, y)
    local drawBar = true
    if y and not x then
        drawBar = false
    end
    x = x or self.x
    y = y or self.y
    x, y = x-(self.size/2), y-(self.size/2)+10
    if drawBar then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59, 9)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59*(self.hp/100), 9)
        love.graphics.setColor(1, 1, 1)
    end

    if self.rotate<0 then
        x = x+160
    end
    love.graphics.draw(img[self.hero], frames[self.frame], x-40, y-40, 0, self.rotate, 5)
    
    local r1 = {
        x = self.x-(self.w/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.h/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w,
        h = self.h,
        angle = self.angle or 0
    }
    love.graphics.rectangle("line", r1.x, r1.y, r1.w, r1.h)
end
function Player:fromString(str)
    local parts = {}
    for part in str:gmatch("([^|]+)") do
        table.insert(parts, part)
    end
    self.id = tonumber(parts[2])
    self.x = tonumber(parts[3])
    self.y = tonumber(parts[4])
    self.hp = tonumber(parts[5])
    self.size = tonumber(parts[6])
    self.hero = parts[7]
    self.rotate = tonumber(parts[8])
    self.frame =  tonumber(parts[9])
end


return Player
