local Solution = require("utils.solution")
local StringUtils = require("utils.string")
local LinkedList = require("utils.collections").LinkedList
local IterTools = require("utils.itertools")

local Day6 = Solution(6)

---@param list LinkedList
---@param len integer
---@return boolean
local function isStartOfPacket(list, len)
    return IterTools.count(IterTools.unique(list:to_iter('any'))) == len
end

function Day6:star1(input)
    local index = 4
    local chars_iter = StringUtils.chars(input)
    local list = LinkedList()
    for _=1,4 do list:push_back(chars_iter()) end

    while not isStartOfPacket(list, 4) do 
        list:pop_front()
        list:push_back(chars_iter())
        index = index + 1
    end

    return tostring(index)
end

function Day6:star2(input)
    local index = 14
    local chars_iter = StringUtils.chars(input)
    local list = LinkedList()
    for _=1,14 do list:push_back(chars_iter()) end

    while not isStartOfPacket(list, 14) do 
        list:pop_front()
        list:push_back(chars_iter())
        index = index + 1
    end

    return tostring(index)
end

Day6:run()
