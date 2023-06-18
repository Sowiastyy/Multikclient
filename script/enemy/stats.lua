local stats = {}
stats["testEnemy"] = {
    image = love.graphics.newImage("img/crang_kun.png"),
    speed = 100,
    hp = 200,
    width = 133,
    height = 133
}
stats["testBoss"] = {
    image = love.graphics.newImage("img/bossTest.png"),
    speed = 50,
    hp = 2000,
    width = 114,
    height = 138
}

stats["logger"] = {
    image = love.graphics.newImage("img/characters/loggers.png"),
    hp = 125,
    scale = 4,
    width = 114,
    height = 138
}
return stats