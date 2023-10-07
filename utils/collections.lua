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

---@return integer
function Set:len()
    local i = 0
    for _ in self:to_iter('any') do
        i = i + 1
    end
    return i
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


---@class Node
---@field prev Node?
---@field next Node?
local Node = {}
---@diagnostic disable-next-line
Node = Class("Node")

function Node:constructor(val)
    self.val = val
end

---@param node Node
function Node:setNext(node)
    self.next = node
end

---@param node Node
function Node:setPrev(node)
    self.prev = node
end

---@return boolean
function Node:isEnd()
    return self.next == nil
end

---@return boolean
function Node:isBegining()
    return self.prev == nil
end




---@class LinkedList
---@field len integer
---@field first Node?
---@field last Node?
local LinkedList = {}
---@diagnostic disable-next-line
LinkedList = Class("LinkedList")

---@generic T
---@param maybe_array T[]?
function LinkedList:constructor(maybe_array)
    if maybe_array == nil then
        self.first = nil
        self.last = nil
        self.len = 0
        return
    end
    --TODO:
end

---@param val any
function LinkedList:push_back(val)
    local node = Node(val)
    if self.last == nil then
        -- In this case the list was empty
        self.first = node
        self.last = node
    else
        self.last:setNext(node)
        node:setPrev(self.last)
        self.last = node
    end
    self.len = self.len + 1
end

---@return any?
function LinkedList:pop_back()
    local last = self.last
    if last == nil then
        return nil
    end
    local second_to_last = last.prev;
    if second_to_last == nil then
        -- list is now empty
        self.first = nil
        self.last = nil
    else
        second_to_last.next = nil
        self.last = second_to_last
    end
    self.len = self.len - 1
    return last.val
end

---@param val any
function LinkedList:push_front(val)
    local node = Node(val)
    local first = self.first
    if first == nil then
        -- array was empty
        self.first = node
        self.last = node
    else
        first:setPrev(node)
        node:setNext(node)
        self.first = node
    end
    self.len = self.len + 1
end

---@return any?
function LinkedList:pop_front()
    local first = self.first
    if first == nil then
        return nil
    end

    local second_from_front = first.next
    if second_from_front == nil then
        -- the array is now empty
        self.first = nil
        self.last = nil
    else
        second_from_front.prev = nil
        self.first = second_from_front
    end
    self.len = self.len - 1
    return first.val
end

function LinkedList:__len()
    return self.len
end

---@param i integer
---@return any?
function LinkedList:get(i)
    local current = self.first

    while i ~= 1 do
        if current == nil then
            return nil
        end
        current = current.next
        i = i - 1
    end
    return current
end

---@generic T
---@param type `T`
---@return fun(): T
function LinkedList:to_iter(type)
    local current = self.first
    return function()
        if current == nil then return nil end
        local to_ret = current
        current = current.next
        return to_ret.val
    end
end


---@generic T
---@param type `T`
---@return fun(): T
function LinkedList:to_iter_rev(type)
    local current = self.last
    return function()
        if current == nil then return nil end
        local to_ret = current
        current = current.prev
        return to_ret.val
    end
end

---@param val any
---@return boolean
function LinkedList:contains(val)
    for elem in self:to_iter("any") do
        if elem == val then return elem end
    end
    return false
end

---@class CollectionsModule Module That included many types of collection classes
return {
    Set = Set,
    Stack = Stack,
    LinkedList = LinkedList,
}