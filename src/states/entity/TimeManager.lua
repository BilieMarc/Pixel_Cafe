TimeManager = class{__includes = BaseEntity}

function TimeManager:init(currentDate, customerManager)
    -- Default to start hour 8 (8:00 AM)
    self.dayTime = 8 * 60
    
    -- 1 real second = 15 game minutes
    self.timeScale = 15

    self.currentDate = currentDate
    self.customerManager = customerManager
    self.isFrozen = false
end

function TimeManager:update(dt)
    if not self.isFrozen then
        self.dayTime = self.dayTime + self.timeScale * dt
    end
    local currentHour = math.floor(self.dayTime / 60)
    
    -- Night time transition (8:00 PM / 20 hours)
    if currentHour >= 20 and not self.isFrozen then
        DataManager:dateDataSave(self.currentDate)
        self.dayTime = 20 * 60
        self.isFrozen = true
        
        if self.customerManager then
            self.customerManager:stopSpawning()
        end
        
        gStateStack:push(ClosingState(self.customerManager))
    end
end

function TimeManager:render()
    -- Timer UI
    local hours = math.floor(self.dayTime / 60)
    local exactMinutes = math.floor(self.dayTime % 60)
    
    -- Snap to nearest 15 minutes below current
    local displayMinutes = math.floor(exactMinutes / 15) * 15
    
    local period = "A.M."
    local displayHour = hours % 24
    if displayHour >= 12 then
        period = "P.M."
    end
    
    displayHour = displayHour % 12
    if displayHour == 0 then
        displayHour = 12
    end
    
    local timeString = string.format("%02d:%02d", displayHour, displayMinutes)
    
    love.graphics.setFont(gFonts['medium'])
    -- Render time string
    love.graphics.print(timeString, VIRTUAL_WIDTH - 90, 2)
    -- Render period separately to prevent moving right and left
    love.graphics.print(period, VIRTUAL_WIDTH - 42, 2)
end

function TimeManager:devTimeSkip()
    self.dayTime = 20 * 60
end