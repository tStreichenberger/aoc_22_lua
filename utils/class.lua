--- Defines a new class
local function Class()
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