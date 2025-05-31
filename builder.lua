local inputFile = process.argv[2]
local outputFile = process.argv[3]

if not inputFile or not outputFile then
    print("Usage: luvit builder.lua <input> <output>")
    os.exit(1)
end

local included = {}
local output = {}

local function readFile(path)
    if not path:match("%.lua$") then
        path = path .. ".lua"
    end

    local file = io.open(path, "r")
    if not file then
        error("Could not open file: " .. path)
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function resolvePath(requirePath)
    return requirePath:gsub("%.", "/") .. ".lua"
end

local function addModule(path, origin)
    if included[path] then return end
    included[path] = true

    local source = readFile(path)

    source = source:gsub("require%s*%(?%\"([%w%.%_/]+)\"%)?", function(reqPath)
        local resolved = resolvePath(reqPath)
        addModule(resolved, path)
        return string.format("__require[%q]()", resolved)
    end)

    table.insert(output, ("__require[%q] = function()\n%s\nend"):format(path, source))
end

addModule(inputFile)

table.insert(output, ("__require[%q]():__main()"):format(inputFile))

local finalScript = [[
local __require = {}
]] .. table.concat(output, "\n\n") .. "\n"

local file = io.open(outputFile, "w")
file:write(finalScript)
file:close()

print("✅ Compiled to " .. outputFile)
