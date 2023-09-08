AchievementState = Class{__includes = BaseState}

local startIndex = 1  -- Index of the first visible achievement
local achievementsPerPage = 5  -- Number of achievements to display per page

function AchievementState:enter(params)
    self.achievements = LoadAchievements()
    self.names = {
        "Elementalist",
        "FlawlessFlight",
        "SpeedDemon",
        "FireWalker",
        "AquaticAdventurer",
        "ElectrifyingEscape",
        "MasterShapeShifter",
        "OrbHoarder",
        "BarrierBreaker",
        "PillarJumper"
    }
end

function AchievementState:update(dt)
    if love.keyboard.wasPressed('up') then
        startIndex = math.max(1, startIndex - 1)
    end

    if love.keyboard.wasPressed('down') then
        startIndex = math.min(#self.achievements - achievementsPerPage + 1, startIndex + 1)
    end
end

function AchievementState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Achievements', 0, 0, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(gFonts['medium'])

    -- Iterate over visible achievements based on the startIndex and achievementsPerPage
    for i = startIndex, startIndex + achievementsPerPage - 1 do
        local name = self.names[i]
        local nameWidth = love.graphics.getFont():getWidth(name)
        local achievement = self.achievements[name]  -- Access the achievement data from the global table
        
        if achievement then
            
            -- Render the achievement here, including its description and status
            -- You can use achievement.value and achievement.description
            -- Render each achievement on a separate line, adjusting the Y position accordingly

            -- Achievement number (1-10)
            love.graphics.printf(tostring(i) .. '.', 10, 
            50 + (i - startIndex) * 50, 50, 'left')

            -- Achievement name
            love.graphics.printf(tostring(name), 48, 
                50 + (i - startIndex) * 50, nameWidth, 'right')
            
            -- The completion status of the achievement
            love.graphics.printf(tostring(0), VIRTUAL_WIDTH / 3 + 170,
                50 + (i - startIndex) * 50, 100, 'right')
        end
    end
end

