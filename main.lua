require 'src/dependencies'

-- I will make random natural dirt generation later
--I will direct to user State after entering playState and I have this problem that if user accidentally clicks p, they can't recover their last position
--firstly, work on settingState 
--in switching to pause state, say do you really want to switch or not and if you want to pause, just click u, or you may not be
--able to back up your changes
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle("Elemental Flight")

    -- initialize our nice-looking retro text fonts
    gFonts = {
        ['extra-small'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['small'] = love.graphics.newFont('fonts/font.ttf', 24),                  
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 48),
        ['extra-large'] = love.graphics.newFont('fonts/font.ttf', 84)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
        ['main'] = love.graphics.newImage('graphics/sprites.png'),
        ['arrows'] = love.graphics.newImage('graphics/Ui/arrows.png'),

        --this is for obstacles and additional features
        ['pipes'] = love.graphics.newImage('graphics/obstacles/pipes.png')
    }

    gFrames = {
        --this is for basic UI and states
        ['birds'] = GenerateQuadsBird(gTextures['main']),
        ['backgrounds'] = GenerateQuadsBackground(gTextures['backgrounds']),
        ['arrows'] = GenerateQuadsArrows(gTextures['arrows']),

        --this is for powerups and orbs(elemental)
        ['elemental_orbs'] = GenerateQuadsElementalOrbs(gTextures['main']),

        --this is for obstacles
        ['pipes'] = GenerateQuadsPipes(gTextures['pipes'])
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
        vsync = true
    })

    gSounds = {
        ['selection'] = love.audio.newSource('sounds/selection.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.mp3', 'static')
    }

    -- Kick off music
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    --stateMachine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['instructions'] = function() return InstructionState() end,
        ['setting'] = function() return SettingState() end,
        ['achievements'] = function() return AchievementState() end,
        ['highScore'] = function() return HighScoreState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['game-over'] = function() return GameOverState() end,
        ['enter-high-score'] = function() return EnterHighScoreState end
    }
    gStateMachine:change('start', {
        highScores = LoadHighScores(),
        achievements = LoadAchievements()
    })

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'p' then
        if gStateMachine:getCurrentStateName() ~= 'start' then
            gStateMachine:change('pause',{
                state = gStateMachine:getCurrentStateName()
            })
        end
    end

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y ,button)
    love.mouse.keysPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.keysPressed[button]
end

function love.update(dt)
    -- if not Sound_effect then
    --     for name, sound in pairs(gSounds) do
    --         if name ~= 'music' then
    --             sound:stop()
    --         end
    --     end
    -- end

    if not Music then
        gSounds['music']:stop()
    else
        gSounds['music']:play()
    end

    if love.keyboard.wasPressed('u') --[[and gStateMachine:getCurrentStateName() ~= 'setting']] then
        if Scrolling then
            Scrolling = false
        else
            Scrolling = true
        end
    end

    if gStateMachine:getCurrentStateName() == 'pause' then -- this is to stop scrolling = false in pause state
        Scrolling = true
    end

    if Scrolling then
        BackgroundScroll = (BackgroundScroll + BACKGROUND_SCROLLING_SPEED * dt) % BACKGROUND_LOOPING_POINT

        gStateMachine:update(dt)
    elseif gStateMachine:getCurrentStateName() == 'start' then
        Scrolling = true
        BackgroundScroll = (BackgroundScroll + BACKGROUND_SCROLLING_SPEED * dt) % BACKGROUND_LOOPING_POINT

        gStateMachine:update(dt)
    end

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.draw()
    push:apply('start')

    --just fix pipes and make sure to get well with levels and heart
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][Skin], 
        -BackgroundScroll, 0,
        0
    )

    gStateMachine:render()

    if not Scrolling then   --render it here to make it outstanding
        love.graphics.setFont(gFonts['extra-large'])
        love.graphics.print("Pause", VIRTUAL_WIDTH / 2 - 42, VIRTUAL_HEIGHT / 2 - 42)
    end

    DisplayFPS()

    push:apply('end')
end

function DisplayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function Test()
    love.graphics.print('Test:' .. tostring(-BackgroundScroll), 5, 16)
end

-- --this is for later purposes
-- function LoadInstructions()
--     -- Initialize an empty array to store the instructions
--     local Instructions = {}
--     local currentHeading = nil  -- To keep track of the current heading

--     -- Attempt to load the instructions from the file
--     local data, success = love.filesystem.read("README/instructions.txt")

--     -- Check if the file was successfully loaded
--     if success then
--         -- Split the file content into lines and store them in the instructions array
--         for line in data:gmatch("[^\r\n]+") do
--             -- Check if the line starts with a special character to identify headings
--             local isHeading = line:sub(1, 1) == "#"  -- You can choose a different character if needed

--             if isHeading then
--                 -- Remove the special character and set it as the current heading
--                 currentHeading = line:sub(2)
--             else
--                 -- If it's not a heading, add it to the instructions with the current heading (if available)
--                 local entry = {
--                     heading = currentHeading,
--                     text = line
--                 }
--                 table.insert(Instructions, entry)
--             end
--         end
--     else
--         -- Handle the case when the file couldn't be loaded
--         print("Failed to load instructions.txt")
--     end

--     -- Return the loaded instructions
--     return Instructions
-- end

function LoadHighScores()
    love.filesystem.setIdentity('elemental_flight')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('elemental_flight.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring((i - 1) * 1000) .. '\n'
        end

        love.filesystem.write('elemental_flight.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('elemental_flight.lst') do
        if name then
            -- Trim the name to be between 3 and 16 characters
            local trimmedName = string.sub(line, 1, 16)
            trimmedName = string.sub(trimmedName, 1, math.min(16, #trimmedName))
            trimmedName = string.sub(trimmedName, 1, math.max(3, #trimmedName))
            scores[counter].name = trimmedName
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

function LoadAchievements()
    love.filesystem.setIdentity('elemental_flight')

    -- Define the file path for achievements data
    local achievementsFile = 'elemental_flight_achievements.lst'

    -- Create an empty table to store achievements with their values (true/false or numeric)
    -- Create a table to store achievements with values and descriptions
    local achievements = {
        ["Elementalist"] = {
            value = false,
            description = "Collect all elemental orbs in a single run."
        },
        ["FlawlessFlight"] = {
            value = 0,
            description = "Clear a certain number of obstacles without taking any damage."
        },
        ["SpeedDemon"] = {
            value = 0,
            description = "Reach a certain speed milestone in the game."
        },
        ["FireWalker"] = {
            value = 0,
            description = "Clear a certain number of fire obstacles without changing your elemental type."
        },
        ["AquaticAdventurer"] = {
            value = 0,
            description = "Clear a certain number of water obstacles without changing your elemental type."
        },
        ["ElectrifyingEscape"] = {
            value = 0,
            description = "Clear a certain number of lightning obstacles without changing your elemental type."
        },
        ["MasterShapeShifter"] = {
            value = 0,
            description = "Change your elemental type a certain number of times in a single run."
        },
        ["OrbHoarder"] = {
            value = 0,
            description = "Collect a certain number of orbs in total."
        },
        ["BarrierBreaker"] = {
            value = 0,
            description = "Clear a certain number of wall obstacles without taking any damage."
        },
        ["PillarJumper"] = {
            value = 0,
            description = "Clear a certain number of pillar obstacles without taking any damage."
        }
    }

    -- If the file doesn't exist, initialize it with default achievements (all set to their initial values)
    if not love.filesystem.getInfo(achievementsFile) then
        -- Serialize the default achievements table to a string
        local defaultAchievementsString = ''
        for achievement, data in pairs(achievements) do
            defaultAchievementsString = defaultAchievementsString .. achievement .. '\n'
            defaultAchievementsString = defaultAchievementsString .. tostring(data.value) .. '\n'
        end        

        -- Write the default achievements data to the file
        love.filesystem.write(achievementsFile, defaultAchievementsString)
    end

    -- Read and parse the achievements data from the file
    local name = true  -- Flag for whether we're reading a name or not
    local currentAchievement = nil

    for line in love.filesystem.lines(achievementsFile) do
        if name then
            currentAchievement = line
        else
            -- Check if the achievement has a numeric value
            if achievements[currentAchievement] ~= true or achievements[currentAchievement] ~= false then
                achievements[currentAchievement] = tonumber(line) or achievements[currentAchievement]
            else
                -- If not numeric, assume it's a boolean value
                achievements[currentAchievement] = line == "true"
            end
        end

        -- Flip the name flag
        name = not name
    end

    return achievements
end


--[[
    Renders hearts based on how much health the player has. First renders
    full hearts, then empty hearts for however much health we're missing.
]]
function RenderHealth(health)
    -- start of our health rendering
    local healthX = VIRTUAL_WIDTH - 100
    
    -- render health left
    for i = 1, health do
        love.graphics.draw(gTextures['main'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['main'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

--[[
    Simply renders the player's score at the top right, with left-side padding
    for the score number.
]]
function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end


