local shotPattern = {}
local stats = require("script.bullet.stats")
function shotPattern.wrap(bullet)
    if bullet.x < 0 then bullet.x = love.graphics.getWidth() end
    if bullet.x > love.graphics.getWidth() then bullet.x = 0 end
    if bullet.y < 0 then bullet.y = love.graphics.getHeight() end
    if bullet.y > love.graphics.getHeight() then bullet.y = 0 end
end
function shotPattern.stay(bullet)
    bullet.speed=0
end
function shotPattern.slowDown(bullet)
    bullet.speed = stats[bullet.type].speed * bullet.life / stats[bullet.type].life
end
function shotPattern.goFaster(bullet)
    bullet.speed = stats[bullet.type].speed * stats[bullet.type].life/bullet.life
end
function shotPattern.returnBack(bullet)
    if bullet.life < stats[bullet.type].life / 2 and not bullet.hasClicked then
        bullet.angle = bullet.angle + math.pi
        bullet.hasClicked =true
    end
end

function shotPattern.quadratic(bullet)
    local time = stats[bullet.type].life -  bullet.life
    bullet.x = bullet.ox + bullet.vx * time
    bullet.y = bullet.oy + bullet.vy * time + 0.5 * 100 * time^2
end
function shotPattern.sway(bullet)
    local targetX = bullet.x + math.cos(bullet.angle)
    local targetY = bullet.y + math.sin(bullet.angle)

    -- Calculate the current position relative to the target
    local dx = bullet.x - targetX
    local dy = bullet.y - targetY

    -- Calculate the amount to move horizontally and vertically
    local swayX = math.sin(bullet.life * 5) * 2
    local swayY = math.sin(bullet.life * 5 + math.pi / 2) * 1

    -- Update the bullet's position
    bullet.x = targetX + dx + swayX
    bullet.y = targetY + dy + swayY
end

function shotPattern.rotateAround(bullet)
    bullet.angle = bullet.angle + 0.05
    local radius = 50
    bullet.x = bullet.ox + radius * math.cos(bullet.angle)
    bullet.y = bullet.oy + radius * math.sin(bullet.angle)
end

function shotPattern.spiral(bullet)
    if bullet.spiralTime then
        bullet.spiralTime = bullet.spiralTime + 1
    else
        bullet.spiralTime=0
    end

    local radius = 50
    local parentX, parentY = bullet.ox, bullet.oy
    bullet.x = parentX + radius * math.cos(bullet.angle + bullet.spiralTime)
    bullet.y = parentY + radius * math.sin(bullet.angle + bullet.spiralTime)
end
return shotPattern