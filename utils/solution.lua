local Utils = require("utils.utils")
local Class = require("utils.class2")




---@alias SingleSolution fun(self: Solution, input: string): string

---@class Solution
---@field day integer
---@field star1 SingleSolution
---@field star2 SingleSolution
---@field run fun(self: Solution)




---@type Solution
---@diagnostic disable-next-line
local Mod = {}
---@diagnostic disable-next-line
Mod = Class("Solution")

---@param day integer
---@diagnostic disable-next-line
function Mod:constructor(day)
    self.day = day
end

---@type SingleSolution
function Mod:star1(input)
    return "Unimplemented"
end

---@type SingleSolution
function Mod:star2(input)
    return "Unimplemented"
end



---Read inputs into solutions and write outputs to output files
---@param self Solution
function Mod:run()
    local input = Utils.getInput(self.day)

    print(string.format("\n\nStarting Star 1 of day %d", self.day))
    local output1 = self:star1(input)
    print(string.format("Found Solution: %s", output1))
    Utils.writeOutput {
        day = self.day,
        sol_num = 1,
        output = output1
    }
    
    print(string.format("\n\nStarting Star 2 of day %d", self.day))
    local output2 = self:star2(input)
    print(string.format("Found Solution: %s", output2))
    Utils.writeOutput {
        day = self.day,
        sol_num = 2,
        output = output2
    }


    print(string.format("\n\nFinished Day %d!", self.day))
end



return Mod