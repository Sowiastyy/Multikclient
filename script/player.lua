local Player = {}
function Player:new(x, y, size, color)
    local player = {
        x = x,
        y = y,
        size = size,
        color = color
    }
    setmetatable(player, self)
    self.__index = self
    return player
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Player:toString()
    return string.format("PLAYER|%d|%d|%d|%d|%d|%d|%d",
        self.id, self.x, self.y, self.size, self.color[1], self.color[2], self.color[3])
end

---comment
---@param stateChangedCallback function
function Player:controller(stateChangedCallback)
    local stateChanged = false
    if love.keyboard.isDown("up") then
        stateChanged=true
        LocalPlayer.y=LocalPlayer.y-5
    end
    if love.keyboard.isDown("down") then
        stateChanged=true
        LocalPlayer.y=LocalPlayer.y+5
    end
    if love.keyboard.isDown("left") then
        stateChanged=true
        LocalPlayer.x=LocalPlayer.x-5
    end
    if love.keyboard.isDown("right") then
        stateChanged=true
        LocalPlayer.x=LocalPlayer.x+5
    end
    if stateChanged and stateChangedCallback then
        stateChangedCallback()
    end
end
function Player:fromString(str)
    local parts = {}
    for part in str:gmatch("([^|]+)") do
        table.insert(parts, part)
    end
    self.id = tonumber(parts[2])
    self.x = tonumber(parts[3])
    self.y = tonumber(parts[4])
    self.size = tonumber(parts[5])
    self.color = { tonumber(parts[6]), tonumber(parts[7]), tonumber(parts[8]) }
end


return Player
