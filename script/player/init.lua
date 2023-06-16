local Player = {}
local img = {}
local anim8 = require("lib.anim8")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")
local client = require("script.client")
img["Warrior"] = love.graphics.newImage("img/characters/Warrior.png")
img["Archer"] = love.graphics.newImage("img/characters/Archer.png")
img["Wizard"] = love.graphics.newImage("img/characters/Wizard.png")
local quad = love.graphics.newQuad(0, 0, 32, 32, img["Warrior"]:getDimensions())

local g = anim8.newGrid(32, 32, img["Warrior"]:getWidth(), img["Warrior"]:getHeight())
local animation = anim8.newAnimation(g('3-4',1), 0.1)

local offset = 40
local dupa = 0

function Player:new(x, y, size, hero)
    local player = {
        x = x,
        y = y,
        size = size,
        hero = hero,
        hp = 100,
        spd = 500,
        vx = 0,
        vy = 0,
        dexterity = 0.2,
        w=40,
        h=50,
        bulletCollisionOffsetY = 30,
        bulletCollisionOffsetX = 20,
        rotate = 5,
    }
    setmetatable(player, self)
    self.__index = self
    return player
end

function Player:draw()
    local x, y = self.x-(self.size/2), self.y-(self.size/2)+10
    
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59*(self.hp/100), 9)
    love.graphics.setColor(1, 1, 1)
    if THIS_ID==self.id then
        animation:draw(img[self.hero], x-offset, y-40, 0, self.rotate, 5)
    else
        love.graphics.draw(img[self.hero], quad, x-offset, y-40, 0, 5, 5)
    end

    
    local r1 = {
        x = self.x-(self.size/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.size/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w or self.size,
        h = self.h or self.size,
        angle = self.angle or 0
    }
    love.graphics.rectangle("line", r1.x, r1.y, r1.w, r1.h)
end

function Player:toString()
    return string.format("PLAYER|%d|%d|%d|%f|%d|%s",
        self.id, self.x, self.y, self.hp, self.size, self.hero)
end

---comment
function Player:controller(dt)
    local stateChanged = false
    local stateChanged2 = false
    if love.keyboard.isDown("w") then
        stateChanged=true
        self.vy = -1 * self.spd
    elseif love.keyboard.isDown("s") then
        stateChanged=true
        self.vy = self.spd
    
    else
        self.vy = 0
        stateChanged = false
    end
    if love.keyboard.isDown("a") then
        stateChanged2=true
        self.vx = self.spd * -1
        if love.mouse.isDown(1) == false then
            self.rotate = 5
            offset = 40
        end
        
    elseif love.keyboard.isDown("d") then
        stateChanged2=true
        self.vx = self.spd
        if love.mouse.isDown(1) == false then
            self.rotate = -5
            offset = -120
        end
    else
        self.vx = 0
        stateChanged2 = false
    end

    if stateChanged == true and stateChanged2 == true then
        self.vx = self.vx /math.sqrt(2)
        self.vy = self.vy /math.sqrt(2)
    end
end
function Player:update(dt)
    self:controller()
    animation:update(dt)
end

function Player:shoot(LocalBullets, dt )
    
    if love.mouse.isDown(1) then
        animation:resume()
        dupa = dupa - dt
        if dupa<0 then
            local x, y = love.mouse.getPosition( )
            local angle = Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
            local bullet = Bullet:new(self.x, self.y, angle, "plr|"..self.id, "arrow")
            local bullets = Attack(bullet, "shotgun", {count=4, spread=0.1})
            for _, bullet in ipairs(bullets) do
                client:send(bullet:toString())
                table.insert(LocalBullets, bullet)
            end
            dupa = self.dexterity
            

            if 1.6>angle and angle>-1.6 then
                self.rotate = -5
                offset = -120
            else
                self.rotate = 5
                offset = 40
            end 
        end
    else
        animation:pause()
        animation:gotoFrame(1)
    end
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
        x = self.x-(self.size/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.size/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w or self.size,
        h = self.h or self.size,
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
end


return Player
