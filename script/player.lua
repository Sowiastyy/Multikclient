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
        LocalPlayer.y=LocalPlayer.y-10
    end
    if love.keyboard.isDown("down") then
        stateChanged=true
        LocalPlayer.y=LocalPlayer.y+10
    end
    if love.keyboard.isDown("left") then
        stateChanged=true
        LocalPlayer.x=LocalPlayer.x-10
    end
    if love.keyboard.isDown("right") then
        stateChanged=true
        LocalPlayer.x=LocalPlayer.x+10
    end
    if stateChanged and stateChangedCallback then
        stateChangedCallback()
    end
end
function Player:fromString(str)
    local id, x, y, size, r, g, b = str:match("PLAYER|%d+|%d+|%d+|%d+|%d+|%d+|%d+")
    self.id = tonumber(id)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.size = tonumber(size)
    self.color = { tonumber(r), tonumber(g), tonumber(b) }
end


return Player
