local Player = {}

function Player.create(props)
    local player = setmetatable({}, {
        __index = Player,
    })
    player.level = assert(props.level, 'need `level`!')
    player.x = props.x or 0
    player.y = props.y or 0
    return player
end

function Player:draw()
    love.graphics.stacked('all', function()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', self.x - 0.5, self.y - 0.5, 1, 1)
    end)
end

return Player
