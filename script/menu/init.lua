local Menu = {}
local Button = require("script.menu.button")
Menu.buttons = {
    Button:new(100, 200, 100, 50, "Play", function() Menu:play() end),
    Button:new(100, 300, 100, 50, "Quit", function() Menu:quit() end)
}

function Menu:play()
    -- Logic for starting the game
end

function Menu:quit()
    love.event.quit()
end

function Menu:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Menu:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end


return Menu