SettingsState = class{__includes = BaseState}

local function drawPixelSlider(fraction, opt, x, y, w, h)
    local trackH = 4
    local trackY = y + math.floor((h - trackH) / 2)

    love.graphics.setColor(0.08, 0.08, 0.12, 1)
    love.graphics.rectangle('fill', x, trackY, w, trackH)

    love.graphics.setColor(0.22, 0.22, 0.3, 1)
    love.graphics.rectangle('fill', x, trackY + trackH, w, 1)

    local fillW = math.floor(w * fraction)
    if fillW > 0 then
        love.graphics.setColor(0.4, 0.6, 1.0, 1)
        love.graphics.rectangle('fill', x, trackY, fillW, trackH)
    end

    local knobSize = 8
    local knobX = x + fillW - math.floor(knobSize / 2)
    local knobY = y + math.floor((h - knobSize) / 2)
  
    love.graphics.setColor(0.85, 0.85, 0.95, 1)
    love.graphics.rectangle('fill', knobX, knobY, knobSize, knobSize)

    love.graphics.setColor(0.15, 0.15, 0.2, 1)
    love.graphics.rectangle('line', knobX, knobY, knobSize, knobSize)

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.line(knobX + 1, knobY + 1, knobX + knobSize - 2, knobY + 1)
    love.graphics.line(knobX + 1, knobY + 1, knobX + 1, knobY + knobSize - 2)
end

function SettingsState:init()
    self.backButton = Button(BUTTON_PARAMS['SettingsBack'])
    self.musicSliderData = {value = gSettings.musicVolume, min = 0, max = 1}
    self.sfxSliderData = {value = gSettings.sfxVolume, min = 0, max = 1}
    
    self.interactables = {
        self.backButton
    }
end

function SettingsState:update(dt)
    local card = UI_CARD
    local sliderX = card.x + 75
    local sliderW = 120

    if suit.Slider(self.musicSliderData, {id='music', draw=drawPixelSlider}, sliderX, card.y + 50, sliderW, 16).changed then
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

    if suit.Slider(self.sfxSliderData, {id='sfx', draw=drawPixelSlider}, sliderX, card.y + 85, sliderW, 16).changed then
        gSettings.sfxVolume = self.sfxSliderData.value
        if gSounds and gSounds['click'] then
            gSounds['click']:setVolume(gSettings.sfxVolume)
            if gSettings.sfxVolume == 0 then
                gSounds['click']:stop()
            end
        end
    end

    self:mouseResponse()

    love.mouse.keysPressed = {}
    love.keyboard.keysPressed = {}
end

function SettingsState:render()
    local card = UI_CARD

    love.graphics.setColor(0.12, 0.12, 0.18, 1.0)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 10, 10)

    love.graphics.setLineWidth(2)
    love.graphics.setColor(0.3, 0.3, 0.4, 1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 10, 10)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('SETTINGS', card.x, card.y + 10, card.width, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    
    love.graphics.setColor(0.8, 0.8, 0.9, 1)
    love.graphics.print('Music', card.x + 20, card.y + 50)
    love.graphics.printf(string.format('%d%%', math.floor(self.musicSliderData.value * 100)), card.x + 195, card.y + 50, 45, 'right')

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
