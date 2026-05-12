StartMenu = class{__includes = BaseState}

function StartMenu:init()
    self.type = 'StartMenu'

    self.playButton = Button(BUTTON_PARAMS['Play'])
    self.newButton = Button(BUTTON_PARAMS['New'])
    self.settingsButton = Button(BUTTON_PARAMS['StartSettings'])
    self.background = StartMenuBackground()

    if love.filesystem.getInfo(SAVE_FILE) then
        self.playButton:enable()
    end

    self.interactables = {
        self.playButton,
        self.newButton,
        self.settingsButton,
    }

    gStateStack:push(self.background)
    gStateStack:push(self.playButton)
    gStateStack:push(self.newButton)
    gStateStack:push(self.settingsButton)

    -- Start music when the window opens
    if gMusic and not gMusic:isPlaying() then
        gMusic:setVolume(gSettings.musicVolume)
        gMusic:play()
    end
end

function StartMenu:update(dt)
    self:mouseResponse()
end

function StartMenu:render()
end