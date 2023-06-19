local Player = require("script.player")
local LocalPlayer = Player:new(400, 300, 80, "Archer")
local client = require("script.client")
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
            self.mp = self.mp - 50
            cooldownspell = 3
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