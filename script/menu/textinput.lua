TextInput = {}

function TextInput:new(x, y, width, height, maxLength, placeholder, textAlign)
    local input = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = "",
        active = false,
        maxLength = maxLength,
        color = {1, 1, 1}, -- default color is white
        placeholder = placeholder or " ",
        textAlign = textAlign or "center",
        drawBorder = true,
        placeholderColor = {1, 1, 1, 0.5}, -- default color with alpha value of 0.5
    }
    setmetatable(input, self)
    self.__index = self
    return input
end
local mobile = false
if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
    mobile=true
end

function TextInput:handleTextInput(text)
    if self.active and #self.text < self.maxLength then
        self.text = self.text .. text
    end
end

function TextInput:handleKeyPressed(key)
    print("key", key)
    if key == "backspace" and self.active then
        self.text = string.sub(self.text, 1, -2)
    end
    if key == "return" then
        self:returnCallback()
    end
end

function TextInput:handleMousePressed(x, y, button)

    if button == 1 and x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
        self.active = true
        if mobile then
            love.keyboard.setTextInput(true)
        end
    else
        self.active = false
        if mobile then
            love.keyboard.setTextInput(false)
        end
    end
end
function TextInput:returnCallback()
end
function TextInput:update()
end

function TextInput:draw()
    local y = self.y + (self.height - love.graphics.getFont():getHeight()) / 2
    love.graphics.setColor(self.color) -- Set color to the stored color
    if self.drawBorder then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 5, 5)
    end
    if self.active then
        self.color = {0, 1, 0} -- Set color to green for active input
    else
        self.color = {1, 0, 0} -- Set color to red for inactive input
    end
    if #self.text >= self.maxLength then
        self.color = {1, 1, 0} -- Set color to yellow if maximum length is reached
    end
    
    if self.text == "" then
        love.graphics.setColor(self.placeholderColor) -- Set color to the placeholder color
        love.graphics.printf(self.placeholder, self.x, y, self.width, self.textAlign)
    else
        love.graphics.printf(self.text, self.x, y, self.width, self.textAlign)
    end
    
    self.color = {1, 1, 1} -- Reset color to white
    love.graphics.setColor(self.color)
end

return TextInput