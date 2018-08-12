--------------------------------------------------------------------------------
-- Libraries

bump = require 'bump' -- 'https://raw.githubusercontent.com/kikito/bump.lua/master/bump.lua'
moonshine = require 'moonshine'


--------------------------------------------------------------------------------
-- Settings

G = 24 -- Number of pixels a grid unit renders to

W, H = 35, 25 -- Number of grid units wide and height the screen is

PLAYER_GRAVITY = 50
PLAYER_JUMP_SPEED = 21
PLAYER_RUN_SPEED = 16
PLAYER_FLOOR_CHECK_THRESHOLD = 0.1 -- How far from feet to look when checking for floors?
PLAYER_MAX_SPEED = 28

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

local winFont = love.graphics.newFont(150)
local titleFont = love.graphics.newFont(128)
local enterFont = love.graphics.newFont(78)

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    levelIndex = 1

    levels = {
        {
            draw = function()
                love.graphics.translate(-0.4 * W, -0.25 * H)

                love.graphics.scale(1 / G)

                love.graphics.setFont(titleFont)
                local titleText = 'wat do?!'
                for i = 1, #titleText do
                    local char = titleText:sub(i, i)
                    local soFar = titleText:sub(1, i - 1)
                    love.graphics.setColor(0.6 * math.random(), 0.2 * math.random(), 0.6 * math.random())
                    love.graphics.print(titleText:sub(i, i), winFont:getWidth(soFar), 0)
                end

                love.graphics.translate(0.1 * W * G, 0.4 * H * G)

                love.graphics.setFont(enterFont)
                local enterText = 'ENTER!!'
                for i = 1, #enterText do
                    local char = enterText:sub(i, i)
                    local soFar = enterText:sub(1, i - 1)
                    love.graphics.setColor(0.2 * math.random(), 0.2 * math.random(), 0.2 * math.random())
                    love.graphics.print(enterText:sub(i, i), winFont:getWidth(soFar), 0)
                end
            end,

            keypressed = function(self, key)
                if key == 'return' then
                    win()
                end
            end,
        },

        -- Basic movement

        Level.create({}, { -- How to win?
            'BBBBBBBBBBBBBBBBBB',
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
            'BBBBBBBBBBBBBBBBBBB',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '                  ',
            '             WWWWW',
            '            BBBBBB',
            '                  ',
            ' P         ',
            'BBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBBB',
        }),

        Level.create({}, { -- How to double jump?
            'BBBBBBBBBBBBBBBBBBB',
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
            'BBBBBBBBBBBBBBBBBBB',
        }),


        -- Mover blocks

    --     ------------------------
    --     -- start here -- comment out for no skip
    -- }
    -- levels = {
    --     ------------------------

        Level.create({}, {
            'BBBBBBBBBBBBBBBBBBBBBBBBB',
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
            'BBBBBBBBBBMMMMBBBBBB     ',
        }),

        Level.create({}, {
            'BBBBBBBBBBBBBBB',
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
            'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
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
            'BBBBBBBB',
            'D      B',
            'D      B',
            'D      B',
            'DWWB   B',
            'DBBB   B',
            'D      B',
            'D      B',
            'D      B',
            'D      B',
            'D   DDDB',
            'D   BBBB',
            'D   BBBB',
            'D   BBBB',
            'D   BBBB',
            'D   MMMM',
            'D       ',
            'D       ',
            'D       ',
            'D       ',
            'DBBB    ',
            'D       ',
            'D       ',
            'D       ',
            'D       ',
            'D  BBBBB',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D  BMMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D   MMMM',
            'D  MMMMM',
            'D  MMMMM',
            'D  MMMMM',
            'D PMMMMM',
            'BBBMMMMM',
            'BBBBBBBB',
            'BBBBBBBB',
        }),


        -- Various

        Level.create({}, {
            'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMM             MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMM                       MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMM                       MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMM  P                    MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMM                       MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMBBBBBMMMMMMMMMMMMMMMMMMMMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMBBBBBMMMMMMMMMMMMM     MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMBBBBBBBBBBBBBBB',
            'BMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMBBBBBBBBBBBBBBB',
            'BDDDDDDDDDDDDDDDDD          DDDDDDDBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD    MM    BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD       MMMBBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD                           BBBBB',
            'BBBBBBBBBBBBBBBBBD                           BBBBB',
            'BBBBBBBBBBBBBBBBBD                           BBBBB',
            'BBBBBBBBBBBBBBBBBD                           BBBBB',
            'BBBBBBBBBBBBBBBBBD          DDDDDDDDDDDDDDWWWBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBD          BBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBDDDDDDDDDDDBBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBDDDDDDDDDDDBBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBDDDDDDDDDDDBBBBBBBBBBBBBBBBBBBBBB',
            'BBBBBBBBBBBBBBBBBDDDDDDDDDDDBBBBBBBBBBBBBBBBBBBBBB',
        }),


        {
            draw = function()
                love.graphics.scale(1 / G)
                love.graphics.setFont(winFont)
                love.graphics.translate(-0.5 * winFont:getWidth('i'), 0.5 * -winFont:getHeight())
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

local effect = moonshine(moonshine.effects.glow)
    .chain(moonshine.effects.posterize)
    -- .chain(moonshine.effects.glow)
    .chain(moonshine.effects.vignette)

effect.glow.strength = 2.2

effect.vignette.opacity = 0.2
-- effect.vignette.color = { 0.7, 0, 0.2 }

effect.posterize.num_bands = 5

function love.draw()
    effect(function()
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
    end)
end

function love.update(dt)
    if levels[levelIndex].update then
        levels[levelIndex]:update(dt)
    end
end

function love.keypressed(key, sc, isRepeat)
    if isRepeat then return end
    if levels[levelIndex].keypressed then
        levels[levelIndex]:keypressed(key)
    end
end
