local Class = require("utils.class2")
local Utils = require("utils.utils")
local Solution = require("utils.solution")

local Set = require("utils.collections").Set
local StringUtils = require "utils.string"
local IterTools = require("utils.itertools")

---@type Solution
local Day3 = Solution(3)




---@class Rucksack
Rucksack = {}
Rucksack = Class("Rucksack")

function Rucksack:constructor(input_line)
    local len = #input_line
    local firstHalf = input_line:sub(1, len / 2)
    local secondHalf = input_line:sub(len / 2 + 1, len)
    self.firstHalf = Set(Utils.collect(StringUtils.chars(firstHalf)))
    self.secondHalf = Set(Utils.collect(StringUtils.chars(secondHalf)))
end

---get priority of an item
---@param char string
---@return integer
function GetPriority(char)
    local ascii = string.byte(char)
    if ascii > 90 then
        ascii = ascii - 58
    end
    return ascii - 38
end

function Day3:star1(input)
    local sum = 0
    for line in StringUtils.lines(input) do

        local sack = Rucksack(line)

        for val in sack.firstHalf:to_iter("string") do
            if sack.secondHalf:contains(val) then
                sum = sum + GetPriority(val)
                break
            end
        end
    end

    return tostring(sum)
end


function Day3:star2(input)
    local sum = 0
    for lines3 in IterTools.chunk(StringUtils.lines(input), 3) do
        ---@cast lines3 string[]
        local elves = Utils.map(lines3, function(line)
            return Set(Utils.collect(StringUtils.chars(line)))
        end)

        for char in elves[1]:to_iter("string") do
            if elves[2]:contains(char) and elves[3]:contains(char) then
                sum = sum + GetPriority(char)
                break
            end
        end
    end
    return tostring(sum)
end


Day3:run()
