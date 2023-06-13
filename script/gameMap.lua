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

return gameMap