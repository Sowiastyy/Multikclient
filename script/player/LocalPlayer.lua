local Player = require("script.player")
print("CLASS", CLASS)
local LocalPlayer = Player:new(0, 0, 80, CLASS)
local client = require("script.client")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")

local cooldownspell = 0
local regenerateMp = 0.2

local typeBullet= {}
typeBullet["Warrior"] = {"warrior_spell", 3, "player", 0.1}
typeBullet["Archer"] = {"archer_spell", 1 , "player" ,0}
typeBullet["Wizard"] = {"wizard_spell", 16 , "click" , 0.3925}

function LocalPlayer:update(dt, LocalBullets)

    Player.update(LocalPlayer, dt)
    LocalPlayer:shoot(LocalBullets, dt)
    if LocalPlayer.id then
        LocalPlayer.hero=CLASS
        client:send(LocalPlayer:toString())
    end

    if cooldownspell <= 0 and self.mp >= 50 then
        if love.keyboard.isDown("space") then
            self.mp = self.mp - 50
            cooldownspell = 3
            local x, y = love.mouse.getPosition( )
            local attackFrom = {}
            attackFrom["player"] = {self.x,self.y}
            attackFrom["click"] = {self.x + x - 0.5*love.graphics.getWidth(), self.y + y - love.graphics.getHeight()*0.5} 

            local angle = Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
            local bullet = Bullet:new( attackFrom[typeBullet[self.hero][3]][1], attackFrom[typeBullet[self.hero][3]][2] , angle, "plr|"..self.id, typeBullet[self.hero][1])
            local bullets = Attack(bullet, "shotgun", {count=typeBullet[self.hero][2], spread=typeBullet[self.hero][4]}) 
            for _, bullet in ipairs(bullets) do
                client:send(bullet:toString())
                table.insert(LocalBullets, bullet)
            end
        end
    else
        cooldownspell = cooldownspell - dt
    end
    

    if regenerateMp <= 0 and self.maxMp>self.mp then
        self.mp = self.mp +1
        regenerateMp = 0.2
    else
        regenerateMp = regenerateMp - dt
    end
    
end

return LocalPlayer