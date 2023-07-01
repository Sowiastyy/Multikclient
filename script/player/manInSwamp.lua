local rawTiles = require("maps/mapa5").layers[1].data
local sti = require("lib/sti")
local gameMap = sti("maps/mapa5.lua")

local manInSwamp = {}
local slowDown = {3,17}
function manInSwamp:setOffsetAndFrame(x,y,anim1,anim2)
    x = math.floor(x/64)
    y = math.floor(y/64)+1
    if rawTiles[1+(y*gameMap.layers[1].width+x)] then  
        for key, value in pairs(slowDown) do
            
            if rawTiles[1+(y*gameMap.layers[1].width+x)] == value then
                return anim2, 28      
            end
        end
        print(rawTiles[1+(y*gameMap.layers[1].width+x)])
        return anim1, 40  
    end
    return anim2, 28
end
return manInSwamp