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
    bowt3 = Item.new("weapon", 12, {
        name="bowt3",
        class="Archer",
        --Attack
        dmg=11,
        bulletType="arrow",
        count = 3,
        spread = 0.1,
    }),

    swordt1 = Item.new("weapon", 13, {
        name="swordt1",
        class="Warrior",
        --Attack
        dmg=10,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt2 = Item.new("weapon", 14, {
        name="swordt2",
        class="Warrior",
        --Attack
        dmg=20,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),
    swordt3 = Item.new("weapon", 15, {
        name="swordt3",
        class="Warrior",
        --Attack
        dmg=35,
        bulletType="warrior",
        count = 1,
        spread = 0.1,
    }),

    stafft1 = Item.new("weapon", 16, {
        name="stafft1",
        class="Wizard",
        --Attack
        dmg=10,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft2 = Item.new("weapon", 17, {
        name="stafft2",
        class="Wizard",
        --Attack
        dmg=13,
        bulletType="wizard",
        count = 2,
        spread = 0.1,
    }),
    stafft3 = Item.new("weapon", 18, {
        name="stafft3",
        class="Wizard",
        --Attack
        dmg=20,
        bulletType="wizard",
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
    }),

    heavyt1 = Item.new("armor", 1, {
        class="Warrior",
        name="heavyt1",
        def=5,
    }),
    heavyt2 = Item.new("armor", 2, {
        class="Warrior",
        name="heavyt2",
        def=15,
    }),
    heavyt3 = Item.new("armor", 3, {
        class="Warrior",
        name="heavyt3",
        def=30,
    }),

    togat1 = Item.new("armor", 7, {
        class="Wizard",
        name="togat1",
        def=2,
    }),
    togat2 = Item.new("armor", 8, {
        class="Wizard",
        name="togat2",
        def=8,
    }),
    togat3 = Item.new("armor", 9, {
        class="Wizard",
        name="togat3",
        def=15,
    }),

}
return items
