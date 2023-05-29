---@diagnostic disable: missing-parameter, duplicate-set-field
local Player = require("script.player")
local client = require("lib.websocket").new("prosze-dziala.herokuapp.com", 80)
print(client.socket)

LocalPlayer = Player:new(200, 200, 32, {1, 1, 1})
Players = {}

function client:onmessage(s)
    print(s)
    if s:find("YourID=") then
        LocalPlayer.id = tonumber(string.sub(s, 8))
    elseif s:find("Player") then
        local newPlayerData = Player:new(0, 0, 32, {0, 0, 0})
        newPlayerData:fromString(s)
        Players[newPlayerData.id]=newPlayerData
    end
end

function client:onopen()
    if LocalPlayer.id then
        self:send(LocalPlayer:toString())
    end
end

function client:onerror(e)
    print(e)
end

function client:onclose(code, reason)
    print("closecode: "..code..", reason: "..reason)
end

function love.update()
    client:update()
    LocalPlayer:controller(function ()
        client:send(LocalPlayer:toString())
    end)
end

function love.draw()
    LocalPlayer:draw()
    for key, value in pairs(Players) do
        value:draw()
    end
end