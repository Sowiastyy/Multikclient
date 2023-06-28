local sti = require("lib/sti")

local gameMap = sti("maps/mapa4.lua")
local rawTiles = require("maps/mapa4").layers[1].data
local objectsSheet = love.graphics.newImage("maps/treeCooler.png")
local objectsQuad = {}

for x = 0, objectsSheet:getWidth()/32 do
    local quad = love.graphics.newQuad(x * 32 , 0, 32, 32, objectsSheet:getWidth(), objectsSheet:getHeight())
    table.insert(objectsQuad, quad) -- Dodanie quada do tablicy
end

local tileset = love.graphics.newImage("img/characters/newTile.png")
local tilesetQuad = {{}, {}}
local j = 0
for y = 0, (tileset:getHeight()-16)/16 do
    for x = 0, (tileset:getWidth()-16)/16 do
        local quad = love.graphics.newQuad(x * 16 , y*16, 16, 16, tileset:getWidth(), tileset:getHeight())
        j=j+1
        table.insert(tilesetQuad, quad) -- Dodanie quada do tablicy
    end
end




local tileMap = love.graphics.newSpriteBatch(tileset, 1000)

local widthRender = 40
local heightRender =  22
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    widthRender = 20
    heightRender =  10
end

local function drawNearestTiles(playerX, playerY)
    playerY=math.floor((playerY/64)-(heightRender/2))
    playerX=math.floor((playerX/64)-(widthRender/2))
    for y = playerY, playerY+heightRender do
        for x = playerX, playerX+widthRender do
            --gameMap.layers[1].data[y*gameMap.layers[1].width+x]
            --print("TILE", rawTiles[1+(y*gameMap.layers[1].width+x)])
            
            if tilesetQuad[rawTiles[1+(y*gameMap.layers[1].width+x)]] then
                tileMap:add(tilesetQuad[rawTiles[1+(y*gameMap.layers[1].width+x)]], x*16, y*16)
            else
                tileMap:add(tilesetQuad[11], x*16, y*16)
            end
        end
    end
    love.graphics.draw(tileMap)
    tileMap:clear()
end
local objects = {}
---hitboxes
---@return table hitboxes
function gameMap:getHitboxes()
    local hitboxes = {}
    if gameMap.layers["Drzewa"] then
        for i, lay in ipairs(gameMap.layers) do
            if lay.type == "objectgroup" then
                for index, obj in ipairs(lay.objects) do
                    if obj.gid and lay.name=="Drzewa" then --gid oznacza ze ma image z grida (GRID ID)
                        table.insert(objects, obj)
                    end
                    if obj.name == "siema" then
                        table.insert(hitboxes, obj)
                    end
                end
            end
        end
    end
    if gameMap.layers["sciany"] then
        for index, obj in ipairs(gameMap.layers["sciany"].objects) do
            obj.y = obj.y - 16
            table.insert(hitboxes, obj)
            print(obj.x, obj.y)
        end
            
        
    end
    return hitboxes
end

local function sortowanie(LocalPlayer, Enemies, Players)
    local sort = {{LocalPlayer.y,"gracz"}}

    for index, value in pairs(Players) do
        table.insert(sort, {value.y , "players", index})
    end
    for index, value in pairs(objects) do
        table.insert(sort, {value.y*4-48, "drzewo", index})
    end

    for index, value in pairs(Enemies) do
        table.insert(sort, {value.y, "enemy", index})
    end

    table.sort(sort, function(a, b) return a[1] < b[1] end)
    for index, value in ipairs(sort) do
        if value[2] == "gracz"then
            LocalPlayer:draw()
        elseif value[2] == "drzewo" then
            love.graphics.scale(4,4)
            love.graphics.draw(
                objectsSheet,
                objectsQuad[objects[value[3]].gid],
                objects[value[3]].x,
                objects[value[3]].y-32
            )
            love.graphics.scale(0.25,0.25)
            
        elseif value[2] == "players" then
            Players[value[3]]:draw()
        elseif value[2] == "enemy" then
            Enemies[value[3]]:draw()
        end
    end
    return nil
end

function gameMap:draw(LocalPlayer, Enemies, Players)
    love.graphics.scale(4,4)
    --gameMap:drawLayer(gameMap.layers[1])
    drawNearestTiles(LocalPlayer.x, LocalPlayer.y)
    love.graphics.scale(0.25,0.25)
    sortowanie(LocalPlayer, Enemies, Players)
end


return gameMap