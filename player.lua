local Player = {}

function Player:create()
    -- Init
    self = self or {}
    setmetatable(self, { __index = Player })
    assert(self.level, 'need `level`!')
    self.x = self.x or 0
    self.y = self.y or 0
    self.vx = 0
    self.vy = 0

    -- Add to bump world
    self.bump = {}
    self.level.bumpWorld:add(self.bump, self.x - 0.5, self.y - 0.5, 1, 1)

    return self
end

function Player:draw()
    love.graphics.stacked('all', function()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', self.x - 0.5, self.y - 0.5, 1, 1)
    end)
end

function Player:update(dt)
    self.vy = self.vy + 9.8 * dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Player
