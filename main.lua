--------------------------------------------------------------------------------
-- Libraries

bump = require 'bump' -- 'https://raw.githubusercontent.com/kikito/bump.lua/master/bump.lua'


--------------------------------------------------------------------------------
-- Settings

G = 24 -- Number of pixels a grid unit renders to

W, H = 35, 25 -- Number of grid units wide and height the screen is

PLAYER_GRAVITY = 50
PLAYER_JUMP_SPEED = 21
PLAYER_RUN_SPEED = 16
PLAYER_FLOOR_CHECK_THRESHOLD = 0.1 -- How far from feet to look when checking for floors?

BLOCK_MOVE_SPEED = 9


--------------------------------------------------------------------------------
-- Modules

util = require 'util'
Level = require 'level'
Block = require 'block'
Player = require 'player'


--------------------------------------------------------------------------------
-- Main Love callbacks

local level

function love.load()
    level = Level.create({}, {
        'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
        'B                                 B',
        'B                                 B',
        'B     P                           B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B     BBBB      BBBBBBB           B',
        'B                                 B',
        'B                                 B',
        'B         MMMMMM                  B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B                                 B',
        'B     M                           B',
        'B     M                           B',
        'B     M                           B',
        'B     M                           B',
        'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
    })
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
        level:draw()
    end)
end

function love.update(dt)
    level:update(dt)
end

function love.keypressed(key)
    level:keypressed(key)
end
