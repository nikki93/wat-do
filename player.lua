local Player = {}

function Player.create(x, y)
    local player = setmetatable({}, {
        __index = Player,
    })
    player.x = x
    player.y = y
    return player
end

function Player:draw()
    love.graphics.stacked('all', function()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', self.x - 0.5, self.y - 0.5, 1, 1)
    end)
end

return Player
