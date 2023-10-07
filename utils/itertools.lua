local collections = require("utils.collections")
local Stack = collections.Stack
local Set = collections.Set

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
---@return fun(): T
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


---@param iter fun(): any
---@return integer
local function count(iter)
    local c = 0
    for _ in iter do
        c = c + 1
    end
    return c
end

---Returns an iterator of all unique elements in the iterator
---@generic T
---@param iter fun(): T
---@return fun(): T
local function unique(iter)
    local set = Set()
    local function unique_iter()
        local next_val = iter()
        if next_val == nil then return nil end
        if set:contains(next_val) then return unique_iter() end
        set:push(next_val)
        return next_val
    end
    return unique_iter
end

---@generic T: number | integer
---@param iter fun(): T
---@return T
local function sum(iter)
    local sum = 0
    for v in iter do
        sum = sum + v
    end
    return sum
end

---filter out false values
---@generic T
---@param iter fun(): T
---@param predicate fun(item: T): boolean
---@return fun(): T
local function filter(iter, predicate)
    local function filter_iter()
        local next_val = iter()
        if next_val == nil then return nil end
        if predicate(next_val) then
            return next_val
        end
        return filter_iter()
    end
    return filter_iter
end


return {
    chunk = chunk,
    collect = collect,
    reverse = reverse,
    from_array = from_array,
    enumerate = enumerate,
    count = count,
    unique = unique,
    sum = sum,
    filter = filter,
}