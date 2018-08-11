local Player = {}

function Player:create()
    -- Init
    self = self or {}
    setmetatable(self, { __index = Player })
    assert(self.level, 'need `level`!')
    self.x, self.y = self.x or 0, self.y or 0

    self.isPlayer = true

    self.vx, self.vy = 0, 0

    self.tryLeft, self.tryRight = false, false

    self.canDoubleJump = false

    -- Add to bump world
    self.level.bumpWorld:add(self, self.x - 0.5, self.y - 0.5, 1, 1)

    return self
end

function Player:draw()
    love.graphics.stacked('all', function()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', self.x - 0.5, self.y - 0.5, 1, 1)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('line', self.x - 0.5, self.y - 0.5, 1, 1)
    end)
end

function Player:update(dt)
    -- Be pushed by mover blocks
    do
        local dp = BLOCK_MOVE_SPEED * dt
        local querySize = 1 + dp
        local movers = self.level.bumpWorld:queryRect(
            self.x - 0.5 * querySize, self.y - 0.5 * querySize, querySize, querySize,
            function(obj) return obj.isMover end)
        local dx, dy = 0, 0
        for _, mover in ipairs(movers) do
            if mover.moveDirX ~= 0 then
                dx = mover.moveDirX * BLOCK_MOVE_SPEED * dt
            end
            if mover.moveDirY ~= 0 then
                dy = mover.moveDirY * BLOCK_MOVE_SPEED * dt
            end
        end
        self.x = self.x + dx
        self.y = self.y + dy
        self.level.bumpWorld:update(self, self.x - 0.5, self.y - 0.5)
        local floors = self.level.bumpWorld:queryRect(
            self.x - 0.5, self.y - 0.5, 1, 1,
            function(obj) return obj.isFloor end)
        if #floors > 0 then
            self.level:die()
            return
        end
    end

    -- Update vx
    self.vx = 0
    if not (self.tryLeft and self.tryRight) then
        if self.tryLeft then
            self.vx = -PLAYER_RUN_SPEED
        end
        if self.tryRight then
            self.vx = PLAYER_RUN_SPEED
        end
    end

    -- Integrate acceleration
    self.vy = self.vy + PLAYER_GRAVITY * dt

    -- Apply velocity, move, recalculate new velocity
    local newX, newY, cols = self.level.bumpWorld:move(
        self, self.x - 0.5 + self.vx * dt, self.y - 0.5 + self.vy * dt)
    newX = newX + 0.5
    newY = newY + 0.5
    self.vx = (newX - self.x) / dt
    self.vy = (newY - self.y) / dt
    self.x, self.y = newX, newY

    -- Notify any mover blocks we've run into
    for _, col in ipairs(cols) do
        if col.other.isMover then
            col.other:setMoveDir(col.normal.x, col.normal.y)
        end
    end

    -- Figure out whether we can double jump now
    self.canDoubleJump = self.canDoubleJump or self:_floored()
end

function Player:_floored()
    local items = self.level.bumpWorld:queryRect(
        self.x - 0.5, self.y - 0.5 + PLAYER_FLOOR_CHECK_THRESHOLD, 1, 1,
        function(obj) return obj.isFloor end)
    return #items > 0
end

function Player:tryJump()
    local canJump
    if self:_floored() then
        canJump = true
    elseif self.canDoubleJump then
        self.canDoubleJump = false
        canJump = true
    end
    if canJump then
        self.vy = -PLAYER_JUMP_SPEED
    end
end

return Player
