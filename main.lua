--------------------------------------------------------------------------------
-- Libraries

bump = require 'bump' -- 'https://raw.githubusercontent.com/kikito/bump.lua/master/bump.lua'


--------------------------------------------------------------------------------
-- Settings

G = 32 -- Number of pixels a grid unit renders to

W, H = 25, 18.75 -- Number of grid units wide and height the screen is

PLAYER_GRAVITY = 34
PLAYER_JUMP_SPEED = 16


--------------------------------------------------------------------------------
-- Modules

util = require 'util'
Level = require 'level'
Block = require 'block'
Player = require 'player'


--------------------------------------------------------------------------------
-- Main Love callbacks

local player, level, blocks

function love.load()
    level = Level.create()

    player = Player.create({
        level = level,
        x = 0,
        y = 0,
    })

    do
        blocks = {}
        local hw = math.floor(W / 2)
        for x = -hw, hw do
            table.insert(blocks, Block.create({
                level = level,
                x = x,
                y = 4,
            }))
        end
    end
end

function love.draw()
    love.graphics.stacked('all', function()
        -- Draw everything centered
        love.graphics.translate(
            0.5 * love.graphics.getWidth(),
            0.5 * love.graphics.getHeight())
        love.graphics.scale(G, G)

        -- Set clipping bounds
        love.graphics.setScissor(
            0.5 * love.graphics.getWidth() - 0.5 * W * G,
            0.5 * love.graphics.getHeight() - 0.5 * H * G,
            W * G, H * G)

        -- Make lines look 1px wide on screen
        love.graphics.setLineWidth(1 / G)

        -- Draw everything

        love.graphics.rectangle('fill', -0.5 * W, -0.5 * H, W, H)

        for _, block in ipairs(blocks) do
            block:draw()
        end

        player:draw()
    end)
end

function love.update(dt)
    player:update(dt)
end

function love.keypressed(key)
    if key == 'up' then
        player:tryJump()
    end
end
