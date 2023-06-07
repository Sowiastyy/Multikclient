---@diagnostic disable: missing-parameter, duplicate-set-field
love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("script.player")
local Bullet = require("script.bullet")
local Enemy = require("script.enemy")
local camera = require("lib.camera")
local wf = require("lib.windfield")
local Joystick = require("script.joystick")
local sti = require("lib/sti")
local client = require("lib.websocket").new("prosze-dziala.herokuapp.com", 80)
--local client = require("lib.websocket").new("localhost", 5001)

print(client.socket)

local world = wf.newWorld(0, 0) 


local cam = camera()
local LocalBullets =  {}
local AllyBullets = {}
local EnemyBullets = {}

local LocalPlayer = Player:new(400, 300, 64, "Archer-Purple")
local Players = {}
local Enemies = {}
local joystick = Joystick.new(100, 400, 50, 100, 100)
local bulletokres = 0.2
local dupa = bulletokres

local gameMap = sti("maps/mapa3.lua") 

local PlayerCollider = world:newBSGRectangleCollider(400, 250, 40, 80, 14)
local walls = {}
if gameMap.layers["Drzewa"] then
    for i, obj in ipairs(gameMap.layers["Drzewa"].objects) do
        local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        wall:setType('static')
        table.insert(walls,wall)
    end
end




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
        if Enemies[newEnemyData.id].hp<=0 then
            table.remove(Enemies, newEnemyData.id)
        end
    elseif s:find("^BULLET") then
        local newBulletData = Bullet:new(0, 0, 32, {0, 0, 0})
        newBulletData :fromString(s)
        if newBulletData.parent=="enm" then
            table.insert(EnemyBullets, newBulletData)
        elseif tonumber(newBulletData.parentID)~=tonumber(LocalPlayer.id) then
            table.insert(AllyBullets, newBulletData)
        end
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
    elseif s:find("^ENTITIES") then
        for _, value in pairs(createEntitiesList(s)) do
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
    for key, bullet in pairs(EnemyBullets) do
        if LocalPlayer:checkBulletCollision(bullet) then
            print("dostalem")
            LocalPlayer.hp = LocalPlayer.hp - bullet.dmg
            table.remove(EnemyBullets, key)
        end
    end
    
    for index, enemy in pairs(Enemies) do
        if enemy then
            for key, bullet in pairs(LocalBullets) do
                if LocalPlayer.checkBulletCollision(enemy, bullet) then
                    table.remove(LocalBullets, key)
                    client:send("HIT|"..enemy.id.."|10|"..LocalPlayer.id)
                end
            end
            if enemy.hp<=0 then
                Enemies[index] = nil
                table.remove(Enemies, index)
            end
        end
    end
    LocalPlayer.x = LocalPlayer.x + math.cos(joystick.angle) * joystick.distance * dt
    LocalPlayer.y = LocalPlayer.y + math.sin(joystick.angle) * joystick.distance * dt

    updateBullets(LocalBullets, dt)
    updateBullets(AllyBullets, dt)
    updateBullets(EnemyBullets, dt)

    cam:lookAt(LocalPlayer.x, LocalPlayer.y)
    
    
    if love.mouse.isDown(1) then
        
        dupa = dupa - dt
        if dupa<0 then
            local x, y = love.mouse.getPosition( )
            local angle = Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
            local bullet = Bullet:new(LocalPlayer.x, LocalPlayer.y, angle, "plr|"..LocalPlayer.id)
            client:send(bullet:toString())
            table.insert(LocalBullets, bullet)
            dupa = bulletokres
        end
        
    end
    world:update(dt)
    PlayerCollider:setLinearVelocity(LocalPlayer.vx,LocalPlayer.vy)
    LocalPlayer.x = PlayerCollider:getX()
    LocalPlayer.y = PlayerCollider:getY()-12

    
end
function love.quit()
    client:send("DEL_PLAYER|"..LocalPlayer.id)
    print("QUIT")
    love.timer.sleep(1)

end


--[[function love.mousepressed(x, y, button) 
    if button == 1 then -- lewy przycisk myszy
        local angle = Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
        local bullet = Bullet:new(LocalPlayer.x, LocalPlayer.y, angle, "plr|"..LocalPlayer.id)
        client:send(bullet:toString())
        table.insert(LocalBullets, bullet)
    end
end--]]
local function drawObjectsArray(array)
    for _, value in pairs(array) do
        if value then
            value:draw()
        end
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    joystick:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    joystick:touchmoved(id, x, y, dx, dy, pressure)
end
function love.touchreleased(id, x, y, dx, dy, pressure)
    Joystick:touchreleased(id, x, y, dx, dy, pressure)
end
function love.draw()
    cam:attach()
        for index, value in ipairs(gameMap.layers) do
            gameMap:drawLayer(value)
        end
        LocalPlayer:draw()
        drawObjectsArray(Players)
        drawObjectsArray(LocalBullets)
        drawObjectsArray(AllyBullets)
        drawObjectsArray(EnemyBullets)
        drawObjectsArray(Enemies)
        world:draw()
        
    cam:detach()
    joystick:draw()
end