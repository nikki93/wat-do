--------------------------------------------------------------------------------
-- Libraries

local bump = require 'bump' -- 'https://raw.githubusercontent.com/kikito/bump.lua/master/bump.lua'


--------------------------------------------------------------------------------
-- Settings

G = 32 -- Number of pixels a grid unit renders to

W, H = 25, 18.75 -- Number of grid units wide and height the screen is


--------------------------------------------------------------------------------
-- Modules

util = require 'util'
Player = require 'player'


--------------------------------------------------------------------------------
-- Main Love callbacks

local player

function love.load()
    player = Player.create(0, 0)
end

function love.draw()
    love.graphics.stacked('all', function()
        -- Draw everything centered
        love.graphics.translate(
            0.5 * love.graphics.getWidth(),
            0.5 * love.graphics.getHeight())
        love.graphics.scale(32, 32)

        -- Draw white background
        love.graphics.rectangle('fill', -0.5 * W, -0.5 * H, W, H)

        -- Draw player
        player:draw()
    end)
end
