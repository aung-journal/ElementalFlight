Bird = Class{}

local GRAVITY = 20

function Bird:init(skin)
    self.skin = Skin
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = BirdWidth
    self.height = BirdHeight

    self.dx = 0
    self.dy = 0

    --particle system that works with fusion orbs, rainbow orbs, etc
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    --array which would be manipulated to change the time the effect lasts
    --default of 5 seconds for default cooldown time of the elemental_orbs
    self.psystemTime = {5, 5}

    --set lifeTime of these particles
    self.psystem:setParticleLifetime(self.psystemTime[1], self.psystemTime[2])

end

function Bird:collides(obstacle)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= obstacle.x and self.x + 2 <= obstacle.x + obstacle.width then
        if (self.y + 2) + (self.height - 4) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height then
            return true
        end
    end

    --this is procedure that lets you know whether the obstacle is ElementalOrb class or not
    --and perform particle system logic based on that orb

    -- Set obstacle's metatable to ElementalOrb metatable
    --setmetatable(obstacle, { __index = ElementalOrb })

    -- Check if obstacle's metatable is the same as ElementalOrb metatable
    -- if getmetatable(obstacle) == ElementalOrb then
    --     --check if the orb is a fusion orb or not

    -- end

    return false
end 

function Bird:update(dt)
    -- Apply gravity
    self.dy = self.dy + GRAVITY * dt

    -- Keyboard input for vertical movement
    if love.keyboard.wasPressed('up') then
        self.dy = -JUMP_POWER
        gSounds['jump']:play()
    elseif love.keyboard.wasPressed('down') then
        self.dy = FALL_SPEED -- Adjust this value for falling speed
    end

    self.y = math.max(0, math.min(VIRTUAL_HEIGHT - 16, self.y + self.dy))
end

function Bird:render()
    love.graphics.draw(gTextures['main'], gFrames['birds'][self.skin], self.x, self.y)
end