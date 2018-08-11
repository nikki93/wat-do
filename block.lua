local Block = {}

function Block:create()
    -- Init
    self = self or {}
    setmetatable(self, { __index = Block })
    assert(self.level, 'need `level`!')
    self.x = self.x or 0
    self.y = self.y or 0

    self.isFloor = true

    if self.isMover == nil then
        self.isMover = false
    end

    if self.isMover then
        self.moveDirX = self.moveDirX or 0
        self.moveDirY = self.moveDirY or 0
    end

    -- Add to bump world
    self.level.bumpWorld:add(self, self.x - 0.5, self.y - 0.5, 1, 1)

    return self
end

function Block:draw()
    love.graphics.stacked('all', function()
        if self.isMover then
            love.graphics.setColor(0.93, 0.76, 0.93)
        else
            love.graphics.setColor(0, 0, 1)
        end
        love.graphics.rectangle('fill', self.x - 0.5, self.y - 0.5, 1, 1)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('line', self.x - 0.5, self.y - 0.5, 1, 1)
    end)
end

function Block:update(dt)
    if self.isMover then
        if self.moveDirX ~= 0 or self.moveDirY ~= 0 then
            local newX, newY, cols = self.level.bumpWorld:move(
                self,
                self.x - 0.5 + BLOCK_MOVE_SPEED * self.moveDirX * dt,
                self.y - 0.5 + BLOCK_MOVE_SPEED * self.moveDirY * dt)
            newX = newX + 0.5
            newY = newY + 0.5
            self.x, self.y = newX, newY
        end
    end
end

function Block:setMoveDir(dirX, dirY)
    self.moveDirX, self.moveDirY = dirX, dirY
end

return Block
