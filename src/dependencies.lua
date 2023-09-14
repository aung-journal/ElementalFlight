--This is the library that is used for virtual resolution
push = require 'lib/push'

--This is the library to create classes
Class = require 'lib/class'

-- --This is the library for JSON encoding in lst file
-- json = require 'cjson'

--This is where the main global constants are stored
require 'src/constants'

--This is where the utilities are stored
require 'src/Util'

--Bird Class the one player is going to control
require 'src/Bird'

--Orbs

--Elemental Orbs
require 'src/Orbs/ElementalOrb'

--Obstacles
--This is for pipePair(Pillars)
require 'src/Obstacles/Pipe'
require 'src/Obstacles/PipePair'

--This is for pipePair(Tunnels)
require 'src/Obstacles/HorizontalPipe'
require 'src/Obstacles/HorizontalPipePair'

--This is where the state logic is stored
require 'src/StateMachine'

--states
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/InstructionState'
require 'src/states/SettingState'
require 'src/states/AchievementState'
require 'src/states/HighScoreState'
require 'src/states/PlayState'
require 'src/states/PauseState'
require 'src/states/GameOverState'
require 'src/states/EnterHighScoreState'