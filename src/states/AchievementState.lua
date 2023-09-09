AchievementState = Class{__includes = BaseState}

local startIndex = 1  -- Index of the first visible achievement
local achievementsPerPage = 3  -- Number of achievements to display per page

function AchievementState:enter(params)
    self.achievements = LoadAchievements()
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

    love.graphics.setFont(gFonts['small'])

    -- Iterate over visible achievements based on the startIndex and achievementsPerPage
    for i = startIndex, startIndex + achievementsPerPage - 1 do
        local achievement = self.achievements[i]  -- Access the achievement data from the global table
        local description = achievement.description
        
        if achievement then
            
            -- Render the achievement here, including its description and status
            -- You can use achievement.value and achievement.description
            -- Render each achievement on a separate line, adjusting the Y position accordingly

            -- Achievement number (1-10)
            love.graphics.printf(tostring(i) .. '.', 10, 
            50 + (i - startIndex) * 80, 50, 'left')

            -- Achievement description
            love.graphics.printf(tostring(description), 48, 
                50 + (i - startIndex) * 80, 312, 'center')
            
            -- The completion status of the achievement
            love.graphics.printf(tostring(achievement.value), VIRTUAL_WIDTH / 3 + 170,
                50 + (i - startIndex) * 80, 100, 'right')
        end
    end
end

