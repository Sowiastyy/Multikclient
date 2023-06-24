local stats = {}
local loggerSheet = love.graphics.newImage("img/characters/loggers.png")
local cyklop = love.graphics.newImage("img/cyklop/both.png")
local garen = love.graphics.newImage("img/cyklop/garen.png")
local cyklopFrames = {}
local j = 0

    for x = 0, cyklop:getWidth()/256-1 do
        local quad = love.graphics.newQuad(x * 256 , 0, 256, 256, cyklop:getWidth(), cyklop:getHeight())
        table.insert(cyklopFrames, quad) -- Dodanie quada do tablicy
        j=j+1
        print(x, j)
    end



stats["testEnemy"] = {
    bulletCollisionOffsetY = 0,
    bulletCollisionOffsetX = 0,
    image = love.graphics.newImage("img/crang_kun.png"),
    speed = 100,
    hp = 200,
    width = 133,
    height = 133,
    offsetX = 0,
    offsetY = 0
}
stats["testBoss"] = {
    image = love.graphics.newImage("img/bossTest.png"),
    speed = 50,
    hp = 5000,
    width = 114,
    height = 138
}
stats["testBoss2"] = {
    image = cyklop,
    drawableData = function (frame)
        return cyklop, cyklopFrames[frame]
    end,
    speed = 50,
    hp = 5000,
    width = 255,
    height = 255,
    bulletCollisionOffsetY = 128,
    bulletCollisionOffsetX = -100,
    offsetX = 110,
    offsetY = 81
}
local twinLogs =  love.graphics.newImage("img/logTwins.png")
local twinLogsFrames = {}
for x = 0, twinLogs:getWidth()/256-1 do
    local quad = love.graphics.newQuad(x * 172 , 0, 172, 55, twinLogs:getWidth(), twinLogs:getHeight())
    table.insert(twinLogsFrames, quad) -- Dodanie quada do tablicy
end
stats["logTwins"] = {
    image = twinLogs,
    drawableData = function (frame)
        return twinLogs, twinLogsFrames[frame]
    end,
    speed = 50,
    hp = 8000,
    width =860,
    height = 220,
    bulletCollisionOffsetY = -20,
    bulletCollisionOffsetX = 0,
    offsetX = 0,
    offsetY = 0
}
LoggerFrames = {}
local i = 0
for y = 0, 4 do
    for x = 0, 1 do
        local quad = love.graphics.newQuad(x * 32, y * 32, 32, 32, loggerSheet:getWidth(), loggerSheet:getHeight())
        table.insert(LoggerFrames, quad) -- Dodanie quada do tablicy
        i=i+1
        print(x, y, i)
    end
end
stats["Logger"] = {
    image = loggerSheet,
    drawableData = function (frame)
        return loggerSheet, LoggerFrames[frame+2]
    end,
    hp = 125,
    width = 80,
    height = 85,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
}
stats["CrazyLogger"] = {
    image = loggerSheet,
    drawableData = function (frame)
        return loggerSheet, LoggerFrames[frame]
    end,
    hp = 125,
    width = 80,
    height = 85,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
}
stats["BattleLogger"] = {
    image = loggerSheet,
    drawableData = function (frame)
        return loggerSheet, LoggerFrames[frame+4]
    end,
    hp = 125,
    width = 80,
    height = 85,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
}
stats["Squirwel"] = {
    image = loggerSheet,
    drawableData = function (frame)
        return loggerSheet, LoggerFrames[frame+8]
    end,
    hp = 125,
    width = 80,
    height = 85,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
}
stats["PimpLogger"] = {
    image = loggerSheet,
    drawableData = function (frame)
        return loggerSheet, LoggerFrames[frame+6]
    end,
    hp = 450,
    width = 80,
    height = 85,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
}
return stats