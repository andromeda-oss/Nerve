local aimbot = require("test.modules.aimbot")
local M = {}

function M.init()
    print("ESP initialized")
    aimbot.init()
    print("Aimbot initialized in esp module")
end

return M
