local Menu = {}
local Button = require("script.menu.button")
local TextInput = require("script.menu.textinput")
local img = {}
img[1] = love.graphics.newImage("img/characters/Warrior.png")
img[2] = love.graphics.newImage("img/characters/Archer.png")
img[3] = love.graphics.newImage("img/characters/Wizard.png")
Menu.selected = 2
local quad = love.graphics.newQuad(0, 0, 32, 32, img[1]:getDimensions())

love.graphics.setFont(love.graphics.newFont(48))
Menu.buttons = {
    Button:new(20, 20, 200, 96, "Quit", function() Menu:quit() end), -- Przycisk "Quit" w lewym górnym rogu
    Button:new(love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 + 100, 200, 96, "Play", function() Menu:play() end), -- Przycisk "Play" na środku
    TextInput:new(love.graphics.getWidth()/2 - 256, love.graphics.getHeight()/2 - 50, 512, 96, 16, "Nickname") -- Pole tekstowe na środku, wyżej niż przycisk "Play"
}
function Menu:play()
    -- Logic for starting the game
end

function Menu:quit()
    love.event.quit()
end
local squareSize = 128
local spacing = 10
local startY = 100
function Menu:update(dt)
        -- Sprawdź, czy kliknięto na obrazek klasy postaci
        for key, value in pairs(img) do
            local startX = love.graphics.getWidth() - 200
    
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
    love.graphics.print("Class", love.graphics.getWidth() - 200, 20)

    -- Narysuj 3 kwadraty jeden pod drugim

    local i = 0
    for key, value in pairs(img) do
        local x = love.graphics.getWidth() - 200
        local y = startY + (i) * (squareSize + spacing)
        love.graphics.draw(value, quad, x, y, 0, 4, 4)
        love.graphics.rectangle("line", x, y, squareSize, squareSize)
        i=i+1
    end
    local selectedClass = img[Menu.selected]
    local textInputX = love.graphics.getWidth()/2 - 128
    local textInputY = love.graphics.getHeight()/2 - 50
    love.graphics.draw(selectedClass, quad, textInputX, textInputY - selectedClass:getHeight() * 8, 0, 8, 8)
end


return Menu