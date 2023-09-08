--fix this bird way of moving, fix this bug of improving
PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.highScores = params.highScores
end

function PlayState:init()
    self.bird = Bird(Skin) --this is first update(later params.bird by letting user choose the bird)
    self.score = 0 --this will be counted by amount of same element coins which will be later added to store
    self.scoreTimer = 0 --this is counting score by amount of seconds lapsed from start

    --this is for keeping tracks of elemental_orbs(orbs)
    self.elementalOrbs = {}
    self.elementalTimer = 0

    --This is keeping track of pipes(obstacles)
    self.pipePairs = {}
    self.timer = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --this is for scoring
    self.scoreTimer = self.scoreTimer + dt

    --because scrolling speed is 30 pixels per second and the block is 16 pixels, I want to
    -- score every block (16 / 30) second is the most optimal one
    if self.scoreTimer > (16 / 30) then 
        self.scoreTimer = 0
        self.score = self.score + 1
    end

    --this is pipes
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair every second and a half
    if self.timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                if self.bird.skin ~= pipe.skin then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                    Skin = 1
                end
            end
        end
    end
    --end pipes

    --this is for elemental_orbs
    self.elementalTimer = self.elementalTimer + dt

    if self.elementalTimer > math.random(10, 15) then --firstly only render orbs 
        self.elementalTimer = 0 --resetting the timer

        local x = self.bird.x + 20 --making random difference in x value
        local y = 0 --always dropping from the top of the screen

        table.insert(self.elementalOrbs, ElementalOrb(x, y)) --inserting this to the table
    end

    for k, orb in pairs(self.elementalOrbs) do
        orb:update(dt)
    end

    --remove the orb if it has exceeded the screen
    for k, orb in pairs(self.elementalOrbs) do
        if orb.y > VIRTUAL_HEIGHT - 16 then
            table.remove(self.elementalOrbs, k)
        end
    end

    --simple collision detection between bird and all elemental_orbs
    for k, orb in pairs(self.elementalOrbs) do
        if self.bird:collides(orb) then
            Skin = orb.skin
            self.bird.skin = orb.skin
            table.remove(self.elementalOrbs, k)
        end
    end
    --end elemental_orbs

    -- update bird based on gravity and input
    self.bird:update(dt)
end

function PlayState:render()
    --Obstacles
    --pipes
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 28)

    self.bird:render()

    --Orbs
    --ElementalOrbs
    for k, orb in pairs(self.elementalOrbs) do
        orb:render()
    end
end

function PlayState:exit()
end