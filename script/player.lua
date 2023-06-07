local Player = {}
local playerIMG= love.graphics.newImage("img/characters/Warrior-Blue.png")
local quad = love.graphics.newQuad(0, 0, 32, 32, playerIMG:getDimensions())

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
        
    }
    setmetatable(player, self)
    self.__index = self
    return player
end

function Player:draw()
    local x, y = self.x-(self.size/2), self.y-(self.size/2)+10
    love.graphics.rectangle("line", x+((self.size-60)/2), y+self.size, 60, 10)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59*(self.hp/100), 9)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, 64, 64)
    local scale = 4
    love.graphics.scale(scale, scale)
    local img=love.graphics.newImage("img/characters/"..self.hero..".png")
    love.graphics.draw(img, quad, x/scale-8, y/scale-8)
    love.graphics.scale(1/scale, 1/scale)
end

function Player:toString()
    return string.format("PLAYER|%d|%d|%d|%f|%d|%s",
        self.id, self.x, self.y, self.hp, self.size, self.hero)
end

---comment
---@param stateChangedCallback function
function Player:controller(stateChangedCallback)
    local stateChanged = false
    if love.keyboard.isDown("w") then
        stateChanged=true
        self.vy = -1 * self.spd
   
    elseif love.keyboard.isDown("s") then
        stateChanged=true
        self.vy = self.spd
    
    else
        self.vy = 0
    end
    if love.keyboard.isDown("a") then
        stateChanged=true
        self.vx = self.spd * -1
    
    elseif love.keyboard.isDown("d") then
        stateChanged=true
        self.vx = self.spd
    else
        self.vx = 0
    end
    if stateChanged and stateChangedCallback then
        stateChangedCallback()
    end
end
function Player:checkBulletCollision(bullet)
    -- Get the bounding boxes of the player and bullet
    local playerBox = {
        x = self.x-(self.size/2),
        y = self.y-(self.size/2),
        width = self.size,
        height = self.size
    }
    local bulletBox = {
        x = bullet.x - bullet.radius,
        y = bullet.y - bullet.radius,
        width = bullet.radius * 2,
        height = bullet.radius * 2
    }

    -- Check if the bounding boxes intersect
    if playerBox.x + playerBox.width > bulletBox.x and
        playerBox.x < bulletBox.x + bulletBox.width and
        playerBox.y + playerBox.height > bulletBox.y and
        playerBox.y < bulletBox.y + bulletBox.height then
    -- Check if the center point of the bullet is inside the player's bounding box
    local bulletCenterX = bullet.x
    local bulletCenterY = bullet.y
    if bulletCenterX > playerBox.x and
        bulletCenterX < playerBox.x + playerBox.width and
        bulletCenterY > playerBox.y and
        bulletCenterY < playerBox.y + playerBox.height then
        -- Player has been hit!
        return true
    end
    end

    -- Player has not been hit
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
