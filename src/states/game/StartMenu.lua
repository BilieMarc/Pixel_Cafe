StartMenu = class{__includes = BaseState}

function StartMenu:init()
    self.type = 'StartMenu'

    self.playButton = Button(BUTTON_PARAMS['Play'])
    self.newButton = Button(BUTTON_PARAMS['New'])
    self.background = StartMenuBackground()

    if love.filesystem.getInfo(SAVE_FILE) then
        self.playButton:enable()
    end

    self.interactables = {
        self.playButton,
        self.newButton,
    }

    gStateStack:push(self.background)
    gStateStack:push(self.playButton)
    gStateStack:push(self.newButton)
end

function StartMenu:update(dt)
    self:mouseResponse()
end

function StartMenu:render()
end