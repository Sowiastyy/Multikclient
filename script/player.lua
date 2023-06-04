local Player = {} 
function Player:new(x, y, size, color)
    local player = {
        x = x,
        y = y,
        size = size,
        color = color,
        hp = 100,
        spd = 10,
        
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
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x-(self.size/2), self.y-(self.size/2), self.size, self.size)
end

function Player:toString()
    return string.format("PLAYER|%d|%d|%d|%f|%d|%d|%d|%d",
        self.id, self.x, self.y, self.hp, self.size, self.color[1], self.color[2], self.color[3])
end

---comment
---@param stateChangedCallback function
function Player:controller(stateChangedCallback)
    local stateChanged = false
    if love.keyboard.isDown("w") then
        stateChanged=true
        self.y=self.y-self.spd
    end
    if love.keyboard.isDown("s") then
        stateChanged=true
        self.y=self.y+self.spd
    end
    if love.keyboard.isDown("a") then
        stateChanged=true
        self.x=self.x-self.spd
    end
    if love.keyboard.isDown("d") then
        stateChanged=true
        self.x=self.x+self.spd
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
    self.color = { tonumber(parts[7]), tonumber(parts[8]), tonumber(parts[9]) }
end


return Player
