PlayState = class {__includes = BaseState}

function PlayState:init()

end

function PlayState:update(dt)
    self.customerState:update(dt)
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- End PlayState and enters DayEndState
        gStateStack:pop()
        gStateStack:push(DayEndState())
        return
    end
    
    -- Update timer
    self.dayTime = self.dayTime + self.timeScale * dt
    local currentHour = math.floor(self.dayTime / 60)
    
    -- Night time transition (8:00 PM / 20 hours)
    if currentHour >= 20 then
        gStateStack:pop()
        gStateStack:push(DayEndState())
    end

    gStateStack:push(self.coffeeMachine)
end

function PlayState:render()
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20, VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)
    love.graphics.rectangle('line', 10, 25, 30, 0.40 * VIRTUAL_HEIGHT - 5)
end