local Stack = require("utils.collections").Stack

---@generic T
---@param iter fun(): T, ...unknown
---@param i integer
---@return fun(): T[]
local function chunk(iter, i)
    return function()
        local chunk = {}
        while #chunk < i do
            local value = iter()
            if value == nil then
                break
            end
            table.insert(chunk, value)
        end
        if #chunk == 0 then
            return nil
        end
        return chunk
    end
end



---Collects an iterator into an array
---@generic T
---@param iter fun(): T, ...unknown
---@return T[]
local function collect(iter)
    local array = {}
    for item in iter do
        table.insert(array, item)
    end
    return array
end


---reverse an iterator
---@generic T
---@param iter fun(): T, ...unknown
---@return fun(): T, ...unknown
local function reverse(iter)
    local stack = Stack(collect(iter))
    return function() return stack:pop() end
end


---@generic T
---@param array T[]
---@return fun(): T, ...unknown
local function from_array(array)
    local p = ipairs(array)
    local index = 0
    return function()
        local _, v = p(array, index)
        index = index + 1
        return v
    end
end



---also returns index. It will be 1 indexed
---@generic T
---@param iter fun(): T
---@return fun(): integer, T
local function enumerate(iter)
    local index = 0
    return function ()
        local val = iter()
        if val == nil then return nil end
        index = index + 1
        return index, val
    end
end


return {
    chunk = chunk,
    collect = collect,
    reverse = reverse,
    from_array = from_array,
    enumerate = enumerate
}