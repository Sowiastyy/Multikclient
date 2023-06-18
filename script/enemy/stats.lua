local stats = {}
local anim8 = require("lib.anim8")
local loggerSheet = love.graphics.newImage("img/characters/loggers.png")
local quadTest = love.graphics.newQuad(0, 0, 32, 32, loggerSheet:getDimensions())
stats["testEnemy"] = {
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

stats["Logger"] = {
    image = loggerSheet,
    init = function (self)
        local g =anim8.newGrid(32, 32, loggerSheet:getDimensions())
        self.animation = anim8.newAnimation(g('1-2',1), 0.25)
    end,
    update = function (self, dt)
        self.animation:update(dt)
    end,
    draw = function (self, x, y)
        self.animation:draw(loggerSheet, x, y, 0, 5, 5)
    end,
    hp = 125,
    scale = 4,
    width = 114,
    height = 138
}
return stats