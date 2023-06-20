local MobileController = {}
MobileController.__index = MobileController
local function distance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
end

function MobileController:new(side)
    local controller = {}
    setmetatable(controller, MobileController)
    controller.touchId = nil
    controller.startX = 0
    controller.startY = 0
    controller.angle = 0
    controller.distance = 0 -- Add the distance field and initialize it to 0
    controller.side = side or "left"
    return controller
end

function MobileController:touchPressed(id, x, y)
    if self.side=="left" then
        if x < love.graphics.getWidth() / 2 then
            self.touchId = id
            self.startX = x
            self.startY = y
        end
    else
        if x > love.graphics.getWidth() / 2 then
            self.touchId = id
            self.startX = x
            self.startY = y
        end
    end
end

function MobileController:touchMoved(id, x, y)
    if id == self.touchId then
        local dx = x - self.startX
        local dy = y - self.startY
        self.angle = math.atan2(dy, dx)
        self.distance = distance(self.startX, self.startY, x, y) -- Calculate the distance between the two points
    end
end

function MobileController:touchReleased(id, x, y)
    if id == self.touchId then
        self.touchId = nil
        self.angle = 0
        self.distance = 0 -- Reset the distance to 0 when the touch is released
    end
end
local squareSize = 20
function MobileController:draw()
    if self.touchId then
        love.graphics.rectangle("line", self.startX-(squareSize/2), self.startY-(squareSize/2), squareSize, squareSize) -- Draw the square at the startX and startY coordinates
        local x, y = love.touch.getPosition(self.touchId) -- Get the current position of the finger
        love.graphics.line(self.startX,self.startY, x, y)
        love.graphics.rectangle("fill", x-(squareSize/2), y-(squareSize/2), squareSize, squareSize) -- Draw the square at the finger's coordinates
    end
end


return MobileController
