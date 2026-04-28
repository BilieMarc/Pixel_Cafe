DayEndState = class{__includes = BaseState}

function DayEndState:init()
    self.nextDayButton = Button(BUTTON_PARAMS['NextDay'])
    self.interactables = {
        self.nextDayButton,
    }
    gStateStack:push(self.nextDayButton)
end

function DayEndState:update(dt)
    self:mouseResponse()
end

function DayEndState:render()
    --Font and text 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('DayEndState', 0, VIRTUAL_HEIGHT / 2 - 6 - 50, VIRTUAL_WIDTH, 'center')
end
