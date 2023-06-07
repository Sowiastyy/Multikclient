local Joystick = {}
Joystick.__index = Joystick

function Joystick.new(x, y, size, max_distance, speed)
    local self = setmetatable({}, Joystick)
    self.x = x
    self.y = y
    self.size = size
    self.angle = 0
    self.distance = 0-- Set the distance to the inner circle size
    self.speed = speed
    self.max_distance = max_distance
    self.inner_size = size / 2
    return self
end

function Joystick:touchpressed(id, x, y, dx, dy, pressure)
    local touch_dx, touch_dy = x - self.x, y - self.y
    local touch_distance = math.sqrt(touch_dx^2 + touch_dy^2)
    if touch_distance <= self.max_distance then
        self:touchmoved(id, x, y, dx, dy, pressure)
    end
end
local actualID =0
function Joystick:touchmoved(id, x, y, dx, dy, pressure)
    local touch_dx, touch_dy = x - self.x, y - self.y
    local touch_distance = math.sqrt(touch_dx^2 + touch_dy^2)
    if touch_distance <= self.max_distance+(self.inner_size/2) then
        if touch_distance > self.inner_size/2 then
            self.distance = touch_distance - self.inner_size
            actualID=id
            self.angle = math.atan2(touch_dy, touch_dx)
        else
            self.distance = 0
            self.angle = 0
        end
    elseif actualID==id  then
        self.distance = 0
        self.angle = 0
    end
end

function Joystick:touchreleased(id, x, y, dx, dy, pressure)
    local touch_dx, touch_dy = x - self.x, y - self.y
    local touch_distance = math.sqrt(touch_dx^2 + touch_dy^2)
    if touch_distance <= self.max_distance+(self.inner_size/2) then
        self.distance = 0 -- Set the distance to the inner circle size
        self.angle = 0
    end
end

function Joystick:draw()
    love.graphics.circle("line", self.x, self.y, self.max_distance)
    local inner_x = self.x-self.inner_size + math.cos(self.angle) * (self.distance + self.inner_size)
    local inner_y = self.y + math.sin(self.angle) * (self.distance + self.inner_size)
    love.graphics.circle("fill", inner_x, inner_y, self.inner_size)
end



return Joystick
