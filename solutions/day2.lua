local Solution = require("utils.solution")
local Class = require("utils.class")
local Utils = require("utils.utils")

---@type Solution
local Day2 = Solution(2)

function Day2:star1(input)
    local totalScore = 0
    for line in Utils.lines(input) do
        ---@type Match
        local match = Match(line)
        totalScore = totalScore + match:score_from_move()
    end
    return tostring(totalScore)
end

function Day2:star2(input)
    local totalScore = 0
    for line in Utils.lines(input) do
        ---@type Match
        local match = Match(line)
        totalScore = totalScore + match:score_from_output()
    end
    return tostring(totalScore)
end

---@class Match
---@field opponent_move OpponentMove
---@field my_move MyMove
Match = Class()

function Match:constructor(input_line)
    local chars = input_line:gmatch("%S+")
    self.opponent_move = OpponentMove(chars())
    self.my_move = chars()
end


function Match:score_from_move()
    local myscore = score_from_move(self.my_move)
    local outcomeScore = (myscore - self.opponent_move.move + 1) % 3 * 3
    return outcomeScore + myscore
end

---Get score given X Y Z means the outcome of game
function Match:score_from_output()
    local outcomeScore = score_from_outcome(self.my_move)
    
    local offset = (outcomeScore / 3) - 1
    local myscore = (self.opponent_move.move + offset - 1) % 3 + 1
    return myscore + outcomeScore
end

---@class OpponentMove
---@field move MoveScore
OpponentMove = Class()

---@alias MoveScore
---| 1 rock
---| 2 paper
---| 3 scissors

---@alias OutcomeScore
---| 0 loss
---| 3 draw
---| 6 win


---@alias MyMove
---| "X"
---| "Y"
---| "Z"

---Get score given X Y Z means the move I made
---@param my_move MyMove
---@return MoveScore
function score_from_move(my_move)
    if my_move == "X" then
        return 1 --rock
    elseif my_move == "Y" then
        return 2 --paper
    elseif my_move == "Z" then
        return 3 --scissors
    end
    error(string.format("Not a valid move. Expected X|Y|Z but got: %s", my_move))
end

---Get score given X Y Z means the outcome of the game
---@param my_move MyMove
---@return OutcomeScore
function score_from_outcome(my_move)
    if my_move == "X" then
        return 0 --loss
    elseif my_move == "Y" then
        return 3 --draw
    elseif my_move == "Z" then
        return 6 --win
    end
    error(string.format("Not a valid move. Expected X|Y|Z but got: %s", my_move))
end



---@param self OpponentMove
---@param char "A"|"B"|"C"
function OpponentMove:constructor(char)
    if char == "A" then
        self.move = 1
        return
    elseif char == "B" then
        self.move = 2
        return
    elseif char == "C" then
        self.move = 3
        return
    end
end

Day2:run()
