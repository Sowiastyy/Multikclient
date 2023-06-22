local Button = {}
Button.__index = Button

function Button:new(x, y, width, height, label, callback)
    local button = {}
    setmetatable(button, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.label = label
    button.callback = callback
    return button
end

function Button:isClicked()
    local x, y = love.mouse.getPosition()
    return x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
end

function Button:update(dt)
    
    if love.mouse.isDown(1) then
        if self:isClicked() then
            self.callback()
        end
    end
end

function Button:draw()
    local y = self.y + (self.height - love.graphics.getFont():getHeight()) / 2
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 5, 5)
    love.graphics.printf(self.label, self.x, y, self.width, "center")

end
return Button