StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {} -- [name] -> [function that returns states]
    self.current = self.empty
    self.currentStateName = nil
    self.stateInstances = {}  -- Store state instances for each state name
end

-- Set restart to true by default
function StateMachine:change(stateName, enterParams, restart)
    assert(self.states[stateName]) -- state must exist!
    
    self.current:exit()
    
    if not self.stateInstances[stateName] or restart == nil or restart then
        self.stateInstances[stateName] = self.states[stateName]()
    end
    
    self.current = self.stateInstances[stateName]
    
    self.current:enter(enterParams)
    self.currentStateName = stateName
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end

function StateMachine:getCurrentStateName()
    return self.currentStateName
end
