local Utils = require("utils.utils")

---@type string?
local day = arg[1]

local function cliError(message)
    print(message)
    os.exit(1)
end

if not day then
    return cliError("Did not provide day. Call like: `luajit main.lua [day num]`")
end


local day_int = Utils.parseInt(day)

if not day_int then
    return cliError(string.format("failed to parse day: (%s) as integer", day))
end


local path = string.format("solutions/day%d.lua", day_int)

-- Check if the file exists before trying to execute it
if not io.open(path, "r") then
    return cliError(string.format("Day %d has not been initialized", day_int))
end


dofile(path)