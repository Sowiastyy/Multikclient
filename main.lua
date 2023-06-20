local Screens = {}
local currentScreen = "Game"
Screens.Game = require("script.game")
Screens.Menu = require("script.menu")

Screens.Menu.play = function ()
    Screens.Game = require("script.game")
    currentScreen="Game"
end

function love.update(dt)
    Screens[currentScreen]:update(dt)
end

function love.draw()
    Screens[currentScreen]:draw()
end