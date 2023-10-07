local Solution = require("utils.solution")
local Class = require("utils.class2")
local IterTools = require("utils.itertools")
local StringUtils = require("utils.string")
local Utils = require("utils.utils")

local Day7 = Solution(7)


---@class File
local File = {}
---@diagnostic disable-next-line
File = Class("File")


---@param size integer
function File:constructor(size)
    self.size_val = size
end

---@return integer
function File:size()
    return self.size_val
end

---@return "File"
function File:type() return "File" end

---@class Dir
---@field contents {[string]: Dir|File}
local Dir = {}
---@diagnostic disable-next-line
Dir = Class("Dir")

---@param parent Dir
function Dir:constructor(parent)
    self.parent = parent
    self.contents = {}
end

function Dir:size()
    if self.size_val ~= nil then return self.size_val end
    local size = 0
    for _name, content in pairs(self.contents) do
        size = size + content:size()
    end
    self.size_val = size
    return size
end

---@param name string
---@param content Dir|File
function Dir:insert(name, content)
    self.contents[name] = content
end

---@param name string
---@return boolean
function Dir:contains(name)
    return self.contents[name] ~= nil
end

---@return "Dir"
function Dir:type() return "Dir" end

local x =[[
$ cd /
$ ls
dir fchrtcbh
dir hlnbrj
dir jbt
dir nnn
57400 pfqcbp
dir qsdv
dir tdl
dir tmcpgtz
$ cd fchrtcbh
]]

---@param line string
---@param parent_dir Dir
local function parseContentAndInsert(line, parent_dir)
    local split = IterTools.collect(StringUtils.split(line, " "))
    local name = split[2]
    if parent_dir:contains(name) then return end
    if split[1] == "dir" then
        local new_dir = Dir(parent_dir)
        parent_dir:insert(name, new_dir)
    else
        local size = Utils.parseInt(split[1])
        local new_file = File(size)
        parent_dir:insert(name, new_file)
    end
end

---@param input string
---@return Dir
local function constructDirTree(input)
    local lines_iter = StringUtils.lines(input)
    lines_iter()

    local root = Dir(nil)
    local current_dir = root


    for line in lines_iter do
        if StringUtils.chars(line)() == "$" then
            local split = IterTools.collect(StringUtils.split(line, " "))
            if split[2] == "cd" then
                if split[3] == ".." then
                    current_dir = current_dir.parent
                else
                    local name = split[3]
                    ---@type Dir?
                    ---@diagnostic disable-next-line
                    local next_dir = current_dir.contents[name]
                    if next_dir == nil then
                        next_dir = Dir(current_dir)
                        current_dir:insert(name, next_dir)
                    end
                    current_dir = next_dir
                end
            end
        else
            parseContentAndInsert(line, current_dir)
        end
    end


    return root
end


---@param dir Dir
---@return integer[]
local function get_all_sizes(dir)
    local sizes = {}
    for _name, content in pairs(dir.contents) do
        if content:type() == "Dir" then
            ---@cast content Dir
           local sub_sizes = get_all_sizes(content)
           sizes = Utils.concat(sizes, sub_sizes)
        end
    end
    table.insert(sizes, dir:size())
    return sizes
end

function Day7:star1(input)
    local root = constructDirTree(input)
    local sizes = get_all_sizes(root)
    table.sort(sizes)
    sizes = IterTools.collect(IterTools.reverse(IterTools.from_array(sizes)))

    local sum = IterTools.sum(IterTools.filter(IterTools.from_array(sizes), function(size) return size < 100000 end))

    return tostring(sum)
end

function Day7:star2(input)
    local root = constructDirTree(input)
    local sizes = get_all_sizes(root)
    table.sort(sizes)
    -- sizes = IterTools.collect(IterTools.reverse(IterTools.from_array(sizes)))

    local total_size = root:size()
    local space_left = 70000000 - total_size
    local space_needed = 30000000 - space_left

    ---@type integer[]
    local sizes_big_enough = IterTools.collect(IterTools.filter(IterTools.from_array(sizes), function(size) return size > space_needed end))

    return tostring(sizes_big_enough[1])
end

Day7:run()
