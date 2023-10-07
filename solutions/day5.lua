local Solution = require("utils.solution")
local Stack = require("utils.collections").Stack
local IterTools = require("utils.itertools")
local StringUtils = require("utils.string")
local utils = require("utils.utils")
local Class = require("utils.class2")

local Day5 = Solution(5)

---@param lines_iter fun(): string
---@return Stack[]
local function parse_crates(lines_iter)
    ---@type string[]
    local crates_instructions = {}
    for line in lines_iter do
        if #line == 0 then break end
        table.insert(crates_instructions, line)
    end
    -- remove final row which is just stack index
    table.remove(crates_instructions)

    ---@type Stack[]
    local crates = {}
    -- reverse so we iterate bottom to top
    for row in IterTools.reverse(IterTools.from_array(crates_instructions)) do
        for i, crate in IterTools.enumerate(IterTools.chunk(StringUtils.chars(row), 4)) do
            ---@type string
            local crate_val = crate[2]
            if crate_val == " " then goto continue end

            if crates[i] == nil then crates[i] = Stack() end

            crates[i]:push(crate_val)

            ::continue::
        end
    end

    return crates

end

---@param crates Stack[]
---@param instruction Instruction
local function do_instruction(crates, instruction)
    local from = crates[instruction.from]
    local to = crates[instruction.to]
    for _=1,instruction.amount do
        to:push(from:pop())
    end
end

---@param crates Stack[]
---@param instruction Instruction
local function do_instruction2(crates, instruction)
    local from = crates[instruction.from]
    local to = crates[instruction.to]

    local crane = Stack()
    for _=1,instruction.amount do
        crane:push(from:pop())
    end

    for elem in function() return crane:pop() end do
        to:push(elem)
    end
end


---@class Instruction
local Instruction = {}
---@diagnostic disable-next-line
Instruction = Class("Instruction")


function  Instruction:constructor(stringified_instruction)
    local nums = string.gmatch(stringified_instruction, "[0-9]+")
    self.amount = utils.parseInt(nums())
    self.from = utils.parseInt(nums())
    self.to = utils.parseInt(nums())
end

function Day5:star1(input)
    local lines_iter = StringUtils.lines(input)
    
    local crates = parse_crates(lines_iter)

    for line in lines_iter do
        local instruction = Instruction(line)
        do_instruction(crates, instruction)
    end

    ---@type string[]
    local tops = utils.map(crates, function(crate) return crate:pop() end)

    return StringUtils.join(tops, "")
end



function Day5:star2(input)
    local lines_iter = StringUtils.lines(input)
    
    local crates = parse_crates(lines_iter)

    for line in lines_iter do
        local instruction = Instruction(line)
        do_instruction2(crates, instruction)
    end

    ---@type string[]
    local tops = utils.map(crates, function(crate) return crate:pop() end)

    return StringUtils.join(tops, "")
end





Day5:run()