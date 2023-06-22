local Screens = {}
THIS_ID=0
NICKNAME = ""
CLASS = "Archer"
local classes = {
    "Warrior", "Archer", "Wizard"
}
local currentScreen = "Menu"
Screens.Game = require("script.game")
Screens.Menu = require("script.menu")

Screens.Menu.play = function ()
    currentScreen="Game"
    NICKNAME=Screens.Menu.buttons[3].text
    CLASS = classes[Screens.Menu.selected]
    print("CLASS", CLASS)
    Screens.Game = require("script.game")
    love.graphics.setFont(love.graphics.newFont(20))
end

function love.textinput(text)
    if currentScreen=="Menu" then
        Screens.Menu.buttons[3]:handleTextInput(text)
    else
        Screens.Game.chat.input:handleTextInput(text)
    end


end

function love.keypressed(key)
    if currentScreen=="Menu" then
        Screens.Menu.buttons[3]:handleKeyPressed(key)
    else
        Screens.Game.chat.input:handleKeyPressed(key)
    end
end

function love.mousepressed(x, y, button)
    if currentScreen=="Menu" then
        Screens.Menu.buttons[3]:handleMousePressed(x, y, button)
    else
        Screens.Game.chat.input:handleMousePressed(x, y, button)
    end
end

function love.update(dt)
    Screens[currentScreen]:update(dt)
end

function love.draw()
    Screens[currentScreen]:draw()
end