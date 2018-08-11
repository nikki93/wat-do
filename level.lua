local Level = {}

function Level:create()
    self = self or {}
    setmetatable(self, { __index = Level })
    self.bumpWorld = bump.newWorld(4)
    return self
end

return Level
