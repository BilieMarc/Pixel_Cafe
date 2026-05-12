SettingsState = class{__includes = BaseState}

function SettingsState:init()
    self.backButton = Button(BUTTON_PARAMS['SettingsBack'])
    self.musicSliderData = {value = gSettings.musicVolume, min = 0, max = 1}
    self.sfxSliderData = {value = gSettings.sfxVolume, min = 0, max = 1}
    
    self.interactables = {
        self.backButton
    }

    -- Custom theme for Settings
    self.theme = {
        cornerRadius = 8,
        color = {
            normal   = {bg = {0.2, 0.2, 0.25, 1}, fg = {0.7, 0.7, 0.8, 1}},
            hovered  = {bg = {0.3, 0.3, 0.4, 1},  fg = {0.9, 0.9, 1.0, 1}},
            active   = {bg = {0.4, 0.6, 1.0, 1},  fg = {1, 1, 1, 1}}
        }
    }
end

function SettingsState:update(dt)
    local card = UI_CARD
    local sliderX = card.x + 75
    local sliderW = 120

    -- Handle sliders with custom theme
    if suit.Slider(self.musicSliderData, {id='music', theme=self.theme}, sliderX, card.y + 50, sliderW, 16).changed then
        gSettings.musicVolume = self.musicSliderData.value
        if gMusic then
            gMusic:setVolume(gSettings.musicVolume)
            if gSettings.musicVolume == 0 then
                gMusic:pause()
            elseif not gMusic:isPlaying() then
                gMusic:play()
            end
        end
    end

    if suit.Slider(self.sfxSliderData, {id='sfx', theme=self.theme}, sliderX, card.y + 85, sliderW, 16).changed then
        gSettings.sfxVolume = self.sfxSliderData.value
        if gSounds and gSounds['click'] then
            gSounds['click']:setVolume(gSettings.sfxVolume)
            if gSettings.sfxVolume == 0 then
                gSounds['click']:stop()
            end
        end
    end

    self:mouseResponse()

    -- Consume input
    love.mouse.keysPressed = {}
    love.keyboard.keysPressed = {}
end

function SettingsState:render()
    local card = UI_CARD

    -- Draw background card - solid opaque color with nice border
    love.graphics.setColor(0.12, 0.12, 0.18, 1.0)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 10, 10)

    love.graphics.setLineWidth(2)
    love.graphics.setColor(0.3, 0.3, 0.4, 1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 10, 10)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('SETTINGS', card.x, card.y + 10, card.width, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    
    -- Music Label & Percent
    love.graphics.setColor(0.8, 0.8, 0.9, 1)
    love.graphics.print('Music', card.x + 20, card.y + 50)
    love.graphics.printf(string.format('%d%%', math.floor(self.musicSliderData.value * 100)), card.x + 195, card.y + 50, 45, 'right')

    -- SFX Label & Percent
    love.graphics.print('SFX', card.x + 20, card.y + 85)
    love.graphics.printf(string.format('%d%%', math.floor(self.sfxSliderData.value * 100)), card.x + 195, card.y + 85, 45, 'right')

    self.backButton:render()
    
    suit.draw()
end

function SettingsState:getInteractAt()
    for _, c in ipairs(self.interactables) do
        if c:isMouseOver() then
            return c
        end
    end
    return nil
end
