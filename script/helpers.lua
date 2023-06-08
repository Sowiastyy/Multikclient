function createEntitiesList(inputString)
    local entitiesList = {}
    local currentEntity = ""
    local insideBrackets = false
    
    for i = 1, #inputString do
    local char = inputString:sub(i, i)
    
    if char == "{" then
        insideBrackets = true
    elseif char == "}" then
        table.insert(entitiesList, currentEntity)
        currentEntity = ""
        insideBrackets = false
    else
        if insideBrackets then
        currentEntity = currentEntity .. char
        end
    end
    end
    
    return entitiesList
    end
function updateBullets(bulletTable, dt)
    for key, value in pairs(bulletTable) do
        if value.life>0 then
            value:update(dt)
        else
            table.remove(bulletTable, key)
        end
    end
end

function drawObjectsArray(array)
    for _, value in pairs(array) do
        if value then
            value:draw()
        end
    end
end
