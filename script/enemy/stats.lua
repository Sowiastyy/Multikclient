local stats = {}
stats["testEnemy"] = {
    image = love.graphics.newImage("img/crang_kun.png"),
    speed = 100,
    hp = 200,
    size = 133, 
    width = 133,
    height = 133
}
stats["testBoss"] = {
    image = love.graphics.newImage("img/bossTest.png"),
    speed = 50,
    hp = 2000,
    size = 114,
    width = 114,
    height = 138
}
stats["testBoss2"] = {
    image = love.graphics.newImage("img/cyklop/downwalk.png"),
    speed = 50,
    hp = 2000,
    size = 256,
    width = 256,
    height = 138
}
return stats