PauseMenu = class {__includes = BaseState}

function PauseMenu:init()
    self.resumeButton = Button(BUTTON_PARAMS['Resume'])
    self.interactables = {
        self.resumeButton,
    }
    gStateStack:push(self.resumeButton)
end

function PauseMenu:update(dt)
    self:mouseResponse()
end

function PauseMenu:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.print('PauseMenu', 40, 0)
end