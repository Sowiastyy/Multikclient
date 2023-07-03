local Menu = {}
local Button = require("script.menu.button")
local TextInput = require("script.menu.textinput")
local img = {}
img[1] = love.graphics.newImage("img/characters/Warrior.png")
img[2] = love.graphics.newImage("img/characters/Archer.png")
img[3] = love.graphics.newImage("img/characters/Wizard.png")
Menu.selected = 2
local quad = love.graphics.newQuad(0, 0, 32, 32, img[1]:getDimensions())

local fontSize = 48
local mobile = false
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    mobile = true
end
love.graphics.setFont(love.graphics.newFont(fontSize))

Menu.buttons = {
    Button:new(20, 20, 200, 96, "Quit", function() Menu:quit() end), -- Przycisk "Quit" w lewym górnym rogu
    Button:new(love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 + 100, 200, 96, "Play", function() Menu:play() end), -- Przycisk "Play" na środku
    TextInput:new(love.graphics.getWidth()/2 - 224, love.graphics.getHeight()/2 - 50, 448, 96, 16, "Nickname") -- Pole tekstowe na środku, wyżej niż przycisk "Play"
}
function Menu:onResolutionChange()
    Menu.buttons[2].x,Menu.buttons[2].y = love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 + 100
    Menu.buttons[3].x,Menu.buttons[3].y = love.graphics.getWidth()/2 - 224, love.graphics.getHeight()/2 - 50
end
local squareSize = 128
local spacing = 10
local startY = 100
local offset=0
if mobile then
    fontSize=36
    offset=32
    Menu.buttons = {
        Button:new(10, 10, 150, 48, "Quit", function() Menu:quit() end), -- Przycisk "Quit" w lewym górnym rogu
        Button:new(love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 + 100, 150, 48, "Play", function() Menu:play() end), -- Przycisk "Play" na środku
        TextInput:new(love.graphics.getWidth()/2 - 150, love.graphics.getHeight()/2 - 50, 300, 54, 16, "Nickname") -- Pole tekstowe na środku, wyżej niż przycisk "Play"
    }
    squareSize = 64
    spacing = 5
    startY = 80
end
function Menu:play()
    -- Logic for starting the game
end

function Menu:quit()
    love.event.quit()
end

function Menu:touchpressed(id, x, y)
    for key, value in pairs(img) do
        local startX = love.graphics.getWidth() - 100

        local imgX = startX
        local imgY = startY + (key - 1) * (squareSize + spacing)
        local mouseX, mouseY = x, y
        if mouseX >= imgX and mouseX <= imgX + squareSize and mouseY >= imgY and mouseY <= imgY + squareSize then
            Menu.selected = key -- Ustaw wybraną klasę postaci na podstawie klikniętego obrazka
        end
    end
end
function Menu:update(dt)
        -- Sprawdź, czy kliknięto na obrazek klasy postaci
        for key, value in pairs(img) do
            local startX = love.graphics.getWidth() - 100
    
            local imgX = startX
            local imgY = startY + (key - 1) * (squareSize + spacing)
    
            if love.mouse.isDown(1) then -- Sprawdź, czy lewy przycisk myszy jest wciśnięty
                local mouseX, mouseY = love.mouse.getPosition()
                if mouseX >= imgX and mouseX <= imgX + squareSize and mouseY >= imgY and mouseY <= imgY + squareSize then
                    Menu.selected = key -- Ustaw wybraną klasę postaci na podstawie klikniętego obrazka
                end
            end
        end
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Menu:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
    
    -- Wyświetl napis "Class" po prawej stronie
    love.graphics.print("Class", love.graphics.getWidth() - 150, 20)

    -- Narysuj 3 kwadraty jeden pod drugim

    local i = 0
    for key, value in pairs(img) do
        local x = love.graphics.getWidth() - 150
        local y = startY + (i) * (squareSize + spacing)
        love.graphics.draw(value, quad, x, y, 0, 4, 4)
        love.graphics.rectangle("line", x+offset, y+offset, squareSize, squareSize)
        i=i+1
    end
    local selectedClass = img[Menu.selected]
    local textInputX = love.graphics.getWidth()/2 - 128
    local textInputY = love.graphics.getHeight()/2 - 50
    love.graphics.draw(selectedClass, quad, textInputX, textInputY - selectedClass:getHeight() * 8, 0, 8, 8)
end


return Menu