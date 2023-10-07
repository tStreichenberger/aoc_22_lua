local Class = require("utils.class")
local Utils = require("utils.utils")
local Solution = require("utils.solution")

---@type Solution
local Day1 = Solution(1)


function Day1:star1(input)

    local elves = getAllElvesSorted(input)

    return tostring(elves[1].total_cal)
end



function Day1:star2(input)
    local elves = getAllElvesSorted(input)

    local total_cals = 0
    for i = 1, 3 do
        total_cals = total_cals + elves[i].total_cal
    end

    return tostring(total_cals)
    
end



---Parses all elves from input and returns them as an array in descending order
---@param input string
---@return Elf[]
function getAllElvesSorted(input)
    ---@type Elf[]
    local elves = {}

    local current_elf = Elf()
    for line in Utils.lines(input) do
        local current_cals = tonumber(line)

        if not current_cals then
            -- empty line time to make new elf
            table.insert(elves, current_elf)
            current_elf = Elf()
        else
            -- calories on line so we can add to elf
            local calories = math.floor(current_cals)
            current_elf:add_cals(calories)
        end
    end

    table.sort(elves, function(a,b) return a >= b end) -- the closure makes it sort in descending order
    return elves
end


---@class Elf
---@field total_cal integer Number of total calories of the elf
Elf = Class()

function Elf:constructor()
    self.total_cal = 0
end

---@param cals integer
function Elf:add_cals(cals)
    self.total_cal = self.total_cal + cals
end

---Used to overload < operator on elves. Compare by calories
---@param other Elf
---@return boolean
function Elf:__lt(other)
    return self.total_cal < other.total_cal
end

Day1:run()