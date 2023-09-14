--[[
    HorizontalPipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The HorizontalPipe class represents the HorizontalPipes that randomly spawn in our game, which act as our primary obstacles.
    The HorizontalPipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the HorizontalPipes themselves scroll through the game to give the illusion of player movement.
]]
--this is not working

HorizontalPipe = Class{}

function HorizontalPipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 64
    self.y = y

    self.width = PIPE_HEIGHT
    self.height = PIPE_WIDTH

    self.orientation = orientation

    self.skin = math.random(4)
end

function HorizontalPipe:update(dt)
    
end

function HorizontalPipe:render()
    love.graphics.draw(gTextures['tunnels'], gFrames['tunnels'][self.skin], self.x, self.y)
        -- (self.orientation == 'top' and self.y + PIPE_WIDTH or self.y), 
        -- 0, 1, self.orientation == 'top' and -1 or 1)
end