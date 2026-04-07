--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    -- Guard against empty stack to avoid nil state access when no states remain.
    if #self.states > 0 then
        self.states[#self.states]:update(dt)
    end
end

function StateStack:processAI(params, dt)
    -- Only process AI on the active state and only if it defines processAI.
    if #self.states > 0 and self.states[#self.states].processAI then
        self.states[#self.states]:processAI(params, dt)
    end
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

function StateStack:pop()
    -- Safely remove the current state if the stack is not empty.
    if #self.states > 0 then
        self.states[#self.states]:exit()
        table.remove(self.states)
    end
end