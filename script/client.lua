--local client = require("lib.websocket").new("prosze-dziala.herokuapp.com", 80)
local client = require("lib.websocket").new("localhost", 5001)

function client:onopen()

end

function client:onerror(e)
    print(e)
end

function client:onclose(code, reason)
    print("closecode: "..code..", reason: "..reason)
end

return client
