local stats = {}
stats["warrior"] = {
    speed=400,
    damage=30,
    life=0.7,
    xoffset=0,
    yoffset=3,
    width=8,
    height=2,
    img=8,
    --updatePattern = "sideToSide"
}
for i = 1, 6 do
    stats["swordt"..i] = {
        speed=400,
        damage=30,
        life=0.7,
        xoffset=0,
        yoffset=3,
        width=8,
        height=2,
        img=7+i,
        rot=0.78
    }
    stats["bowt"..i] = {
        speed=1000,
        damage=4,
        life=1,
        width=8,
        height=3,
        updatePattern = "slowDown",
        img=14+i,
    }
    stats["stafft"..i] = {
        speed=400,
        damage=12,
        life=1.2,
        width=7,
        height=4,
        --updatePattern = "returnBack"
        img=21+i,
    }
end
stats["warrior_spell"] = {
    speed=500,
    damage=100,
    life=1,
    xoffset=0,
    yoffset=3,
    width=8,
    height=2,
    img=2,
    --updatePattern = "sideToSide"
}

stats["wizard"] = {
    speed=400,
    damage=12,
    life=1.2,
    img=4,
    width=7,
    height=4,
    --updatePattern = "returnBack"
}
stats["wizard_spell"] = {
    speed=400,
    damage=20,
    life=1,
    img=4,
    width=7,
    height=4,
    --updatePattern = "returnBack"
}

stats["archer_spell"] = {
    speed=400,
    damage=500,
    life=5,
    img=3,
    width=8,
    height=3,
    --updatePattern = "returnBack"
}


stats["basic"] = {
    speed=400,
    damage=10,
    life=10,
    xoffset=0,
    yoffset=3,
    width=8,
    height=2,
    img=1,
    --updatePattern = "sideToSide"
}
stats["sting"] = {
    speed=500,
    damage=20,
    life=0.5,
    xoffset=0,
    yoffset=3,
    width=8,
    height=2,
    img=1,
}
stats["slash"] = {
    speed=600,
    damage=30,
    life=1,
    xoffset=0,
    yoffset=1,
    width=8,
    height=6,
    img=2,
    updatePattern = "slowDown"
}
stats["slashCircle"] = {
    speed=5,
    damage=20,
    life=15,
    xoffset=0,
    yoffset=1,
    width=8,
    height=6,
    img=2,
    updatePattern = "rotateAround"
}
stats["arrow"] = {
    speed=1000,
    damage=4,
    life=1,
    width=8,
    height=3,
    img=3,
    updatePattern = "slowDown"
}

stats["magic_bullet"] = {
    speed=200,
    damage=12,
    life=5,
    img=4,
    width=7,
    height=4,
    updatePattern = "returnBack"
}
stats["axe"] = {
    speed=225,
    damage=30,
    life=3,
    img=5,
    width=8,
    height=4,
}
stats["battleAxe"] = {
    speed=175,
    damage=45,
    life=3,
    img=6,
    width=8,
    height=7,
    updatePattern="returnBack"
}
stats["nut"] = {
    speed=300,
    damage=10,
    life=3,
    img=7,
    width=5,
    height=3,
}

stats["rocks"] = {
    speed=5,
    damage=20,
    life=10,
    xoffset=0,
    yoffset=1,
    width=8,
    height=6,
    img=2,
    updatePattern = "bigRotateAround"
}

stats["hammers"] = {
    speed=150,
    damage=15,
    life=6,
    img=5,
    width=8,
    height=4,
    
    
}
stats["magic_bullet_boss"] = {
    speed=500,
    damage=12,
    life=8,
    img=4,
    width=7,
    height=4,
    updatePattern = "returnBack"
}
stats["Club"] = {
    speed=700,
    damage=20,
    life=1,
    xoffset=0,
    yoffset=1,
    width=8,
    height=6,
    img=2,
    updatePattern = "speedUp"
}
return stats