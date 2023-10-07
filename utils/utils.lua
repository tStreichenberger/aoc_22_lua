local Mod = {}


local defaultPrintOptions = {
    startingIndent = 0,
    indentStep = 4,
}

---Recursively print table to stdout
---@param t table
---@param opts printOptions?
function Mod.printTable(t, opts)
    opts = opts or defaultPrintOptions
    local indent = opts.startingIndent or defaultPrintOptions.startingIndent
    local increment = opts.indentStep or defaultPrintOptions.indentStep
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(string.rep(" ", indent) .. k .. ":")
            Mod.printTable(v, { startingIndent = indent + increment, indentStep = increment })
        else
            print(string.rep(" ", indent) .. k .. ": " .. tostring(v))
        end
    end
end

---@class printOptions options for pretty printing a table
---@field startingIndent? integer value to start indentation at
---@field indentStep? integer how much to increase indentation with each level of depth

---Read contents of file to string
---@param path string
---@return string contents of file
function Mod.readFileToString(path)
    local file = io.open(path, "r") -- r: read mode
    if not file then error("File Not Found for Path: " .. path) end
    local content = file:read("*a") -- *a: reads the entire file:
    file:close()
    return content
end

---@param path string
---@param content string
function Mod.writeStringToFile(path, content)
    local file = io.open(path, "w") -- w: write mode, create a new file (or overwrite if it exists)
    if not file then error("Could not open file: " .. path) end
    file:write(content)
    file:close()
end

---Read contents of input file for the given day
---@param day integer
---@return string
function Mod.getInput(day)
    local path = string.format("io/day%d/input.txt", day)
    return Mod.readFileToString(path)
end

---write output to correct output file
---@param args {day: integer, sol_num: integer, output: string}
function Mod.writeOutput(args)
    local path = string.format("io/day%d/output%d.txt", args.day, args.sol_num)
    Mod.writeStringToFile(path, args.output)
end

---returns iterator over the lines of the string
---@param string string
---@return fun(): string?, ...unknown
function Mod.lines(string)
    -- This iterator will return an empty new line at the end of the string
    local iterator = string:gmatch("([^\n]*)\n?")

    local curr_line = iterator()
    local next_line

    -- don't return that empty new line
    return function()
        next_line = iterator()
        if next_line ~= nil then
            local to_return = curr_line
            curr_line = next_line
            return to_return
        else
            return nil
        end
    end
end


---parse string as integer. If it was a float we will just floor the num
---@param string string
---@return integer
function Mod.parseInt(string)
    local num = tonumber(string)
    if not num then error("failed to parse int from "..string) end
    return math.floor(num)
end

---Collects an iterator into an array
---@generic T
---@param iter fun(): T, ...unknown
---@return T[]
function Mod.collect(iter)
    local array = {}
    for item in iter do
        table.insert(array, item)
    end
    return array
end


---@generic I
---@generic O
---@param array I[]
---@param func fun(i: I): O
---@return O[]
function Mod.map(array, func)
    local output = {}
    for _, v in ipairs(array) do
        table.insert(output, func(v))
    end
    return output
end

---@generic T
---@param a1 T[]
---@param a2 T[]
---@return T[]
function Mod.concat(a1, a2)
    local new_a = {}
    for _, a in ipairs {a1,a2} do 
        for _, v in ipairs(a) do
            table.insert(new_a, v)
        end
    end
    return new_a
end

return Mod
