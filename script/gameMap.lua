local gameMap = {}
local rawMap = require("maps/mapa5")
local Zbox = require("script.gameMap.Zbox")
local Zboxes = {
Zbox:new(3680, 900, 100, 100, 0),Zbox:new(3680, 800, 100, 100, 1),
Zbox:new(4090, 650, 100, 100, 2),Zbox:new(4090, 750, 100, 100, 1)
}
local rawTiles = rawMap.layers[1].data
gameMap.hitboxes = {}
local tilesets = {}
local tilesetsQuad = {}

local tilesetsGids = {}
for key, tileset in pairs(rawMap.tilesets) do
    if love.filesystem.getInfo(tileset.image) then
        table.insert(tilesets, love.graphics.newImage(tileset.image))
    elseif love.filesystem.getInfo("maps/"..tileset.image) then
        table.insert(tilesets, love.graphics.newImage("maps/"..tileset.image))
    elseif love.filesystem.getInfo(tileset.image:sub(4)) then
        table.insert(tilesets, love.graphics.newImage(tileset.image:sub(4)))
    end
    for y = 0, (tileset.imageheight/tileset.tileheight)-1 do
        for x = 0, (tileset.imagewidth/tileset.tilewidth)-1 do
            local quad = love.graphics.newQuad(
            x * tileset.tilewidth, y * tileset.tileheight,
            tileset.tilewidth, tileset.tileheight,
            tileset.imagewidth, tileset.imageheight
        )
        
            table.insert(tilesetsGids, tilesets[key])
            table.insert(tilesetsQuad, quad)
        end
    end
    if tileset.tiles[1] then
        print("hitbox dodan")
        for index, tile in pairs(tileset.tiles) do
            for _, hitbox in pairs(tile.objectGroup.objects) do
                print("hitbox",tile.id+tileset.firstgid, "width:"..hitbox.width)
                
                --gameMap.hitboxes[tile.id+tileset.firstgid]= hitbox
            end
        end
    end
end
--!tutaj id idzie do podmianki z zmiana mapy
local tileMap = love.graphics.newSpriteBatch(tilesets[2], 1000)

local widthRender = 40
local heightRender =  22
local objectRenderDistance = 2000
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
            if tilesetsQuad[rawTiles[1+(y*rawMap.layers[1].width+x)]] then
                tileMap:add(tilesetsQuad[rawTiles[1+(y*rawMap.layers[1].width+x)]], x*16, y*16)
            else
                tileMap:add(tilesetsQuad[17], x*16, y*16)
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
    for i, lay in ipairs(rawMap.layers) do
        if lay.type == "objectgroup" then
            for index, obj in ipairs(lay.objects) do
                if obj.gid and (
                    lay.name=="Drzewa" or lay.name=="Meble" or lay.name=="Tawerna" or lay.name=="Tawerna2" or lay.name=="Tawerna3" or lay.name=="Obiekty2" or lay.name== "caveprops"
                ) then --gid oznacza ze ma image z grida (GRID ID)
                    obj.x=obj.x*4 
                    obj.drawY = obj.y*4
                    obj.y=obj.drawY-48 -- we do this to fool sort method
                    obj.drawY=obj.drawY-(obj.height*4)
                    obj.h = obj.height
                    obj.z = lay.properties.z or 0
                    obj.draw = function (self, x ,y)
                        x = x or self.x
                        y = y or self.drawY
                        love.graphics.draw(
                            tilesetsGids[self.gid],
                            tilesetsQuad[self.gid],
                            x,
                            y,
                            0,
                            4, 4
                        )
                    end

                    if gameMap.hitboxes[obj.gid] then
                        table.insert(
                            hitboxes, {
                            x=gameMap.hitboxes[obj.gid].x+ (obj.x/4),
                            y=gameMap.hitboxes[obj.gid].y+(obj.drawY/4),
                            width=gameMap.hitboxes[obj.gid].width,
                            height=gameMap.hitboxes[obj.gid].height
                        }
                    )
                    end
                    if lay.name=="Tawerna" then
                        obj.draw = function (self, x ,y)
                            x = x or self.x
                            y = y or self.drawY
                            if gameMap.playerZnormal~=0 then return end
                            love.graphics.draw(
                                tilesetsGids[self.gid],
                                tilesetsQuad[self.gid],
                                x,
                                y,
                                0,
                                4, 4
                            )
                        end
                    end
                    if lay.name=="Tawerna3" then
                        obj.y=-200
                    end
                    if lay.name=="Tawerna2" then
                        obj.y=-300
                    end

                    table.insert(objects, obj)
                end
                if obj.name == "siema" then
                    table.insert(hitboxes, obj)
                end
            end
        end
    end
    for y = 0, 499 do
        for x = 0, 499 do
            --gameMap.layers[1].data[y*gameMap.layers[1].width+x]
            --print("TILE", rawTiles[1+(y*gameMap.layers[1].width+x)])
            if rawTiles[1+(y*rawMap.layers[1].width+x)] == 5 then
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
            if distanceTo(value.x, (value.drawY or value.y), gameMap.playerXnormal, gameMap.playerYnormal)
            and gameMap.playerZnormal>=(value.z or 0) then
                table.insert(gameMap.sort, value)
            end
        end
    end

    table.sort(gameMap.sort, function(a, b)
        if a.z == b.z then
            return a.y < b.y
        else
            return a.z < b.z
        end
    end)
    for _, value in ipairs(gameMap.sort) do
        value:draw()
    end

    return nil
end

function gameMap:draw(LocalPlayer, Enemies, Players, LootContainers)
    gameMap.playerXnormal, gameMap.playerYnormal, gameMap.playerZnormal=LocalPlayer.x, LocalPlayer.y, LocalPlayer.z
    love.graphics.scale(4,4)
    --gameMap:drawLayer(gameMap.layers[1])
    drawNearestTiles(LocalPlayer.x, LocalPlayer.y)
    love.graphics.scale(0.25,0.25)
    sortowanie({LocalPlayer}, Enemies, Players, LootContainers, objects)
    for _, value in pairs(Zboxes) do
        value:update(LocalPlayer)
        value:draw()
    end
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