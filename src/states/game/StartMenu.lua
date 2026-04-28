StartMenu = class{__includes = BaseState}

function StartMenu:init()
    self.type = 'StartMenu'

    self.playButton = Button(BUTTON_PARAMS['Play'])
    self.backgroundFrame = gFrames['StartMenuBackground']
    self.interactables = {
        self.playButton,
    }
    gStateStack:push(self.playButton)
end

function StartMenu:update(dt)
    self:mouseResponse()
end

function StartMenu:render()
    --[[Font and text 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Start Menu', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')]]
    love.graphics.draw(self.backgroundFrame, 0, 0, 0, 
        VIRTUAL_WIDTH / self.backgroundFrame:getWidth(), VIRTUAL_HEIGHT / self.backgroundFrame:getHeight())
    self.playButton:render()
end