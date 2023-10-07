local Solution = require("utils.solution")
local Class = require("utils.class2")
local IterTools = require("utils.itertools")
local StringUtils = require("utils.string")
local Utils = require("utils.utils")

local Day4 = Solution(4)

---@class ElfShifts
local Elf = {}
---@diagnostic disable-next-line
Elf = Class("ElfShifts")

---@private
function Elf:constructor(shifts)
    local shifts = IterTools.collect(StringUtils.split(shifts, "-"))
    self.begin = Utils.parseInt(shifts[1])
    self.finish = Utils.parseInt(shifts[2])
end

---returns true if the this self contains the other elf in its shift entirely
---@param other ElfShifts
---@return boolean
function Elf:contains(other)
    return self.begin <= other.begin and self.finish >= other.finish
end

---returns true if self shifts overlaps other shifts at all
---@param other ElfShifts
---@return boolean
function Elf:overlaps(other)
    return self:working_during(other.begin) or
           self:working_during(other.finish) or
           other:working_during(self.begin) or
           other:working_during(self.finish)
end

---returns whether an elf is working during a given shift
---@param shift integer
---@return boolean
function Elf:working_during(shift)
    return shift >= self.begin and shift <= self.finish
end

function Day4:star1(input)
    local overlap = 0
    for line in StringUtils.lines(input) do
        local split = StringUtils.split(line, ",")
        local elf1 = Elf(split())
        local elf2 = Elf(split())
        if elf1:contains(elf2) or elf2:contains(elf1) then overlap = overlap + 1 end
    end
    return tostring(overlap)
end


function Day4:star2(input)
    local overlaps = 0
    for line in StringUtils.lines(input) do
        local split = StringUtils.split(line, ",")
        local elf1 = Elf(split())
        local elf2 = Elf(split())
        if elf1:overlaps(elf2) then overlaps = overlaps + 1 end
    end
    return tostring(overlaps)
end

Day4:run()
