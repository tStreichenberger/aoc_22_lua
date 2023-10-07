local Class = require("utils.class2")

---@class Set
local Set = {}
---@diagnostic disable-next-line
Set = Class("Set")


---@param maybe_array any[]?
function Set:constructor(maybe_array)
    self.inner = {}
    if maybe_array then
        for _, v in ipairs(maybe_array) do
            self:push(v)
        end
    end
end

---@param item any
function Set:push(item)
    self.inner[item] = true
end

---@param item any
---@return boolean
function Set:contains(item)
    return self.inner[item] == true
end


---return an iterator over the values of the set
---@generic T
---@param type `T`
---@return fun(): T, ...unknown
function Set:to_iter(type)
    ---@diagnostic disable-next-line
    return pairs(self.inner)
end


---@class Stack
local Stack = {}
---@diagnostic disable-next-line
Stack = Class("Stack")

---@private
---@param maybe_array any[]?
function Stack:constructor(maybe_array)
    self.inner = {}
    if not maybe_array then
        self.inner = {}
    else
        self.inner = maybe_array
    end
end

---@param elem any
function Stack:push(elem)
    table.insert(self.inner, elem)
end

--- Pops final elem off array
---@return any
function Stack:pop()
    return table.remove(self.inner)
end


---@class CollectionsModule Module That included many types of collection classes
return {
    Set = Set,
    Stack = Stack
}