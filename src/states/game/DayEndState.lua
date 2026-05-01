DayEndState = class{__includes = BaseState}

function DayEndState:init()
    self._dailySalesAmount = gDailySales or 0
    self._dailyTipsAmount = gDailyTips or 0
    self._startingBalance = gStartingBalance or (gMoney or 0)
    
    self._earnedToday = self._dailySalesAmount + self._dailyTipsAmount
    self._finalTotal = self._startingBalance + self._earnedToday

    gCurrentDay = gCurrentDay or 1

    local card = UI_CARD
    -- Ensure card stays fixed size (restoring original height)
    card.height = 140 

    self.nextDayButton = Button(BUTTON_PARAMS['NextDay'])
    self.quitButton = Button(BUTTON_PARAMS['Quit'])

    self.interactables = {
        self.nextDayButton,
        self.quitButton
    }

    self.card = DayEndStateCard({earnedToday = self._earnedToday, finalTotal = self._finalTotal})
    gStateStack:push(self.card)
    for _, btn in ipairs(self.interactables) do
        gStateStack:push(btn)
    end
end

function DayEndState:update(dt)
    self:mouseResponse()
end

function DayEndState:render()
    local card = UI_CARD

    --[[love.graphics.setColor(0, 0, 0, 150 / 255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(card.color)
    love.graphics.rectangle('fill', card.x, card.y, card.width, card.height, 8, 8)

    love.graphics.setColor(card.border)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', card.x, card.y, card.width, card.height, 8, 8)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('DAY END', card.x, card.y + 12, card.width, 'center')

    love.graphics.setFont(gFonts['medium'])
    
    local line1Y = card.y + 45
    local line2Y = card.y + 65
    local labelOffset = 20

    -- Line 1: EARNED
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('EARNED:', card.x + labelOffset, line1Y)
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.printf(string.format('$%.2f', self._earnedToday), card.x, line1Y, card.width - labelOffset, 'right')
    
    -- Line 2: TOTAL
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('TOTAL:', card.x + labelOffset, line2Y)
    love.graphics.setColor(0.2, 0.8, 0.2, 1)
    love.graphics.printf(string.format('$%.2f', self._finalTotal), card.x, line2Y, card.width - labelOffset, 'right')

    love.graphics.setColor(1, 1, 1, 1)]]
end
