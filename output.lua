local __require = {}
__require["modules/esp.lua"] = function()
local M = {}

function M.init()
    print("ESP initialized")
end

return M

end

__require["core/init.lua"] = function()
local esp = __require["modules/esp.lua"]()

local M = {}

function M.__main()
    print("HUD loaded")
    esp.init()
end

return M

end

__require["core/init.lua"]():__main()
