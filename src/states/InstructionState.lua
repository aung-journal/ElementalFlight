InstructionState = Class{__includes = BaseState}

-- In InstructionState.lua
function InstructionState:enter(params)
    self.instructions = {
        {
            heading = "Main Menu Options:",
            text = "You can change settings in other states by clicking \'p\' and pause by clicking \"u\" which only don't apply in setting.\n.Click escape to quit immediately.\nPlay: Start a new game adventure.\nInstructions: Learn how to play.\nSettings: Customize your game experience.\nAchievements: View your achievements.\nHigh Scores: Check the top player scores.\nUsers: Manage player profiles (if applicable)."
        },
        {
            heading = "Instructions:",
            text = "1. Play:\n\nWhen you choose \"Play,\" the game will start.\nYou'll control the elemental creature's movement by tapping or clicking.\nCollect orbs of your element while avoiding obstacles.\nMatching the elemental orb with your creature's element doesn't penalize you; otherwise, you'll lose health or end the game.\nAchieving specific goals earns you achievements."
        },
        {
            heading = "2. In-Game Play:",
            text = "During gameplay, you'll see your score and collected orbs.\nNew obstacles will appear as you progress.\nCollect elemental orbs and activate temporary power-ups.\nThe game ends when you run out of health or manually quit."
        },
        {
            heading = "3. End Game:",
            text = "After the game ends, you'll see your final score.\nChoose \"Restart\" to begin a new game or \"Main Menu\" to return to the main menu.\nIf your score ranks among the top, enter your name (3 characters) to save it on the leaderboard."
        },
        {
            heading = "4. Instructions:",
            text = "In the \"Play\" section, you can learn how to play the game."
        },
        {
            heading = "5. Settings:",
            text = "Customize game settings such as sound volume and graphics quality.\nReturn to the main menu after making changes."
        },
        {
            heading = "6. Achievements:",
            text = "View all achievements and check which ones you've earned.\nAchievements may grant bonuses during gameplay.\nReturn to the main menu after viewing achievements."
        },
        {
            heading = "7. High Scores:",
            text = "See the top ten player scores.\nCompete for the highest score and bragging rights.\nReturn to the main menu after checking the high scores."
        },
        {
            heading = "8. Users:",
            text = "Manage different player profiles.\nUseful for keeping track of personal high scores and achievements.\nReturn to the main menu after managing user profiles."
        },
        {
            heading = "Enjoy your journey in the magical world of Elemental Flight!",
            text = ""
        }
    }    
    self.currentPage = 1
end

function InstructionState:update(dt)
    -- Handle user input to navigate pages (e.g., arrow keys or buttons)
    if love.keyboard.wasPressed("right") then
        self.currentPage = math.min(self.currentPage + 1, #self.instructions)
    elseif love.keyboard.wasPressed("left") then
        self.currentPage = math.max(self.currentPage - 1, 1)
    end
end

function InstructionState:render()
    love.graphics.setFont(gFonts['small'])
    local currentInstruction = self.instructions[self.currentPage]

    -- Calculate the text width and height
    local textWidth = 512 -- Max width to fit the screen
    local headingHeight = love.graphics.getFont():getHeight() -- Height of heading text
    local textHeight = 288 - headingHeight -- Remaining height for instruction text

    -- Render heading
    love.graphics.printf(currentInstruction.heading, 0, 10, textWidth, "center")

    -- Render instruction text
    love.graphics.printf(currentInstruction.text, 0, headingHeight + 10, textWidth, "left")
end
