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

BLOCK_MOVE_SPEED = 3


--------------------------------------------------------------------------------
-- Modules

util = require 'util'
Level = require 'level'
Block = require 'block'
Player = require 'player'


--------------------------------------------------------------------------------
-- Main Love callbacks

local levels, levelIndex

function win()
    levelIndex = levelIndex + 1
end

local winFont = love.graphics.newFont(92)

function love.load()
    levelIndex = 1

    levels = {
        -- Basic movement

        Level.create({}, { -- How to win?
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            ' P          WWWWW ',
            'BBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBB',
        }),

        Level.create({}, { -- How to jump?
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '             WWWWW ',
            '            BBBBBBB',
            '                  ',
            ' P         ',
            'BBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBBB',
        }),

        Level.create({}, { -- How to double jump?
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '             WWWWW ',
            '            BBBBBBB',
            '                  ',
            '                  ',
            '                  ',
            ' P         ',
            'BBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBB',
        }),


        -- Mover blocks

        Level.create({}, {
            '                         ',
            '                         ',
            '                         ',
            '                    WWWW ',
            '                BBBBBBBBB',
            '                         ',
            '                         ',
            '                         ',
            '                         ',
            '                         ',
            '                         ',
            '                         ',
            '                         ',
            '  P                      ',
            'BBBBBBBBBBMMMMBBBBBB     ',
        }),

        Level.create({}, {
            'BBBBBBBBB      ',
            'BBBBBBBBB      ',
            '     MMM       ',
            '     MMM       ',
            '      MM       ',
            '      MM       ',
            '      MM       ',
            ' WWW  MM   P   ',
        }),

        Level.create({}, {
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                     BB                               WWWW              ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '                                                                                ',
            '    P                                                                           ',
            '  BBBB     MMMM                                                                 ',
            '           MMMM                                                                 ',
            '           MMMM                                                                 ',
            '                                                                                ',
            'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD',
        }),


        -- Section 1

        Level.create({}, {
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                     MMMMMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                     MMMMMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                     MMMMMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                     MMMMMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                     MMMMMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '                        MMMMM',
            '    DDDDDD              MMMMM',
            '         D              MMMMM',
            '         D              MMMMM',
            '         D              MMMMM',
            '         D              MMMMM',
            '         DDDDDDDD    MMMMMMMM',
            '                D    MMMMMMMM',
            '                D    MMMMMMMM',
            '                D  P MMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
            'BBBBBBBBBBBBBBBBBBBBBMMMMMMMM',
        }),

    --     ------------------------
    --     -- start here -- comment out for no skip
    -- }
    -- levels = {
    --     ------------------------


        -- Various

        Level.create({}, {
            'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMM             MMMMMMM',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMM',
            'BMMMM                       MMMMMMM',
            'BMMMM                       MMMMMMM',
            'BMMMM  P                    MMMMMMM',
            'BMMMM                       MMMMMMM',
            'BMMMMBBBBBMMMMMMMMMMMMMMMMMMMMMMMMM',
            'BMMMMBBBBBMMMMMMMMMMMMM     MMMMMMM',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMM',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMM',
            'BMMMM                       MMMMMMM',
            'BMMMM                       BBBBBBB',
            'BMMMM                  BBBBBMMMMMMM',
            'BMMMM       WWW             MMMMMMM',
        }),


        {
            draw = function()
                love.graphics.scale(1 / G)
                love.graphics.setFont(winFont)
                love.graphics.translate(-winFont:getWidth('i'), 0.5 * -winFont:getHeight())
                love.graphics.setColor(math.random(), math.random(), math.random())
                love.graphics.print('w', -winFont:getWidth('w'), 0)
                love.graphics.setColor(math.random(), math.random(), math.random())
                love.graphics.print('i', 0, 0)
                love.graphics.setColor(math.random(), math.random(), math.random())
                love.graphics.print('n', winFont:getWidth('i'), 0)
            end,
        }
    }
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
        levels[levelIndex]:draw()
    end)
end

function love.update(dt)
    if levels[levelIndex].update then
        levels[levelIndex]:update(dt)
    end
end

function love.keypressed(key)
    if levels[levelIndex].keypressed then
        levels[levelIndex]:keypressed(key)
    end
end
