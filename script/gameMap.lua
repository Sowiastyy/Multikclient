local sti = require("lib/sti")

local gameMap = sti("maps/mapa4.lua")

local objectsSheet = love.graphics.newImage("maps/treeCooler.png")
local objectsQuad = {}

for x = 0, objectsSheet:getWidth()/32 do
    local quad = love.graphics.newQuad(x * 32 , 0, 32, 32, objectsSheet:getWidth(), objectsSheet:getHeight())
    table.insert(objectsQuad, quad) -- Dodanie quada do tablicy
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
                    if obj.gid then --gid oznacza ze ma image z grida (GRID ID)
                        table.insert(objects, obj)
                    end
                    if obj.name == "siema" then
                        table.insert(hitboxes, obj)
                    end
                end
            end
        end
    end
    return hitboxes
end

local function sortowanie(LocalPlayer, Enemies, Players)
    local sort = {{LocalPlayer.y,"gracz"}}
    for index1, lay in ipairs(gameMap.layers) do -- gdzie type to objectgroup
        if lay.type == "objectgroup" then
            for index, value in ipairs(lay.objects) do
                --table.insert(sort, {value.y*4, "drzewo", index1})
            end
        end
    end
    for index, value in pairs(Players) do
        table.insert(sort, {value.y , "players", index})
    end
    for index, value in pairs(objects) do
        print("INDEX", index)
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
            print("VALUE3", value[3], value[2], value[1])
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
    gameMap:drawLayer(gameMap.layers[1])
    love.graphics.scale(0.25,0.25)
    sortowanie(LocalPlayer, Enemies, Players)
end


return gameMap