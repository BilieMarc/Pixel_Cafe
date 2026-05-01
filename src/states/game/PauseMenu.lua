PauseMenu = class {__includes = BaseState}

function PauseMenu:init()
    self.resumeButton = Button(BUTTON_PARAMS['Resume'])

    self.restartButton = Button(BUTTON_PARAMS['Restart'])

    self.quitButton = Button(BUTTON_PARAMS['PauseQuit'])

    self.interactables = {
        self.resumeButton,
        self.restartButton,
        self.quitButton,
    }

    gStateStack:push(PauseMenuCard())
    for _, btn in ipairs(self.interactables) do
        gStateStack:push(btn)
    end
end

function PauseMenu:update(dt)
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('p') then
        gStateStack:clear()
        gStateStack:resume()
        return
    end

    self:mouseResponse()
end

function PauseMenu:render()
    --[[local card = UI_CARD

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(gColors['white'])
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', card.x, card.y + 6, card.width, 'center')
    love.graphics.setColor(gColors['white'])

    --[[for _, btn in ipairs(self.interactables) do
        if btn.isQuit then
            local origRender = nil
            love.graphics.setColor(0.8, 0.25, 0.25, 1)
            love.graphics.rectangle('fill', btn.x, btn.y, btn.desired_width, btn.desired_height)
            love.graphics.setColor(0.5, 0.1, 0.1, 1)
            love.graphics.rectangle('line', btn.x, btn.y, btn.desired_width, btn.desired_height)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(gFonts['small'])
            local buffer = math.max(1, math.abs(btn.desired_height - btn.y) * 0.05)
            love.graphics.printf(btn.text, btn.x, btn.y + buffer, btn.desired_width, 'center')
        else
            btn:render()
        end
    end]]
end