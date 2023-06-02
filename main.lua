---@diagnostic disable: missing-parameter, duplicate-set-field
local Player = require("script.player")
local Bullet = require("script.bullet")
local Enemy = require("script.enemy")
local client = require("lib.websocket").new("prosze-dziala.herokuapp.com", 80)
--local client = require("lib.websocket").new("localhost", 5001)
print(client.socket)


local LocalBullets =  {}
local AllyBullets = {}
local EnemyBullets = {}

local LocalPlayer = Player:new(200, 200, 32, {1, 1, 1})
local Players = {}
local Enemies = {}


local function createEntitiesList(inputString)
local entitiesList = {}
local currentEntity = ""
local insideBrackets = false

for i = 1, #inputString do
local char = inputString:sub(i, i)

if char == "{" then
    insideBrackets = true
elseif char == "}" then
    table.insert(entitiesList, currentEntity)
    currentEntity = ""
    insideBrackets = false
else
    if insideBrackets then
    currentEntity = currentEntity .. char
    end
end
end

return entitiesList
end
print(createEntitiesList("ENTITIES[{PLAYER|3|450|500|32|1|1|1}{ENEMY|1|300|300|200|testEnemy}]"))
local function getEntity(s)
    if s:find("^ENEMY") then
        local newEnemyData= Enemy:new(0)
        newEnemyData:fromString(s)
        Enemies[newEnemyData.id]=newEnemyData
    elseif s:find("^PLAYER") then
        local newPlayerData = Player:new(0, 0, 32, {0, 0, 0})
        newPlayerData:fromString(s)
        if newPlayerData.id==LocalPlayer.id then return end
        Players[newPlayerData.id]=newPlayerData
    end
end
function client:onmessage(s)
    --print(s)
    if s:find("^YourID=") then
        LocalPlayer.id = tonumber(string.sub(s, 8))
    elseif s:find("^BULLET") then
        local newBulletData = Bullet:new(0, 0, 32, {0, 0, 0})
        newBulletData :fromString(s)
        if newBulletData.parent=="enm" then
            table.insert(AllyBullets, newBulletData)
        else
            table.insert(EnemyBullets, newBulletData)
        end
    elseif s:find("^ENTITIES") then
        for _, value in pairs(createEntitiesList(s)) do
            print(value)
            getEntity(value)
        end
    end
end

function client:onopen()
    if LocalPlayer.id then
        self:send(LocalPlayer:toString())
    end
end

function client:onerror(e)
    print(e)
end

function client:onclose(code, reason)
    print("closecode: "..code..", reason: "..reason)
end
local function updateBullets(bulletTable, dt)
    for key, value in pairs(bulletTable) do
        if value.life>0 then
            value:update(dt)
        else
            table.remove(bulletTable, key)
        end
    end
end
function love.update(dt)
    client:update()
    LocalPlayer:controller(function ()
        client:send(LocalPlayer:toString())
    end)
    updateBullets(LocalBullets, dt)
    updateBullets(AllyBullets, dt)
    updateBullets(EnemyBullets, dt)
end
function love.quit()
    client:send("DEL_PLAYER|"..LocalPlayer.id)
    print("QUIT")
    love.timer.sleep(1)

end
function love.mousepressed(x, y, button)
    if button == 1 then -- lewy przycisk myszy
        local angle = Bullet:getAngle(LocalPlayer.x, LocalPlayer.y, x, y)
        local bullet = Bullet:new(LocalPlayer.x, LocalPlayer.y, angle, "plr")
        client:send(bullet:toString())
        table.insert(LocalBullets, bullet)
    end
end
local function drawObjectsArray(array)
    for _, value in pairs(array) do
        value:draw()
    end
end
function love.draw()
    LocalPlayer:draw()
    drawObjectsArray(Players)
    drawObjectsArray(LocalBullets)
    drawObjectsArray(AllyBullets)
    drawObjectsArray(EnemyBullets)
    drawObjectsArray(Enemies)
end