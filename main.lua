local Game = require("script.game")

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end