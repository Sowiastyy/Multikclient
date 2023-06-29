local Item = require("script.inv.item")
local items  = {
    bowt1 = Item.new("weapon", 11, {
        --Attack
        dmg=5,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    })
}
print("check2", items.bowt1.stats.bulletType)
return items
