ElementalOrb = Class{}

local ELEMENTAL_SPEED = 3

function ElementalOrb:init(x, y)
    self.skin = math.random(Orbs)

    self.x = x - 16
    self.y = y - 16
    self.width = 16
    self.height = 16

    self.dy = 0

    self.inPlay = true
end

function ElementalOrb:update(dt)
    self.dy = self.dy + ELEMENTAL_SPEED * dt
    self.y = self.y + self.dy
end

function ElementalOrb:hit()
    self.inPlay = false
end

function ElementalOrb:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
        gFrames['elemental_orbs'][self.skin],
        self.x, self.y)
    end
end