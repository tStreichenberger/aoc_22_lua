local IterTools = require("utils.itertools")


x = {"a","b", "c", "d"}

for i, v in IterTools.enumerate(IterTools.from_array(x)) do
    print(i)
    print(v)
end