--fix this bird way of moving, fix this bug of improving
PlayState = Class{__includes = BaseState}

--finish this not working horizontal pipePairs and rotating pipes

function PlayState:enter(params)
    self.highScores = params.highScores
    self.hearts = params.hearts
    self.score = params.score --this will be counted by amount of same element coins which will be later added to store
end

function PlayState:init()
    self.bird = Bird(Skin) --this is first update(later params.bird by letting user choose the bird)
    self.scoreTimer = 0 --this is counting score by amount of seconds lapsed from start
    self.gold = 0 --amount of golds player own

    --Orbs section
    --this is for gemstone
    self.multiplier = 1
    self.multiplierTimer = 0
    self.multiplierTimerStart = false --if the gemstone has been touched and cooldown has been started or not

    --this is for crystalOrb
    self.shield = false
    self.shieldTimer = 0
    self.shieldWidth = 70
    self.shieldHeight = 70
    self.shieldX = 0
    self.shieldY = 0

    --this is for Speed Boost Orb
    self.speedFactor = 1
    self.speedTimer = 0
    self.speedTimerStart = false

    --this is for Invincibility Orb
    self.invincible = false
    self.invincibleTimer = 0
    self.invincibleTimerStart = false

    --this is for keeping tracks of elemental_orbs(orbs)
    self.elementalOrbs = {}
    self.elementalTimer = 0
    --this is for making timer array for all the timers of all the cooldown orbs
    self.timers = {self.multiplierTimer, self.shieldTimer, self.speedTimer, self.invincibleTimer}
    --this is for making boolean flags array for all the cooldown orbs
    self.flags = {self.multiplierTimerStart, self.shield, self.speedTimerStart, self.invincible}
    self.index = nil

    --This is keeping track of pipes(obstacles)(pillars)
    --horizontal pipes(tunnels)
    self.choose = 0--chosing which object to render

    self.pipePairs = {}
    self.timer = 0
    --The y value for pillars
    self.lastPillarY = -PIPE_HEIGHT + math.random(80) + 20
    --The y value for tunnels
    self.lastTunnelY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --this is for making OBJECT_SCROLL_SPEED(aka player speed) boost by self.speedFactor
    OBJECT_SCROLL_SPEED = 60 * self.speedFactor

    --this is for scoring
    self.scoreTimer = self.scoreTimer + dt

    --because scrolling speed is 30 pixels per second and the block is 16 pixels, I want to
    -- score every block (16 / 30) second is the most optimal one(so this takes account of speed of object for scoring)
    if self.scoreTimer > (16 / (OBJECT_SCROLL_SPEED / 2)) * (1 / self.multiplier) then --this makes the speed faster by increasing 1
        self.scoreTimer = 0
        self.score = self.score + 1
    end


    --this is for elemental_orbs
    self.elementalTimer = self.elementalTimer + dt

    if self.elementalTimer > math.random(10, 15) then --firstly only render orbs 
        self.elementalTimer = 0 --resetting the timer

        local x = self.bird.x + 20 --making some difference in x value
        local y = 0 --always dropping from the top of the screen

        table.insert(self.elementalOrbs, ElementalOrb(x, y)) --inserting this to the table
    end

    for k, orb in pairs(self.elementalOrbs) do
        orb:update(dt)
    end

    --this is for gemstone(multiplierTimer logic)
    if self.multiplierTimerStart then
        self.multiplierTimer = self.multiplierTimer + dt
 
    end

    --this is for making gemstone cooldown time of 5 seconds
    if self.multiplierTimer > 5 then
        --decrease the multiplier as the cooldown is over
        self.multiplier = self.multiplier - 1
        --reset both the timer and cooldown on to be off
        self.multiplierTimer = 0
        self.multiplierTimerStart = false
    end
    --gemstone end

    --this is for making crystalOrb cooldown time of 5 seconds
    if self.shield then
        self.shieldTimer = self.shieldTimer + dt
        self.shieldX = self.bird.x - 10
        self.shieldY = self.bird.y - 23
    end

    if self.shieldTimer > 5 then
        self.shield = false
        self.shieldTimer = 0
    end
    --end gemstone

    --this is for making Speed Boost Orb cooldown time of 5 seconds
    if self.speedTimerStart then
        self.speedTimer = self.speedTimer + dt
    end

    if self.speedTimer > 5 then
        --reduce the speedFactor again
        self.speedFactor = self.speedFactor - 1
        --reset both the cooldown timer and cooldown on
        self.speedTimer = 0
        self.speedTimerStart = false
    end
    --end speed Boost Orb

    --this is for making invincibleOrb cooldown time of 3 seconds
    if self.invincibleTimerStart then
        self.invincibleTimer = self.invincibleTimer + dt
    end

    if self.invincibleTimer > 3 then
        --reset invincibility, timerStarter and timer again
        self.invincible = false
        self.invincibleTimer = 0
        self.invincibleTimerStart = false
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
            --this is for elementalOrbs
            if orb.skin <= 4 then
                Skin = orb.skin
                self.bird.skin = orb.skin
            --this is for gold orbs (which increases the player 's purchasing power)
            elseif orb.skin == 5 then
                self.gold = self.gold + 1
            --this is for gemstone orbs (which is something that makes scoring faster)
            elseif orb.skin == 6 then
                --this increases multipler
                self.multiplier = self.multiplier + 1
                --this makes cooldown logic available
                self.multiplierTimerStart = true
                --reset the timer(to extend its cooldown)
                self.multiplierTimer = 0
            --this is for crystal orb (which protects player from collision of different colored obstacles)
            -- and 1 second of immortality after shield has broken
            elseif orb.skin == 7 then
                self.shield = true
                --reset the timer(if interrupted while the cooldown)
                self.shieldTimer = 0
            --this is for Speed Boost Orb
            elseif orb.skin == 8 then
                --increase the speedFactor by 1 so make x times fast
                self.speedFactor = self.speedFactor + 1
                --this is for starting cooldown logic
                self.speedTimerStart = true
                --reset the timer(extend its cooldown)
                self.speedTimer = 0
            --this is for Invincibility Orb
            elseif orb.skin == 9 then
                --this is making invinciblility on
                self.invincible = true
                self.invincibleTimerStart = true
                --reset the timer if interrupted while cooldown
                self.invincibleTimer = 0
            end
        --removing an orb from rendering or updating if it has been collided
        table.remove(self.elementalOrbs, k)
        end
    end

    --update the timer of cooldown orbs
    for k, flag in pairs(self.flags) do
        if flag then
            self.index = k
        end
    end
    --end elemental_orbs

    --this is pipes
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair every 2 second by default but to get the precise spawning point 
    if self.timer > 2 / self.speedFactor then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        self.choose = math.random(1,2) --this is choosing either horizontal or vertical pipe

        local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastPillarY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastPillarY = y

        -- add a new pipe pair at the end of the screen at our new Y(Pillars)
        table.insert(self.pipePairs, PipePair(y))

        -- if self.choose == 1 then
        --     local y = math.max(-PIPE_HEIGHT + 10, 
        --         math.min(self.lastPillarY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        --     self.lastPillarY = y

        --     -- add a new pipe pair at the end of the screen at our new Y(Pillars)
        --     table.insert(self.pipePairs, PipePair(y))
        -- elseif self.choose == 2 then
        --     local y = math.max(-PIPE_HEIGHT + 10, 
        --         math.min(self.lastTunnelY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        --     self.lastTunnelY = y

        --     -- add a new pipe pair at the end of the screen at our new Y(Pillars)
        --     table.insert(self.pipePairs, HorizontalPipePair(y))
        -- end

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
        local skipToNextPipe = false  -- Flag variable to control flow
    
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                --self.invincible, so that the effect will be on here making collision effects gone
                if self.bird.skin ~= pipe.skin and not self.invincible then
                    if not pipe.collided then  -- Check if the pipe has already been collided with and shield is false
                        if self.shield then
                            self.shield = false
                            gSounds['pop']:play()
                        else
                            self.hearts = self.hearts - 1
                            --play the hurting sound to be realistic
                            gSounds['hurt']:play()
                        end
                        pipe.collided = true  -- Mark the pipe as collided
    
                        if self.hearts == 0 then
                            --reset the speedFactor
                            self.speedFactor = 1
                            gStateMachine:change('game-over', {
                                score = self.score,
                                highScores = self.highScores
                            })
                            Skin = 1
                            skipToNextPipe = true  -- Set the flag to skip to the next pipe
                            break  -- Exit the inner loop
                        end
                    end
                end
            else
                pipe.collided = false  -- Reset the collided state if there is no collision
            end
        end
    
        if skipToNextPipe then
            -- Skip to the next iteration of the outer loop
            goto continue
        end
    
        ::continue::
    end

    --end pipes

    -- update bird based on gravity and input
    self.bird:update(dt)
end

function PlayState:render()
    --Obstacles
    --pipes
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    --this is for rendering menus and game data
    --rendering scores

    if Skin == 4 then
        love.graphics.setColor(0, 0, 255)
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 28)

    --rendering multiplier
    love.graphics.print('Multiplier: ' .. tostring(self.multiplier) .. 'X', 8, 88)

    love.graphics.setColor(1,1,1,1)

    --rendering hearts
    RenderHealth(self.hearts)

    --rendering gold coins
    love.graphics.draw(gTextures['gold'], 8, 60)
    love.graphics.print(':  ' .. tostring(self.gold), 34, 60)

    self.bird:render()

    --Orbs
    --ElementalOrbs
    for k, orb in pairs(self.elementalOrbs) do
        orb:render()
    end

    if Skin == 4 then
        love.graphics.setColor(0, 0, 255)
    end

    --this is for rendering settings changes for every cooldown orbs
    if self.multiplierTimerStart then
        love.graphics.print("Multiplier On", 8, 118)
        love.graphics.print(tostring(5 - self.multiplierTimer), 8, 148)
    end

    if self.shield then
        --this is for crystalOrb shield
        love.graphics.draw(gTextures['shield'], self.shieldX, self.shieldY)
        love.graphics.print("Shield On", 8, 118)
        love.graphics.print(tostring(5 - self.shieldTimer), 8, 148)
    end

    if self.speedTimerStart then
        --RENDERING SPEED
        love.graphics.print("Speed On " .. tostring(self.speedFactor) .. "X", 8, 118)
        love.graphics.print(tostring(5 - self.speedTimer), 8, 148)
    end

    if self.invincible then
        --RENDERING notion of invincibility
        love.graphics.print("Invincibility On", 8, 118)
        love.graphics.print(tostring(3 - self.invincibleTimer), 8, 148)
    end

    --reset color
    love.graphics.setColor(1,1,1,1)
end

function PlayState:exit()
end