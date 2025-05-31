local inputFile = process.argv[2]
local outputFile = process.argv[3]

if not inputFile or not outputFile then
    print("\n🔧 Usage: luvit builder.lua <input> <output>\n")
    os.exit(1)
end

print("🛠️  Nerve Builder")
print("📂 Input File:  " .. inputFile)
print("📦 Output File: " .. outputFile)
print("")

local included = {}
local output = {}

local function readFile(path)
    if not path:match("%.lua$") then
        path = path .. ".lua"
    end

    local file = io.open(path, "r")
    if not file then
        error("❌ Could not open file: " .. path)
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function resolvePath(requirePath)
    return requirePath:gsub("%.", "/") .. ".lua"
end

local function minify(code)
    code = code:gsub("%-%-.-\n", "\n")
    code = code:gsub("%-%-%[%[.-%]%]", "")
    code = code:gsub("\r", "")
    code = code:gsub("\n%s+", "\n")
    code = code:gsub("%s+\n", "\n")
    code = code:gsub("[ \t]+", " ")
    code = code:gsub("\n+", "\n")
    return code
end

local function addModule(path, origin)
    if included[path] then
        print("🔁 Skipping already included: " .. path)
        return
    end
    included[path] = true

    print("📄 Bundling: " .. path .. (origin and (" (required by " .. origin .. ")") or ""))

    local source = minify(readFile(path))

    source = source:gsub("require%s*%(?%\"([%w%.%_/]+)\"%)?", function(reqPath)
        local resolved = resolvePath(reqPath)
        addModule(resolved, path)
        return string.format("__require[%q]()", resolved)
    end)

    table.insert(output, ("__require[%q] = function()\n%s\nend"):format(path, source))
end

print("🔍 Resolving dependencies...\n")
addModule(inputFile)

print("\n🚀 Appending entry point...")
table.insert(output, ("__require[%q]():__main()"):format(inputFile))

local fs = require("fs")
local json = require("json")

print("📑 Loading metadata from metadata.json...")
local raw = fs.readFileSync("metadata.json")
local metadata = json.decode(raw)

local credits = "--[[\n"
for key, value in pairs(metadata) do
    credits = credits .. string.format("    @%s %s\n", key, value)
end
credits = credits .. "]]--\n\n"

print("📦 Packing final script...\n")
local finalScript = credits ..
    minify("local __require = {}") .. ";" ..
    table.concat(output, ";") .. ";"

local file = io.open(outputFile, "w")
file:write(finalScript)
file:close()

print("✅ Compilation complete!")
print("📁 Output written to: " .. outputFile)
