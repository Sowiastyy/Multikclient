local Bullet = require("script.bullet")
local attacks = {
    shotgun = function (x, y, angle, parent, bulletType, spread, count, z)
        local bullets = {}
        for i = 1, count do
            local bulletAngle = angle + ((i-(count+1)/2)-spread) * spread
            table.insert(bullets, Bullet:new(x, y, bulletAngle, parent, bulletType, z))
        end
        return bullets
    end
}
---comment
---@param str string
---@return table bullets
local function Attack_fromString(str)
    local parts = {}
    for part in str:gmatch("([^|]+)") do
        table.insert(parts, part)
    end
    local x = tonumber(parts[2])
    local y = tonumber(parts[3])
    local angle = tonumber(parts[4])
    local parent = parts[5].."|"..parts[6]
    local bulletType = parts[7]
    local attackType = parts[8]
    local spread = tonumber(parts[9])
    local count = tonumber(parts[10])
    local z = tonumber(parts[11])
    return attacks[attackType](x, y, angle, parent, bulletType, spread, count, z)
end
local function Attack(bullet, typeAtttack, settings)
    if type(bullet)=="string" then
        return Attack_fromString(bullet)
    end
    local spread = 0.1
    local count = 3
    if settings then
        spread = settings.spread or 0.1
        count = settings.count or 3
    end

    return attacks[typeAtttack](bullet.x, bullet.y, bullet.angle, bullet.parent, bullet.type, spread, count)
end

return Attack