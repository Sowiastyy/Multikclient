-- chat.lua
local TextInput = require("script.menu.textinput")
local client = require("script.client")

local chat = {
    messages = {},
    msg = "",
    active = false
}
local x = 10 -- Left margin
local y = love.graphics.getHeight() - 40 -- Bottom margin

chat.input = TextInput:new(x, y, 800, 24, 160, "Message", "left")
chat.input.drawBorder=false

function chat:draw()

    local numMessages = #self.messages
    for i, message in ipairs(self.messages) do
      love.graphics.print(message, x, y - (numMessages - i+1) * (love.graphics.getFont():getHeight()+2))
    end
    chat.input:draw()
    --love.graphics.print("MSG: "..chat.msg, x, y + 20)
end


function chat.input.returnCallback()
    if chat.input.active then
        client:send("MSG|"..NICKNAME..": "..chat.input.text)
        chat.input.text=""
    end
    chat.input.active = not chat.input.active
end


return chat
