local esp = require("modules.esp")

local M = {}

function M.__main()
    print("HUD loaded")
    esp.init()
end

return M
