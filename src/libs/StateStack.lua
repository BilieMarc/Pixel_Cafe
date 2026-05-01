--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = class{}

function StateStack:init()
    self.states = {}
    self.paused = false
    self.pausedTable = {}
end

function StateStack:update(dt)
    if self.paused then
            for i = #self.pausedTable, 1, -1 do
            local state = self.pausedTable[i]
            if state then
                state:update(dt)
            end
        end
    else
        for i = #self.states, 1, -1 do
            local state = self.states[i]
            if state then
                state:update(dt)
            end
        end
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
        love.graphics.setColor(gColors['white'])
        state:render()
    end

    if self.paused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(gColors['white'])
        
        for i, state in ipairs(self.pausedTable) do
            love.graphics.setColor(gColors['white'])
            state:render()
        end
    end
end

function StateStack:clear()
    if self.paused then
        self.pausedTable = {}
    else
        self.states = {}
    end
end

function StateStack:push(state)
    if self.paused then
        table.insert(self.pausedTable, state)
    else
        table.insert(self.states, state)
    end
    state:enter()
end

function StateStack:pop(state)
    -- Safely remove the current state if the stack is not empty.
    if #self.states > 0 then
        if state then
            for i = #self.states, 1, -1 do
                if self.states[i] == state then
                    self.states[i]:exit()
                    table.remove(self.states, i)
                    break -- Stop once we find and remove it
                end
            end
        else
            self.states[#self.states]:exit()
            table.remove(self.states)
        end
    end
end

function StateStack:pause()
    self.paused = true
end

function StateStack:resume()
    self.paused = false
end