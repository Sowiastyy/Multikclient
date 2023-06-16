local sti = require("lib/sti")

local gameMap = sti("maps/mapa3.lua") 
---hitboxes
---@return table hitboxes
function gameMap:getHitboxes()
    local hitboxes = {}
    if gameMap.layers["Drzewa"] then
        for i, lay in ipairs(gameMap.layers) do
            if lay.type == "objectgroup" then
                for index, obj in ipairs(lay.objects) do
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

    local sort = {{LocalPlayer.y+43,"gracz"}}

    for index1, lay in ipairs(gameMap.layers) do -- gdzie type to objectgroup
        if lay.type == "objectgroup" then
            for index, value in ipairs(lay.objects) do
                table.insert(sort, {value.y, "drzewo", index1})
            end
        end
    end
    for index, value in pairs(Players) do
        table.insert(sort, {value.y + 43 , "players", index})
    end
    for index, value in pairs(Enemies) do
        table.insert(sort, {value.y, "enemy", index})
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