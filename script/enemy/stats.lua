local stats = {}
local anim8 = require("lib.anim8")
local loggerSheet = love.graphics.newImage("img/characters/loggers.png")
local quadTest = {
    love.graphics.newQuad(0, 0, 32, 32, loggerSheet:getDimensions()),
    love.graphics.newQuad(0, 32, 32, 32, loggerSheet:getDimensions()),
    love.graphics.newQuad(0, 64, 32, 32, loggerSheet:getDimensions()),
    love.graphics.newQuad(0, 96, 32, 32, loggerSheet:getDimensions()),
    love.graphics.newQuad(0, 128, 32, 32, loggerSheet:getDimensions()),
}
stats["testEnemy"] = {
    bulletCollisionOffsetY = 0,
    bulletCollisionOffsetX = 0,
    image = love.graphics.newImage("img/crang_kun.png"),
    speed = 100,
    hp = 200,
    width = 133,
    height = 133
}
stats["testBoss"] = {
    image = love.graphics.newImage("img/bossTest.png"),
    speed = 50,
    hp = 5000,
    width = 114,
    height = 138
}
return stats