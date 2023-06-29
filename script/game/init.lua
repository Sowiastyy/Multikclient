THIS_ID=0
local Game = {}
love.graphics.setDefaultFilter("nearest", "nearest")

local Player = require("script.player")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")
local Enemy = require("script.enemy")
local camera = require("lib.camera")
Game.chat = require("script.chat")
local gui = require("script.gui")
require("script.helpers")
local client = require("script.client")
local world = require("lib.windfield").newWorld(0, 0)
-- main.lua
local inventory = require('script.inv')



local cam = camera()
cam.scale =  cam.scale * 0.8
local LocalBullets =  {}
local AllyBullets = {}
local EnemyBullets = {}
local LocalPlayer = require("script.player.LocalPlayer")

local Players = {}
local Enemies = {}
local mobile = false
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    mobile = true
end

local MobileController
local mobileController
local mobileController2
if mobile then
    MobileController = require("script.player.mobileController")
    mobileController = MobileController:new()
    mobileController2 = MobileController:new("right")
    function Game.touchPressed(id, x, y)
        mobileController:touchPressed(id, x, y)
        mobileController2:touchPressed(id, x, y)
    end

    function love.touchmoved(id, x, y)
        mobileController:touchMoved(id, x, y)
        mobileController2:touchMoved(id, x, y)
    end

    function love.touchreleased(id, x, y)
        mobileController:touchReleased(id, x, y)
        mobileController2:touchReleased(id, x, y)
    end
end


LocalPlayer.shootMobile = LocalPlayer.shoot
local gameMap = require("script.gameMap")

local PlayerCollider = world:newBSGRectangleCollider(610, 400, 30, 10,1)
PlayerCollider:setFixedRotation(true)
local walls = {}

for index, obj in ipairs(gameMap:getHitboxes(LocalPlayer.x, LocalPlayer.y)) do
    local wall = world:newRectangleCollider(obj.x*4, obj.y*4, obj.width*4, obj.height*4)
    wall:setType('static')
    table.insert(walls,wall)
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
            if parts[1]=="enm" then
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
        table.insert(Game.chat.messages, parts[2])
    
    elseif s:find("^XP") then
        local parts = {}
        for part in s:gmatch("([^|]+)") do
            table.insert(parts, part)
        end
        LocalPlayer:xpAdd(parts[2], parts[3], parts[4])
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
function Game.mousepressed(x, y, button)
    inventory:mousepressed(x, y, button)
end
function Game.mousereleased(x, y, button)
    inventory:mousereleased(x, y, button)
end
function Game:update(dt)
    client:update()
    LocalPlayer:update(dt, LocalBullets)
    inventory:setPlayerEquipment(LocalPlayer)
    if mobile then
        LocalPlayer:shootMobile(LocalBullets, dt, mobileController2.distance>0, mobileController2.angle )
        if mobileController.distance>0 then
            LocalPlayer.vx =  math.cos(mobileController.angle) * 300
            LocalPlayer.vy = math.sin(mobileController.angle) * 300
        end
    
    end
    for key, bullet in pairs(EnemyBullets) do
        
        for index, ally in pairs(Players) do
            if ally:checkBulletCollision(bullet) then
                table.remove(EnemyBullets, key)
            end
        end
        if LocalPlayer:checkBulletCollision(bullet) then
            LocalPlayer.hp = LocalPlayer.hp - bullet.dmg * (100/(100+LocalPlayer.def))
            table.remove(EnemyBullets, key)
        end
    end
    for index, enemy in pairs(Enemies) do
        if enemy then
            enemy:update(dt)
            for key, bullet in pairs(LocalBullets) do
                if LocalPlayer.checkBulletCollision(enemy, bullet) then
                    table.remove(LocalBullets, key)
                    client:send("HIT|"..enemy.id.."|"..LocalPlayer.weapon.dmg * LocalPlayer.dmgMulti.."|"..LocalPlayer.id)
                end
            end
        end
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
        Bullet:drawBatch()
        --world:draw()
    cam:detach()
    gui:draw()
    Game.chat:draw()
    if mobile then
        mobileController:draw()
        mobileController2:draw()
    end
    inventory:draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 168, 10)
end

return Game
