local Bullet = require("script.bullet")
local attacks = {
    shotgun3 = function (x, y, angle, parent, bulletType)
        return {
            Bullet:new(x, y, angle, parent, bulletType),
            Bullet:new(x, y, angle-0.1, parent, bulletType),
            Bullet:new(x, y, angle+0.1, parent, bulletType)
        }
    end,

}
local function Attack(x, y, angle, parent, bulletType, type)
    return attacks[type](x, y, angle, parent, bulletType)
end
return Attack