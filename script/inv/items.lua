local Item = require("script.inv.item")
local items  = {
    bowt1 = Item.new("weapon", 10, {
        name="bowt1",
        class="Archer",
        --Attack
        dmg=5,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    bowt2 = Item.new("weapon", 11, {
        name="bowt2",
        class="Archer",
        --Attack
        dmg=8,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    leathert1 = Item.new("armor", 4, {
        class="Archer",
        name="leathert1",
        def=3,
    }),
    leathert2 = Item.new("armor", 5, {
        class="Archer",
        name="leathert2",
        def=9,
    }),
    leathert3 = Item.new("armor", 6, {
        class="Archer",
        name="leathert3",
        def=25,
    })
}
print("check2", items.bowt1.stats.bulletType)
return items
