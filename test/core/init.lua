local esp = require("test.modules.esp")
local aimbot = require("test.modules.aimbot")

local M = {}

function M.__main()
    print("Init loaded")
    esp.init()
    aimbot.init()
    print("Modules initialized")
end

return M
