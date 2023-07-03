local sti = require("lib/sti")

local gameMap = sti("maps/mapa5.lua")
local rawTiles = require("maps/mapa5").layers[1].data
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
local objectRenderDistance = 1900
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    widthRender = 20
    heightRender =  10
    objectRenderDistance = 1000
end

local function drawNearestTiles(playerX, playerY)
    gameMap.playerY=math.floor((playerY/64)-(heightRender/2))
    gameMap.playerX=math.floor((playerX/64)-(widthRender/2))
    for y = gameMap.playerY, gameMap.playerY+heightRender do
        for x = gameMap.playerX, gameMap.playerX+widthRender do
            --gameMap.layers[1].data[y*gameMap.layers[1].width+x]
            --print("TILE", rawTiles[1+(y*gameMap.layers[1].width+x)])
            if tilesetQuad[rawTiles[1+(y*gameMap.layers[1].width+x)]] then
                tileMap:add(tilesetQuad[rawTiles[1+(y*gameMap.layers[1].width+x)]], x*16, y*16)
            else
                tileMap:add(tilesetQuad[17], x*16, y*16)
            end
        end
    end
    love.graphics.draw(tileMap)
    tileMap:clear()
end
local objects = {}
---hitboxes
---@return table hitboxes
function gameMap:getHitboxes(playerX, playerY)
    local hitboxes = {}
    if gameMap.layers["Drzewa"] then
        for i, lay in ipairs(gameMap.layers) do
            if lay.type == "objectgroup" then
                for index, obj in ipairs(lay.objects) do
                    if obj.gid and lay.name=="Drzewa" then --gid oznacza ze ma image z grida (GRID ID)
                        obj.x=obj.x*4
                        obj.drawY = obj.y*4
                        obj.y=obj.drawY-48 -- we do this to fool sort method
                        obj.h = obj.height
                        obj.draw = function (self, x ,y)
                            x = x or self.x
                            y = y or self.drawY
                            love.graphics.draw(
                                objectsSheet,
                                objectsQuad[self.gid],
                                x,
                                y-128,
                                0,
                                4, 4
                            )
                        end

                        table.insert(objects, obj)
                    end
                    if obj.name == "siema" then
                        table.insert(hitboxes, obj)
                    end
                end
            end
        end
    end
    for y = 0, 499 do
        for x = 0, 499 do
            --gameMap.layers[1].data[y*gameMap.layers[1].width+x]
            --print("TILE", rawTiles[1+(y*gameMap.layers[1].width+x)])
            if rawTiles[1+(y*gameMap.layers[1].width+x)] == 5 then
                table.insert(hitboxes, {
                    x=x*16-1,
                    y=y*16,
                    width = 16-1,
                    height = 16 
            })
            end
            
        end
    end
    return hitboxes
end

local function distanceTo(x1, y1, x2, y2)
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)
    return (dx<objectRenderDistance and dy<objectRenderDistance)
end

local function sortowanie(...)
    gameMap.sort = {}
    local args = {...}
    for _, tab in pairs(args) do
        for _, value in pairs(tab) do
            if distanceTo(value.x, value.y, gameMap.playerX, gameMap.playerY) then
                table.insert(gameMap.sort, value)
            end
        end
    end

    table.sort(gameMap.sort, function(a, b) return a.y < b.y end)
    for _, value in ipairs(gameMap.sort) do
        value:draw()
    end

    return nil
end

function gameMap:draw(LocalPlayer, Enemies, Players, LootContainers)
    gameMap.playerX, gameMap.playerY=LocalPlayer.x, LocalPlayer.y
    love.graphics.scale(4,4)
    --gameMap:drawLayer(gameMap.layers[1])
    drawNearestTiles(LocalPlayer.x, LocalPlayer.y)
    love.graphics.scale(0.25,0.25)
    sortowanie({LocalPlayer}, Enemies, Players, LootContainers, objects)
end
function gameMap:drawUnderthewater()
    if not gameMap.sort then
        return
    end
    love.graphics.push()
    love.graphics.scale(1, -1) -- This flips the Y-axis
    for key, value in pairs(gameMap.sort) do
        value:draw(nil, -value.y-(value.h*2))
    end
    love.graphics.pop()
end

return gameMap