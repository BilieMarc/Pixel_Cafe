PauseMenu = class {__includes = BaseState}

function PauseMenu:init()
    local card = UI_CARD
    local btnW = 100
    local btnH = 16
    local btnX = card.x + card.width / 2 - btnW / 2
    local btnStartY = card.y + 55
    local spacing = 22

    self.resumeButton = Button({
        text = 'Resume',
        x = btnX,
        y = btnStartY,
        desired_width = btnW,
        desired_height = btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
        end,
        clickable = true,
    })

    self.restartButton = Button({
        text = 'Restart',
        x = btnX,
        y = btnStartY + spacing,
        desired_width = btnW,
        desired_height = btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
            gStateStack:clear()
            gTodayMoney = 0
            gStateStack:push(PlayState())
        end,
        clickable = true,
    })

    self.quitButton = Button({
        text = 'Quit',
        x = btnX,
        y = btnStartY + spacing * 2,
        desired_width = btnW,
        desired_height = btnH,
        action = function()
            gStateStack:clear()
            gStateStack:resume()
            gStateStack:clear()
            gMoney = nil
            gTodayMoney = nil
            gStateStack:push(StartMenu())
        end,
        clickable = true,
        isQuit = true,
    })

    self.buttons = {
        self.resumeButton,
        self.restartButton,
        self.quitButton,
    }

    self.interactables = self.buttons
end

function PauseMenu:update(dt)
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('p') then
        gStateStack:clear()
        gStateStack:resume()
        return
    end

    for _, btn in ipairs(self.buttons) do
        btn:update(dt)
    end

    self:mouseResponse()
end

function PauseMenu:render()
    local card = UI_CARD

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 6, 6)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', card.x, card.y + 6, card.width, 'center')

    for _, btn in ipairs(self.buttons) do
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
    end
end