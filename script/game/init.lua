THIS_ID=0
love.graphics.setDefaultFilter("nearest", "nearest")
love.window.setVSync(0)
local Player = require("script.player")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")
local Enemy = require("script.enemy")
local camera = require("lib.camera")
local chat = require("script.chat")
local Joystick = require("script.joystick")

require("script.helpers")
local client = require("script.client")

local world = require("lib.windfield").newWorld(0, 0)

local cam = camera()
cam.scale =  cam.scale * 0.8
local LocalBullets =  {}
local AllyBullets = {}
local EnemyBullets = {} 
local testRect = {x=0, y=0, w=100, h=100, size=100}
local LocalPlayer = require("script.player.LocalPlayer")
local Players = {}
local Enemies = {}
local joystick = Joystick.new(100, 250, 50, 100, 20000)


local gameMap = require("script.gameMap")

local PlayerCollider = world:newBSGRectangleCollider(610, 400, 30, 10,1)
PlayerCollider:setFixedRotation(true)
local walls = {}

for index, obj in ipairs(gameMap:getHitboxes()) do
    local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    wall:setType('static')
    table.insert(walls,wall)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    joystick:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    joystick:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    joystick:touchreleased(id, x, y, dx, dy, pressure)
end

function love.keypressed(k)
    if k=="return" then
        chat:onReturnClick(client, "Macius200"..THIS_ID)
    end
end

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
    elseif s:find("^ATTACK") then
        local bullets = Attack(s)
        for _, newBulletData in ipairs(bullets) do
            local parts = {}
            for part in newBulletData.parent:gmatch("([^|]+)") do
                table.insert(parts, part)
            end
            if newBulletData.parent=="enm" then
                table.insert(EnemyBullets, newBulletData)
            elseif tonumber(parts[2])~=tonumber(LocalPlayer.id) then
                table.insert(AllyBullets, newBulletData)
            end
        end
    elseif s:find("^PLAYER") then
        local newPlayerData = Player:new(0, 0, 32, {0, 0, 0})
        newPlayerData:fromString(s)
        if newPlayerData.id==LocalPlayer.id then return end
        Players[newPlayerData.id]=newPlayerData
    elseif s:find("^MSG") then
        local parts = {}
        for part in s:gmatch("([^|]+)") do
            table.insert(parts, part)
        end
        table.insert(chat.messages, parts[2])
    end

end

function client:onmessage(s)
    --print(s) 
    if s:find("^YourID=") then
        LocalPlayer.id = tonumber(string.sub(s, 8))
        THIS_ID = LocalPlayer.id
    elseif s:find("^ENTITIES") then
        Enemies = {}
        Players = {}
        for _, value in pairs(createEntitiesList(s)) do
            getEntity(value)
        end
    end
end

local Game = {}

function Game:update(dt)
    client:update()
    LocalPlayer:update(dt, LocalBullets)

    for key, bullet in pairs(EnemyBullets) do
        if LocalPlayer:checkBulletCollision(bullet) then
            LocalPlayer.hp = LocalPlayer.hp - bullet.dmg
            table.remove(EnemyBullets, key)
        end
    end
    for index, bullet in ipairs(LocalBullets) do
        if LocalPlayer.checkBulletCollision(testRect, bullet) then
            table.remove(LocalBullets, index)
        end
    end
    for index, enemy in pairs(Enemies) do
        if enemy then
            for key, bullet in pairs(LocalBullets) do
                if LocalPlayer.checkBulletCollision(enemy, bullet) then
                    table.remove(LocalBullets, key)
                    client:send("HIT|"..enemy.id.."|"..bullet.dmg.."|"..LocalPlayer.id)
                    
                end
            end
            if enemy.hp<=0 then
                Enemies[index] = nil
                table.remove(Enemies, index)
            end
        end
    end
    if joystick.distance>0 then
        LocalPlayer.vx =  math.cos(joystick.angle) * joystick.speed * dt
        LocalPlayer.vy = math.sin(joystick.angle) * joystick.speed * dt
        client:send(LocalPlayer:toString())
    end


    updateBullets(LocalBullets, dt)
    updateBullets(AllyBullets, dt)
    updateBullets(EnemyBullets, dt)

    cam:lookAt(LocalPlayer.x, LocalPlayer.y)
    if LocalPlayer.hp<0 then
        PlayerCollider:destroy()
        PlayerCollider = world:newBSGRectangleCollider(610, 400, 30, 10,1)
        PlayerCollider:setFixedRotation(true)
        LocalPlayer.hp = 100
    end
    world:update(dt)
    PlayerCollider:setLinearVelocity(LocalPlayer.vx,LocalPlayer.vy)
    LocalPlayer.x = PlayerCollider:getX()
    LocalPlayer.y = PlayerCollider:getY()-38
end

function Game:draw()
    cam:attach()
        gameMap:draw(LocalPlayer, Enemies, Players)
        drawObjectsArray(LocalBullets)
        drawObjectsArray(AllyBullets)
        drawObjectsArray(EnemyBullets)
        world:draw()

        love.graphics.rectangle("line", testRect.x-(testRect.w/2), testRect.y-(testRect.h/2), testRect.w,  testRect.h)
    cam:detach()
    joystick:draw()
    chat:draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

return Game
