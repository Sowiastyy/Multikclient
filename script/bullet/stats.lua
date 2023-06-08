local stats = {}
stats["basic"] = {
    speed=500,
    damage=10,
    life=1,
    xoffset=0,
    yoffset=3,
    width=8,
    height=2,
    img=1,
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
    damage=40,
    life=1,
    xoffset=0,
    yoffset=1,
    width=8,
    height=6,
    img=2,
}
stats["arrow"] = {
    speed=1000,
    damage=10,
    life=1,
    size=10,
    img=1,
}
stats["magic_bullet"] = {
    speed=1000,
    damage=10,
    life=1,
    size=10,
    img=1,
}
return stats