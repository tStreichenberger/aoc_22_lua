
---@generic T
---Constructs a Class which has proper type hints attached
---# Usage
---```lua
------@class MyClass
---MyClass = {}
---MyClass = Class("MyClass")
---
---function MyClass:constructor() --[[add fields here]] end
---
---local instance = MyClass()
---```
---@param name `T`
---@return (fun(any..): T) | T
local function Class(name)
    local cls = {}
    -- This makes the class itself useful as a metable for the instances of the class
    -- which allows the instances to use the methods of the class
    cls.__index = cls

    local function initializer(_, ...)
    -- attaches all the methods of the class to the new instance
        local instance = setmetatable({}, cls)
        if cls.constructor then
            -- then calls the user defined constructor
            cls.constructor(instance, ...)
        end
        return instance
    end

    -- makes constructor callables like so: ClassName(...args)
    setmetatable(cls, { __call = initializer })
    
    return cls
end




return Class