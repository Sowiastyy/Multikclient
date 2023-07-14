local gameMap = {}
local rawMap = require("maps/mapa5")
local Zbox = require("script.gameMap.Zbox")
local Zboxes = {
Zbox:new(3580, 900, 100, 100, 0),Zbox:new(3580, 800, 100, 100, 1),
Zbox:new(4090, 650, 100, 100, 2),Zbox:new(4090, 750, 100, 100, 1),
Zbox:new(30080,  22550, 100, 50, 0),Zbox:new(30080,  22400, 100, 50, -1)
}
function table_to_json(t, indent)
    indent = indent or ""
    if type(t) ~= "table" then
        if type(t) == "string" then
            return string.format("%q", t)
        else
            return tostring(t)
        end
    else
        local isArray = #t > 0
        local json = isArray and "[\n" or "{\n"
        local indent2 = indent .. "  "
        for k, v in pairs(t) do
            if not isArray then
                json = json .. indent2 .. '"' .. k .. '": '
            end
            json = json .. table_to_json(v, indent2) .. ",\n"
        end
        json = json:sub(1, -3) .. "\n" .. indent .. (isArray and "]" or "}")
        return json
    end
end

local rawTiles = rawMap.layers[1].data
local undergroundTiles =  rawMap.layers[2].data
gameMap.hitboxes = {}
local tilesets = {}
local tilesetsQuad = {}
local undertileMap = {}

local tilesetsGids = {}
local function mergeWithExistingRectangle(hitboxes, new_rect)
    local epsilon = 0.01  -- Choose an appropriate value for your use case

    for i = 1, #hitboxes do
        local old_rect = hitboxes[i]

        -- Check if rectangles can be merged horizontally
        if old_rect.y == new_rect.y and old_rect.height == new_rect.height and 
        (old_rect.x + old_rect.width == new_rect.x or new_rect.x + new_rect.width == old_rect.x) then
            local merged_rect = {
                x = math.min(old_rect.x, new_rect.x),
                y = old_rect.y, -- As both y are same
                width = old_rect.width + new_rect.width,
                height = old_rect.height, -- As both heights are same
                z = old_rect.z -- Assuming z remains the same in a merged rectangle
            }
            hitboxes[i] = merged_rect -- Replace old rectangle with the merged one
            return true -- Rectangle merged successfully
        end

        -- Check if rectangles can be merged vertically
        if math.abs(old_rect.x - new_rect.x) < epsilon and old_rect.width == new_rect.width and
        (old_rect.y + old_rect.height == new_rect.y or new_rect.y + new_rect.height == old_rect.y) then
            local merged_rect = {
                x = old_rect.x, -- As both x are same
                y = math.min(old_rect.y, new_rect.y),
                width = old_rect.width, -- As both widths are same
                height = old_rect.height + new_rect.height,
                z = old_rect.z -- Assuming z remains the same in a merged rectangle
            }
            hitboxes[i] = merged_rect -- Replace old rectangle with the merged one
            return true -- Rectangle merged successfully
        end
    end

    return false -- No successful merge
end


local function loadTilesHitboxes(hitboxes, tiles, z)
    for y = 0, 499 do
        for x = 0, 499 do
            local id = 1 + (y * rawMap.layers[1].width + x)
            local gid = tiles[id]

            if gameMap.hitboxes[gid] then
                for _, hitbox in pairs(gameMap.hitboxes[gid]) do
                    local xOffset = hitbox.x
                    local yOffset = hitbox.y
                    local width = hitbox.width
                    local height = hitbox.height
                    local new_rect = {
                        x = math.ceil(xOffset + (x * 16)),
                        y = math.ceil(yOffset + (y * 16)),
                        width = math.ceil(width),
                        height = math.ceil(height),
                        z = z or 0
                    }

                    -- Attempt to merge the new rectangle with an existing one
                    if not mergeWithExistingRectangle(hitboxes, new_rect) then
                        -- If no successful merge, add the new rectangle to the table
                        table.insert(hitboxes, new_rect)
                    end
                end
            end
        end
    end
end



for key, tileset in pairs(rawMap.tilesets) do
    if love.filesystem.getInfo(tileset.image) then
        table.insert(tilesets, love.graphics.newImage(tileset.image))
    elseif love.filesystem.getInfo("maps/"..tileset.image) then
        table.insert(tilesets, love.graphics.newImage("maps/"..tileset.image))
    elseif love.filesystem.getInfo(tileset.image:sub(4)) then
        table.insert(tilesets, love.graphics.newImage(tileset.image:sub(4)))
    end
    if tileset.name=="newDung" then
        undertileMap = love.graphics.newSpriteBatch(tilesets[key], 1000)
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
        for index, tile in pairs(tileset.tiles) do
            gameMap.hitboxes[tile.id+tileset.firstgid] = {}
            for _, hitbox in pairs(tile.objectGroup.objects) do
                print("hitbox",tile.id+tileset.firstgid, "width:"..hitbox.width)
                gameMap.hitboxes[tile.id+tileset.firstgid][hitbox.id]= hitbox
            end
        end
    end
end
--!tutaj id idzie do podmianki z zmiana mapy
local tileMap0 = love.graphics.newSpriteBatch(tilesets[2], 1000)
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
    local tiles = rawTiles
    local tileMap = tileMap0
    local placeholder = 17
    if gameMap.playerZnormal<0 then
        tiles=undergroundTiles
        tileMap = undertileMap
        placeholder = 0
    end
    for y = gameMap.playerY, gameMap.playerY+heightRender do
        for x = gameMap.playerX, gameMap.playerX+widthRender do
            if tilesetsQuad[tiles[1+(y*rawMap.layers[1].width+x)]] then
                tileMap:add(tilesetsQuad[tiles[1+(y*rawMap.layers[1].width+x)]], x*16, y*16)
            elseif placeholder>0 then
                tileMap:add(tilesetsQuad[placeholder], x*16, y*16)
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
                    lay.name=="Drzewa" or lay.name=="underground" or lay.name=="Meble" or lay.name=="Obiekty3" or lay.name=="Tawerna" or lay.name=="Tawerna2" or lay.name=="Tawerna3" or lay.name=="Obiekty2" or lay.name== "caveprops"
                ) then --gid oznacza ze ma image z grida (GRID ID)
                    local qx, qy, qw, qh = tilesetsQuad[obj.gid]:getViewport()
                    obj.scaleX = (obj.width/qw)*4
                    obj.scaleY = (obj.height/qh)*4
                    obj.x=obj.x*4
                    obj.drawY = obj.y*obj.scaleX
                    obj.y=obj.drawY-(obj.height*1.5)-- we do this to fool sort method
                    obj.drawY=obj.drawY-(obj.height*obj.scaleY)

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
                            self.scaleX, self.scaleY
                        )
                    end

                    if gameMap.hitboxes[obj.gid] then
                        for _, hitbox in pairs(gameMap.hitboxes[obj.gid]) do
                            local xOffset = hitbox.x*(obj.scaleX/4)
                            local yOffset = hitbox.y*(obj.scaleY/4)
                            local width =hitbox.width*(obj.scaleX/4)
                            local height =hitbox.height*(obj.scaleY/4)
                            table.insert(
                                hitboxes, {
                                x=xOffset + (obj.x/4),
                                y=yOffset+(obj.drawY/obj.scaleY),
                                width=width,
                                height=height,
                                z=obj.z
                            })
                        end 
                    end
                    if lay.name=="Obiekty3" then
                        obj.drawY=obj.drawY-(obj.drawY/obj.scaleY)
                    end
                    if lay.name=="Tawerna" then
                        obj.y=obj.y-200
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
                                self.scaleX, self.scaleY
                            )
                        end
                    end
                    if lay.name=="underground" then
                        obj.y=obj.y-10000
                        obj.draw = function (self, x ,y)
                            x = x or self.x
                            y = y or self.drawY
                            if gameMap.playerZnormal>=0 then return end
                            love.graphics.draw(
                                tilesetsGids[self.gid],
                                tilesetsQuad[self.gid],
                                x,
                                y,
                                0,
                                self.scaleX, self.scaleY
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
                    obj.properties = nil
                    table.insert(hitboxes, obj)
                end
            end
        end
    end
    loadTilesHitboxes(hitboxes, rawTiles, 0)
    loadTilesHitboxes(hitboxes, undergroundTiles, -1)
    --local file = io.open('gameMap.json', 'w')
    --file:write(table_to_json(hitboxes))
    --file:close()
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
        a.z = a.z or 0
        b.z = b.z or 0
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
    if gameMap.playerZnormal then
        if gameMap.playerZnormal<0 then
            return
        end
    end
    love.graphics.push()
    love.graphics.scale(1, -1) -- This flips the Y-axis
    for key, value in pairs(gameMap.sort) do
        value:draw(nil, -value.y-(value.h*2))
    end
    love.graphics.pop()
end

return gameMap