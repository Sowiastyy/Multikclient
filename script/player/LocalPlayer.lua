local Player = require("script.player")
local anim8 = require("lib.anim8")
local Bullet = require("script.bullet")
local Attack = require("script.bullet.attack")
local client = require("script.client")
local rawTiles = require("maps/mapa5").layers[1].data
local inventory = require('script.inv')
print("CLASS", CLASS)
local LocalPlayer = Player:new(0, 0, 80, CLASS)
local enemy = require("script.enemy.stats")
local manInSwamp = require("script.player.manInSwamp")
local img = {}
img["Warrior"] = love.graphics.newImage("img/characters/Warrior.png")
img["Archer"] = love.graphics.newImage("img/characters/Archer.png")
img["Wizard"] = love.graphics.newImage("img/characters/Wizard.png")

local cooldownspell = 0
local regenerateMp = 0.2
local regenerateHp = 0.2
local frames = {}
for x = 0, 3 do
    local quad = love.graphics.newQuad(x * 32, 0, 32, 32, img["Warrior"]:getDimensions())
    table.insert(frames, quad)
end
local g = anim8.newGrid(32, 32, img["Warrior"]:getDimensions())
local anim1 = anim8.newAnimation(g('1-4',1), 0.2)

local g = anim8.newGrid(32, 21, img["Warrior"]:getDimensions())
local anim2 = anim8.newAnimation(g('1-4',1), 0.2)

local animation = anim1
local offsetX = 40
local offsetY = 40
local dupa = 0

local old_armor =  ""
local def_based = 0

local spd_based = 500
LocalPlayer.z = 0
local typeBullet= {}
typeBullet["Warrior"] = {"warrior_spell", 3, "player", 0.1, "warrior", 1}
typeBullet["Archer"] = {"archer_spell", 1 , "player" ,0 , "arrow", 4}
typeBullet["Wizard"] = {"wizard_spell", 16 , "click" , 0.3925, "wizard", 2}

function LocalPlayer:update(dt, LocalBullets)
    inventory:setPlayerEquipment(LocalPlayer)
    if self.weapon then
        --print(self.weapon.bulletType)
    end
    
    LocalPlayer:shoot(LocalBullets, dt)
    if LocalPlayer.id then
        LocalPlayer.hero=CLASS
        client:send(LocalPlayer:toString())
    end
    
    
    LocalPlayer:regenerating(dt)
    LocalPlayer:lvlUp()
    LocalPlayer:useSpell(LocalBullets, dt)
    self:controller()
    LocalPlayer:speedChange()
    LocalPlayer:armorChanged()
    animation:update(dt)
    self:draw()
    
    
end

function LocalPlayer:xpAdd(x, y, type)
    x = tonumber(x)
    y = tonumber(y)
    if self.x - 1500 < x and self.x + 1500 > x and self.y - 1500 < y and self.y + 1500 > y then
        self.xp = self.xp + enemy[type].xp
    end
    
end

function LocalPlayer:regenerating(dt)
    if regenerateMp <= 0 and self.maxMp>self.mp then
        self.mp = self.mp +1
        regenerateMp = 0.2
    else
        regenerateMp = regenerateMp - dt
    end
    if regenerateHp <= 0 and self.maxHp>=self.hp then
        self.hp = self.hp +1
        regenerateHp = 0.2
        
    else
        regenerateHp = regenerateHp - dt
    end
end

function LocalPlayer:lvlUp()
    if self.xp >= self.maxXp then
        self.xp = self.xp - self.maxXp
        self.lvl = self.lvl + 1
        self.maxXp = (self.lvl + 10)^2

        self.maxHp = self.maxHp + 10
        self.maxMp = self.maxMp + 10

        self.regenatate = self.regenatate - 0.001
        self.dmgMulti = self.dmgMulti + 0.1
        self.dexterity = self.dexterity - 0.001
        spd_based = spd_based + 10
        self.spd = spd_based

        def_based = def_based + 3
        self.def = def_based
        print(self.dexterity, self.spd, self.maxMp, self.maxHp, self.regenatate)
    end
end

function LocalPlayer:useSpell(LocalBullets, dt)
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
end


function LocalPlayer:draw(x, y)
    local drawBar = true
    if y and not x then
        drawBar = false
    end
    x = x or self.x
    y = y or self.y
    x, y = x-(self.size/2), y-(self.size/2)+10
    

    animation:draw(img[self.hero], x-offsetX, y-offsetY, 0, self.rotate, 5)
    local r1 = {
        x = self.x-(self.w/2)+(self.bulletCollisionOffsetX or 0),
        y = self.y-(self.h/2)+(self.bulletCollisionOffsetY or 0),
        w = self.w,
        h = self.h,
        angle = self.angle or 0
    }
    --love.graphics.rectangle("line", r1.x, r1.y, r1.w, r1.h)
    if not drawBar then
        return
    end
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59, 9)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x+((self.size-60)/2)+1, y+self.size+1, 59*(self.hp/100), 9)
    love.graphics.setColor(1, 1, 1)
end

function LocalPlayer:toString()
    return string.format("PLAYER|%d|%d|%d|%f|%d|%s|%d|%d|%d",
        self.id, self.x, self.y, self.hp, self.size, self.hero, self.rotate, animation.position, self.z)
end

---comment
function LocalPlayer:controller()
    local stateChanged = false
    local stateChanged2 = false
    if love.keyboard.isDown("k") then
        print(self.x, self.y)
    end
    if love.keyboard.isDown("h") then
        spd_based = 5000
    else
        spd_based =500
    end
    if love.keyboard.isDown("w") then
        stateChanged=true
        self.vy = -1 * self.spd
    elseif love.keyboard.isDown("s") then
        stateChanged=true
        self.vy = self.spd
    
    else
        self.vy = 0
        stateChanged = false
    end
    if love.keyboard.isDown("a") then
        stateChanged2=true
        self.vx = self.spd * -1
        if love.mouse.isDown(1) == false then
            self.rotate = 5
            offsetX = 40
        end
        
    elseif love.keyboard.isDown("d") then
        stateChanged2=true
        self.vx = self.spd
        if love.mouse.isDown(1) == false then
            self.rotate = -5
            offsetX = -120
        end
    else
        self.vx = 0
        stateChanged2 = false
    end

    if stateChanged == true and stateChanged2 == true then
        self.vx = self.vx /math.sqrt(2)
        self.vy = self.vy /math.sqrt(2)
    end

    if (stateChanged == true or stateChanged2 == true) and love.mouse.isDown(1) == false then
        if animation.position == 3 then
            animation:gotoFrame(1)
        end
    animation:resume()
    
        
        
    elseif love.mouse.isDown(1) == false then
        animation:gotoFrame(1)
        
    end

end

local mobile = false
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
    mobile = true
end
function LocalPlayer:shoot(LocalBullets, dt, condition, presetAngle)
    if condition or (love.mouse.isDown(1) and not mobile)then
        if animation.position == 1 then
            animation:gotoFrame(3)
        end
        animation:resume()
        dupa = dupa - dt
        if dupa<0 then
            local x, y = love.mouse.getPosition( )
            local angle =  Bullet:getAngle(0.5*love.graphics.getWidth(), love.graphics.getHeight()*0.5, x, y )
            if mobile then
                angle = presetAngle
            end

            local bullet = Bullet:new(self.x, self.y, angle, "plr|"..THIS_ID, "nut" )
            local bullets = Attack(bullet, "shotgun", {count=1 , spread=0.1})
            if self.weapon then
                local bullet = Bullet:new(self.x, self.y, angle, "plr|"..THIS_ID, self.weapon.bulletType )
                bullets = Attack(bullet, "shotgun", {count=self.weapon.count , spread=0.1})
            end
            
            for _, bullet in ipairs(bullets) do
                client:send(bullet:toString())
                table.insert(LocalBullets, bullet)
            end
            dupa = self.dexterity
            

            if 1.6>angle and angle>-1.6 then
                self.rotate = -5
                offsetX = -120
            else
                self.rotate = 5
                offsetX = 40
            end 
        end
    else
       --[[ animation:pause()
        animation:gotoFrame(1)]]--
    end
end

local speedUp = {12,13,14,15,16,20,21,22,23,24,29,30} -- kafelki piachu 
local slowDown = {3}
function LocalPlayer:speedChange()
    local x = math.floor(self.x/64)
    local y = math.floor(self.y/64)+1
    
    for key, value in pairs(speedUp) do
        if rawTiles[1+(y*500+x)] == value  then
           self.spd = spd_based * 1.4
           
           break;
        elseif rawTiles[1+(y*500+x)] == slowDown[key] then
            self.spd = spd_based * 0.6
            animation = anim2
            offsetY = 28
            
            break;
        else
            offsetY = 40
            animation = anim1
            self.spd = spd_based
        end
    end

    animation, offsetY = manInSwamp:setOffsetAndFrame(self.x,self.y,anim1,anim2)
    
end


function LocalPlayer:armorChanged()
    if self.armor then
        if old_armor ~= self.armor.name then
            self.def = def_based + self.armor.def
        end
        old_armor = self.armor.name
    end
   
end
return LocalPlayer