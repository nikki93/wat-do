local Level = {}

function Level:create(layout)
    self = self or {}
    setmetatable(self, { __index = Level })
    self.died = false

    self.bumpWorld = bump.newWorld(4)

    self.layout = layout

    if not self.layout then -- Default level?
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
    else
        self.player = nil
        self.blocks = {}

        local hw, hh = math.floor(W / 2) + 1, math.floor(H / 2) + 1
        assert(#self.layout == H, 'need `H` lines of layout')
        for i = 1, H do
            local line = self.layout[i]
            assert(#line == W, 'need `W` columns of layout')
            for j = 1, W do
                local char = line:sub(j, j)
                local x, y = j - hw, i - hh

                if char == 'P' then
                    assert(not self.player, 'need max 1 `Player`')
                    self.player = Player.create({
                        level = self, x = x, y = y,
                    })
                elseif char == 'B' then
                    table.insert(self.blocks, Block.create({
                        level = self, x = x, y = y,
                    }))
                elseif char == 'M' then
                    table.insert(self.blocks, Block.create({
                        level = self, x = x, y = y,
                        isMover = true,
                    }))
                end
            end
        end

        assert(self.player, 'need min 1 `Player`')
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
        self:create(self.layout)
        return
    end

    for _, block in ipairs(self.blocks) do
        block.updatedThisFrame = false
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
