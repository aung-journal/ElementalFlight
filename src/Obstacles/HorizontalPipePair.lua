--[[
    HorizontalPipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]
--this is not working

HorizontalPipePair = Class{}

-- size of the gap between pipes
local GAP_HEIGHT = 90

function HorizontalPipePair:init(y)
    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32 

    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_WIDTH + GAP_HEIGHT)
    }

    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function HorizontalPipePair:update(dt)
    if self.x > -PIPE_HEIGHT then
        self.x = self.x - OBJECT_SCROLL_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end


function HorizontalPipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end