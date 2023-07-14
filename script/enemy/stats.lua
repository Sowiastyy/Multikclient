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
    offsetY = 0,
    xp = 20
}
stats["testBoss"] = {
    image = love.graphics.newImage("img/bossTest.png"),
    speed = 50,
    hp = 5000,
    width = 114,
    height = 138,
    xp = 600,
    drawableData = function (frame)
        return love.graphics.newImage("img/bossTest.png"), nil
    end,
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
    offsetY = 81,
    xp = 3000
}
local cyclops = love.graphics.newImage("img/cyclop_enemy/cyclops.png")
local cyclopsFrames = {}

for x = 0, cyclops:getWidth()/32 do
    local quad = love.graphics.newQuad(x * 32 , 0, 32, 32, cyclops:getWidth(), cyclops:getHeight())
    table.insert(cyclopsFrames, quad) -- Dodanie quada do tablicy
end

local twinLogs =  love.graphics.newImage("img/logTwins.png")
local twinLogsFrames = {}
for x = 0, twinLogs:getWidth()/172 do
    local quad = love.graphics.newQuad(x * 172 , 0, 172, 55, twinLogs:getWidth(), twinLogs:getHeight())
    table.insert(twinLogsFrames, quad) -- Dodanie quada do tablicy
end
local twinLog = love.graphics.newImage("img/LogTwin.png")
local twinLogFrames = {}

for x = 0, twinLogs:getWidth()/96 do
    local quad = love.graphics.newQuad(x * 96 , 0, 96, 96, twinLog:getWidth(), twinLog:getHeight())
    table.insert(twinLogFrames, quad) -- Dodanie quada do tablicy
end
stats["logTwins"] = {
    image = twinLogs,
    drawableData = function (frame)
        return twinLogs, twinLogsFrames[frame]
    end,
    speed = 50,
    hp = 8000,
    width =172*5,
    height = 55*5,
    bulletCollisionOffsetY = 20,
    bulletCollisionOffsetX = -360,
    offsetX = 72,
    offsetY = 0,
    xp = 100
}
stats["logTwin"] = {
    image = twinLog,
    drawableData = function (frame)
        return twinLog, twinLogFrames[frame]
    end,
    speed = 60,
    hp = 6000,
    width =60*5,
    height = 53*5,
    bulletCollisionOffsetY = 0,
    bulletCollisionOffsetX = -100,
    offsetX = 36,
    offsetY = 28,
    xp = 1000
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
    xp = 10
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
    xp = 20
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
    xp = 50
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
    xp = 10
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
    xp = 200
}
stats["Club"] = {
    image = cyclops,
    drawableData = function (frame)
        return cyclops, cyclopsFrames[frame]
    end,
    hp = 450,
    width = 32,
    height = 32,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
    xp = 200
}
stats["Jumper"] = {
    image = cyclops,
    drawableData = function (frame)
        return cyclops, cyclopsFrames[frame+5]
    end,
    hp = 450,
    width = 32,
    height = 32,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
    xp = 200
}
stats["Roller"] = {
    image = cyclops,
    drawableData = function (frame)
        return cyclops, cyclopsFrames[frame+11]
    end,
    hp = 450,
    width = 32,
    height = 32,
    bulletCollisionOffsetY = 40,
    bulletCollisionOffsetX = 0,
    xp = 200
}
return stats