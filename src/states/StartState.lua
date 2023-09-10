StartState = Class{__includes = BaseState}

local highlighted = 1

local options = 7


function StartState:enter(params)
    self.highScores = params.highScores
    self.achievements = params.achievements
end


function StartState:update(dt)
    if love.keyboard.wasPressed('down') then
        highlighted = math.min(options, highlighted + 1)
        gSounds['selection']:play()
    elseif love.keyboard.wasPressed('up') then
        highlighted = math.max(1, highlighted - 1)
        gSounds['selection']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('play', {
                highScores = self.highScores,
                hearts = 3,
                score = 0
            })
        elseif highlighted == 2 then
            gStateMachine:change('instructions')
        elseif highlighted == 3 then
            gStateMachine:change('setting')
        elseif highlighted == 4 then
            gStateMachine:change('achievements', {
                achievements = self.achievements
            })
        elseif highlighted == 5 then
            gStateMachine:change('highScore', {
                highScores = self.highScores
            })
        elseif highlighted == 7 then
            love.event.quit()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("ELEMENTAL FLIGHT", 0, 20,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    -- Define your menu options
    local menuOptions = {
        "Play",
        "Instructions",
        "Settings",
        "Achievements",
        "HighScores",
        "Users",
        "Exit"
    }

    -- Loop through the menu options and render them
    for i, option in ipairs(menuOptions) do
        -- If we're highlighting this option, render it blue
        if highlighted == i then
            love.graphics.setColor(103/255, 1, 1, 1)
        end
        
        -- Calculate the vertical position based on the index
        local yPos = 70 + (i - 1) * 30
        
        -- Render the option
        love.graphics.printf(option, 0, yPos, VIRTUAL_WIDTH, 'center')
        
        -- Reset the color
        love.graphics.setColor(1, 1, 1, 1)
    end
end