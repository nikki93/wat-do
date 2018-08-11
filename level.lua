local Level = {}

function Level.create()
    local level = setmetatable({}, {
        __index = Level
    })
    level.bumpWorld = bump.newWorld(1)
    return level
end

return Level
