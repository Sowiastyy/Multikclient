-- chat.lua

local chat = {
    messages = {},
    msg = "",
    active = false
}

function chat:draw()
    local x = 10 -- Left margin
    local y = love.graphics.getHeight() - 40 -- Bottom margin
    local numMessages = #self.messages
    for i, message in ipairs(self.messages) do
      love.graphics.print(message, x, y - (numMessages - i) * 20)
    end
    
    love.graphics.print("MSG: "..chat.msg, x, y + 20)
end


function chat:onReturnClick(client, nick)
    if love.keyboard.isDown("return") then
        if self.active then
            client:send("MSG|"..nick..": "..self.msg)
            self.msg=""
        end
        self.active = not self.active
    end
end

function love.textinput(t)
    if chat.active then
        chat.msg = chat.msg .. t
    end
end


return chat
