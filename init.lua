local Utils = require("utils.utils")


---TODO: do not overwrite files. build into main.lua

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

local init_code = string.format([[local Solution = require("utils.solution")

local Day%d = Solution(%d)

Day%d:run()
]], day_int, day_int, day_int)


Utils.writeStringToFile(path, init_code)


os.execute(string.format("mkdir ./io/day%d", day_int))
Utils.writeStringToFile(string.format("io/day%d/input.txt", day_int), "")
