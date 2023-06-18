local Player = require("script.player")
local LocalPlayer = Player:new(400, 300, 80, "Archer")
local client = require("script.client")

function LocalPlayer:update(dt, LocalBullets)
    Player.update(LocalPlayer, dt)
    LocalPlayer:shoot(LocalBullets, dt)
    if LocalPlayer.id then
        client:send(LocalPlayer:toString())
    end
end

return LocalPlayer