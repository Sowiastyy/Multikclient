---@diagnostic disable: missing-parameter, duplicate-set-field
love.graphics.setDefaultFilter("nearest", "nearest")
love.window.setVSync(0)
local Player = require("script.player")
local Bullet = require("script.bullet")
local Enemy = require("script.enemy")
local camera = require("lib.camera")
local wf = require("lib.windfield")
local Joystick = require("script.joystick")
local sti = require("lib/sti")
require("script.helpers")
local client = require("lib.websocket").new("prosze-dziala.herokuapp.com", 80)
--local client = require("lib.websocket").new("localhost", 5001)

local world = wf.newWorld(0, 0) 

local cam = camera()
local LocalBullets =  {}
local AllyBullets = {}
local EnemyBullets = {}
local testRect = {x=0, y=0, w=100, h=100, size=100}
local LocalPlayer = Player:new(400, 300, 64, "Archer-Purple")
local Players = {}
local Enemies = {}
local joystick = Joystick.new(100, 250, 50, 100, 20000)
local bulletokres = 0.2
local dupa = bulletokres

local gameMap = sti("maps/mapa3.lua") 

local PlayerCollider = world:newBSGRectangleCollider(400, 250, 40, 70, 14)
PlayerCollider:setFixedRotation(true)
local walls = {}
if gameMap.layers["Drzewa"] then
    for i, lay in ipairs(gameMap.layers) do
        if lay.type == "objectgroup" then
            for index, obj in ipairs(lay.objects) do
                
                print(obj.name)
                if obj.name == "siema" then
                    local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                    wall:setType('static')
                    table.insert(walls,wall) 
                    
                end
            end
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
    joystick:touchreleased(id, x, y, dx, dy, pressure)
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
                    client:send("HIT|"..enemy.id.."|10|"..LocalPlayer.id)
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
    end


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

function love.draw()
    cam:attach()
        --[[for _, value in ipairs(gameMap.layers) do
            gameMap:drawLayer(value)
        end--]]
        gameMap:drawLayer(gameMap.layers[1])
        sortowanie()
        drawObjectsArray(Players)
        drawObjectsArray(LocalBullets)
        drawObjectsArray(AllyBullets)
        drawObjectsArray(EnemyBullets)
        drawObjectsArray(Enemies)
        
        love.graphics.rectangle("line", testRect.x, testRect.y, testRect.w,  testRect.h)
    cam:detach()
    joystick:draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function sortowanie()

    local sort = {{LocalPlayer.y+40,"gracz"}}

    for index1, lay in ipairs(gameMap.layers) do -- gdzie type to objectgroup
        if lay.type == "objectgroup" then
            for index, value in ipairs(lay.objects) do
                table.insert(sort, {value.y, "drzewo", index1})
            end
        end
    end
    
    local x = #sort


    
    for i = 0, x, 1 do
        for j = 1, x-i-1, 1 do
            
            if sort[j][1]>sort[j+1][1] then
                sort[j] , sort[j+1] = sort[j+1] , sort[j]     
            end
        end
    end
    -- tu sortowanie bombelkowe zrobic mam
    for index, value in ipairs(sort) do
        if value[2] == "gracz"then
            LocalPlayer:draw()
        elseif value[2] == "drzewo" then
            gameMap:drawLayer(gameMap.layers[value[3]])
        end
    end
    

    
    
    return nil
end
