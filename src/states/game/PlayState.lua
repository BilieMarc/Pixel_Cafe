PlayState = class {__includes = BaseState}

function PlayState:init()
    -- Default to start hour 8 (8:00 AM)
    self.dayTime = 8 * 60
    
    -- 1 real second = 15 game minutes
    self.timeScale = 15
    
    self.customerState = CustomerState()
end

function PlayState:enterParams(params)
    -- If timeOfDay is provided in params, update dayTime
    if params and params.timeOfDay then
        self.dayTime = params.timeOfDay * 60
    end
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
end

function PlayState:render()
    love.graphics.rectangle('line', 0, 0, VIRTUAL_WIDTH, 20)
    love.graphics.rectangle('line', 0, 0.40 * VIRTUAL_HEIGHT + 20, VIRTUAL_WIDTH, 0.75 * VIRTUAL_HEIGHT)
    love.graphics.rectangle('line', 10, 25, 30, 0.40 * VIRTUAL_HEIGHT - 5)
    
    -- Timer UI
    local hours = math.floor(self.dayTime / 60)
    local minutes = math.floor(self.dayTime % 60)
    
    local period = "A.M."
    local displayHour = hours % 24
    if displayHour >= 12 then
        period = "P.M."
    end
    
    displayHour = displayHour % 12
    if displayHour == 0 then
        displayHour = 12
    end
    
    local timeString = string.format("%02d:%02d %s", displayHour, minutes, period)
    love.graphics.setFont(PixelFont)
    love.graphics.print(timeString, VIRTUAL_WIDTH - 90, 2)
    
    self.customerState:render()
end