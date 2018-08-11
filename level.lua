local Level = {}

function Level:create()
    self = self or {}
    setmetatable(self, { __index = Level })
    self.bumpWorld = bump.newWorld(1)
    return self
end

return Level
