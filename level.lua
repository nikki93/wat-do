local Level = {}

function Level:create()
    self = self or {}
    setmetatable(self, { __index = Level })
    self.died = false

    self.bumpWorld = bump.newWorld(4)

    self.player = Player.create({
        level = self,
        x = 0,
        y = 0,
    })

    do
        self.blocks = {}
        local hw = math.floor(W / 2)
        for x = -hw, hw do
            table.insert(self.blocks, Block.create({
                level = self,
                x = x,
                y = math.floor(H / 2),
                isMover = x > 4,
            }))
        end
        for x = 7, hw do
            table.insert(self.blocks, Block.create({
                level = self,
                x = x,
                y = 4,
            }))
        end
    end

    return self
end

function Level:die()
    self.died = true
end

function Level:draw()
    for _, block in ipairs(self.blocks) do
        block:draw()
    end

    self.player:draw()
end

function Level:update(dt)
    if self.died then
        self:create()
        return
    end

    for _, block in ipairs(self.blocks) do
        block:update(dt)
    end

    self.player.tryLeft = love.keyboard.isDown('left')
    self.player.tryRight = love.keyboard.isDown('right')
    self.player:update(dt)
end

function Level:keypressed(key)
    if key == 'up' then
        self.player:tryJump()
    end
end

return Level
