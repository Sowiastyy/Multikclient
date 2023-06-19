local Player = require("script.player")
local LocalPlayer = Player:new(0, 0, 80, "Archer")
local client = require("script.client")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")
local cooldownspell = 0
local regenerateMp = 0.2
function LocalPlayer:update(dt, LocalBullets)
    Player.update(LocalPlayer, dt)
    LocalPlayer:shoot(LocalBullets, dt)
    if LocalPlayer.id then
        client:send(LocalPlayer:toString())
    end
    if cooldownspell <= 0 and self.mp >= 50 then
        if love.keyboard.isDown("space") then
            self.mp = self.mp - 1
            cooldownspell = 1


            local x, y = love.mouse.getPosition( )
            local angle = Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
            local bullet = Bullet:new( self.x + x - 0.5*love.graphics.getWidth(), self.y + y - love.graphics.getHeight()*0.5, 0, "plr|"..self.id, "arrow")
            local bullets = Attack(bullet, "shotgun", {count=16, spread=0.4})
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