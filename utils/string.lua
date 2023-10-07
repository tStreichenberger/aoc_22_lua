local Utils = require("utils.utils")
local IterTools = require("utils.itertools")

local Mod = {}

-- Reexport since some files expect lines to still be in Utils
Mod.lines = Utils.lines


---returns an iterator over the chars in a string
---@param string string
---@return fun():string, ...unknown
function Mod.chars(string)
    return string.gmatch(string, ".")
end

---split string on given char or string. Returns an iterator over these splits
---@param string string
---@param char string
---@return fun(): string, ...unknown
function Mod.split(string, char)
    return string:gmatch(string.format("[^%s]+", char))
end


---join iter of string into single string with seperator
---@param iter (fun(): string) | string[]
---@param sep string
---@return string
function Mod.join(iter, sep)
    if type(iter) ~= "table" then
        iter = IterTools.collect(iter)
    end

    return table.concat(iter, sep)
end

return Mod