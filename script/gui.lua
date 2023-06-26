local LocalPlayer = require("script.player.LocalPlayer")
-- gui.lua
local gui = {}
local hp = 100 -- wartość HP gracza
local maxHp = LocalPlayer.maxHp -- maksymalna wartość HP gracza
local mana = LocalPlayer.mp -- wartość mana gracza
local maxMana = LocalPlayer.maxMp -- maksymalna wartość mana gracza
local xp = LocalPlayer.xp -- wartość XP gracza
local maxXp = LocalPlayer.maxXp -- maksymalna wartość XP gracza
local hpUI = love.graphics.newImage("img/characters/hpUi.png")
local class = love.graphics.newImage("img/characters/Archer.png")
local quad = love.graphics.newQuad(0, 0, 32, 32, class:getDimensions())

local function drawBar(x, y, value, maxValue, color, height)
    local barWidth = 116 * (value / maxValue)
    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255)
    love.graphics.rectangle("fill", x, y, barWidth, height)
end

function gui:draw()
    love.graphics.draw(hpUI)
    drawBar(42, 7, LocalPlayer.hp, LocalPlayer.maxHp, {199, 38, 38}, 4)
    drawBar(42, 11, LocalPlayer.hp, LocalPlayer.maxHp, {134, 40, 40}, 3)

    drawBar(42, 16, LocalPlayer.mp, LocalPlayer.maxMp, {53, 113, 232},4 )
    drawBar(42, 20, LocalPlayer.mp, LocalPlayer.maxMp, {36, 82, 173},3 )

    drawBar(42, 25, LocalPlayer.xp, LocalPlayer.maxXp, {30, 216, 69}, 4)
    drawBar(42, 29, LocalPlayer.xp, LocalPlayer.maxXp, {31, 147, 55}, 3)
    -- Resetuj kolor
    love.graphics.setColor(1, 1, 1) -- biały kolor
    love.graphics.draw(class, quad, -11, -11, 0, 2, 2)
end

return gui