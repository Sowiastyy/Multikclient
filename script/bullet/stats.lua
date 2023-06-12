local stats = {}
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
    size=10,
    width=8,
    height=3,
    img=3,
    updatePattern = "slowDown"
}
stats["magic_bullet"] = {
    speed=200,
    damage=12,
    life=5,
    size=10,
    img=4,
    width=7,
    height=4,
    updatePattern = "returnBack"
}
return stats