local Item = require("script.inv.item")
local items  = {
    bowt1 = Item.new("weapon", 19, {
        class="Archer",
        dmg=5,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    bowt2 = Item.new("weapon", 20, {
        class="Archer",
        dmg=8,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    bowt3 = Item.new("weapon", 21, {
        class="Archer",
        dmg=11,
        bulletType="arrow",
        count = 3,
        spread = 0.1,
    }),
    bowt4 = Item.new("weapon", 22, {
        class="Archer",
        dmg=13,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    bowt5 = Item.new("weapon", 23, {
        class="Archer",
        dmg=15,
        bulletType="arrow",
        count = 2,
        spread = 0.1,
    }),
    bowt6 = Item.new("weapon", 24, {
        class="Archer",
        dmg=14,
        bulletType="arrow",
        count = 4,
        spread = 0.1,
    }),

    swordt1 = Item.new("weapon", 25, {
        class="Warrior",
        dmg=10,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt2 = Item.new("weapon", 26, {
        class="Warrior",
        dmg=20,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt3 = Item.new("weapon", 27, {
        class="Warrior",
        dmg=35,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt4 = Item.new("weapon", 28, {
        class="Warrior",
        dmg=45,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt5 = Item.new("weapon", 29, {
        class="Warrior",
        dmg=60,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt6 = Item.new("weapon", 30, {
        class="Warrior",
        dmg=80,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    stafft1 = Item.new("weapon", 31, {
        class="Wizard",
        dmg=10,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft2 = Item.new("weapon", 32, {
        class="Wizard",
        dmg=13,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft3 = Item.new("weapon", 33, {
        class="Wizard",
        dmg=20,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft4 = Item.new("weapon", 34, {
        class="Wizard",
        dmg=25,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft5 = Item.new("weapon", 35, {
        class="Wizard",
        dmg=32,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft6 = Item.new("weapon", 36, {
        class="Wizard",
        dmg=28,
        bulletType="wizard",
        count = 3,
        spread = 0.05,
    }),
    leathert1 = Item.new("armor", 7, {
        class="Archer",
        def=3,
    }),
    leathert2 = Item.new("armor", 8, {
        class="Archer",
        def=9,
    }),
    leathert3 = Item.new("armor", 9, {
        class="Archer",
        def=25,
    }),
    leathert4 = Item.new("armor", 10, {
        class="Archer",
        def=30,
    }),
    leathert5 = Item.new("armor", 11, {
        class="Archer",
        def=36,
    }),
    leathert6 = Item.new("armor", 12, {
        class="Archer",
        def=48,
    }),

    heavyt1 = Item.new("armor", 1, {
        class="Warrior",
        def=5,
    }),
    heavyt2 = Item.new("armor", 2, {
        class="Warrior",
        def=15,
    }),
    heavyt3 = Item.new("armor", 3, {
        class="Warrior",
        def=30,
    }),
    heavyt4 = Item.new("armor", 4, {
        class="Warrior",
        def=40,
    }),
    heavyt5 = Item.new("armor", 5, {
        class="Warrior",
        def=55,
    }),
    heavyt6 = Item.new("armor", 6, {
        class="Warrior",
        def=75,
    }),

    togat1 = Item.new("armor", 13, {
        class="Wizard",
        def=2,
    }),
    togat2 = Item.new("armor", 14, {
        class="Wizard",
        def=8,
    }),
    togat3 = Item.new("armor", 15, {
        class="Wizard",
        def=15,
    }),
    togat4 = Item.new("armor", 16, {
        class="Wizard",
        def=20,
    }),
    togat5 = Item.new("armor", 17, {
        class="Wizard",
        def=25,
    }),
    togat6 = Item.new("armor", 18, {
        class="Wizard",
        def=35,
    }),
}
for key, value in pairs(items) do
    value.stats.name = key
    if value.type=="weapon" then
        value.stats.bulletType = key
    end
end
return items
