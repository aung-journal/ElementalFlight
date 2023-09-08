PauseState = Class{__includes = BaseState}

local highlighted = 1
local scrollOffset = 0
local maxOptions = 3  -- Total number of options displayed on the screen
local maxScroll = 0   -- Maximum scroll position based on the total number of options

function PauseState:enter(params)
    self.previousState = params.state
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('down') then
        highlighted = math.min(maxOptions, highlighted + 1)
        gSounds['selection']:play()
        -- Handle scrolling
        if highlighted > maxOptions - scrollOffset then
            scrollOffset = math.min(maxScroll, scrollOffset + 1)
        end
    elseif love.keyboard.wasPressed('up') then
        highlighted = math.max(1, highlighted - 1)
        gSounds['selection']:play()
        -- Handle scrolling
        if highlighted < 1 + scrollOffset then
            scrollOffset = math.max(0, scrollOffset - 1)
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == 1 then
            gStateMachine:change('start', {
                highScores = LoadHighScores()
            })
        elseif highlighted == 2 then
            gStateMachine:change(tostring(self.previousState), {
                score = 0
            })
        elseif highlighted == 3 then
            gStateMachine:change(tostring(self.previousState), false)
        end
    end
end

function PauseState:render()
    love.graphics.setFont(gFonts['large'])

    local options = {"Main Menu", "Restart", "Back"}

    for i = 1, maxOptions do
        local optionIndex = i + scrollOffset

        if i == 2 and self.previousState == 'setting' then --this is not rendering restart in pause state
            goto continue
        end

        if highlighted == i then
            love.graphics.setColor(103/255, 1, 1, 1)
        end

        local text = options[optionIndex]
        local textWidth = love.graphics.getFont():getWidth(text)
        local textHeight = love.graphics.getFont():getHeight()
        local yPos = (i - 1) * (textHeight + 8) + 70  -- Adjust Y position based on scroll offset
        love.graphics.printf(text, (VIRTUAL_WIDTH - textWidth) / 2, yPos, textWidth, 'center')

        love.graphics.setColor(1, 1, 1, 1)

        ::continue::
    end
end
