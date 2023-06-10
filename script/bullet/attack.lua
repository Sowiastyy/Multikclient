local Bullet = require("script.bullet")
local attacks = {
    shotgun = function (x, y, angle, parent, bulletType, spread, count, distance)
        local bullets = {}
        for i = 1, count do
            local bulletAngle = angle + ((i-(count+1)/2)-spread) * spread
            table.insert(bullets, Bullet:new(x, y, bulletAngle, parent, bulletType))
        end
        return bullets
    end
}

local function Attack(bullet, type, settings)
    local spread = 0.1
    local count = 3
    local distance = 30
    if settings then
        spread = settings.spread or 0.1
        count = settings.count or 3
        distance = settings.distance or 30
    end

    return attacks[type](bullet.x, bullet.y, bullet.angle, bullet.parent, bullet.type, spread, count, distance)
end

return Attack