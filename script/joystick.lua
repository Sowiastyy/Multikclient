Joystick = {}
Joystick.__index = Joystick

function Joystick.new(x, y, size, max_distance, speed)
    local self = setmetatable({}, Joystick)
    self.x = x
    self.y = y
    self.size = size
    self.angle = 0
    self.distance = 0
    self.speed = speed
    self.max_distance = max_distance
    return self
end
joystick = Joystick(100, 100, 100, 100)
function love.touchpressed(id, x, y, dx, dy, pressure)
    self.x = x
    self.y = y
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    self.distance = math.sqrt((x - self.x)^2 + (y - self.y)^2)
    if self.distance < self.max_distance then
        self.angle = math.atan2(y - self.y, x - self.x)
    else
        self.x = self.x + math.cos(self.angle) * self.speed * love.timer.getDelta()
        self.y = self.y + math.sin(self.angle) * self.speed * love.timer.getDelta()
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    self.angle = 0
    self.distance = 0
end
