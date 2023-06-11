local Game = {
    object = {
        
    }
}
function Game:update(dt)
    for i, object in ipairs(self.objects) do
        object:update(dt)
    end
end

function Game:draw()
    for i, object in ipairs(self.objects) do
        object:draw()
    end
end

return Game
